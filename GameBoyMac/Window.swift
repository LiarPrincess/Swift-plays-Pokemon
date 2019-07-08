// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import AppKit
import MetalKit
import GameBoyKit

internal let framebufferWidth  = Int(Lcd.width)
internal let framebufferHeight = Int(Lcd.height)

public class Window: NSWindow, GameboyInput, MTKViewDelegate {

  private var gameBoy: GameBoy! // swiftlint:disable:this implicitly_unwrapped_optional
  private let mtkView: MTKView

  private let device:       MTLDevice
  private let pipeline:     MTLRenderPipelineState
  private let commandQueue: MTLCommandQueue
  private let vertexBuffer: MTLBuffer
  private let texture:      MTLTexture

  public override var canBecomeKey:  Bool { return true }
  public override var canBecomeMain: Bool { return true }

  public init() {
    let scale = 3
    let width  = Int(Lcd.width)  * scale
    let height = Int(Lcd.height) * scale

    self.mtkView = MTKView()

    self.device = createDevice()
    let library       = makeLibrary(device: device)
    self.pipeline     = makePipeline(device: device, library: library)
    self.commandQueue = makeCommandQueue(device: device)
    self.vertexBuffer = makeFullscreenVertexBuffer(device: device)
    self.texture      = makeFramebuffer(device: device)

    super.init(contentRect: NSRect(x: 0, y: 0, width: width, height: height),
               styleMask:   [.titled, .closable, .miniaturizable, .resizable],
               backing:     .buffered,
               defer:       false)

    let args = parseArguments()
    self.gameBoy = GameBoy(input: self, bootrom: args.bootrom, cartridge: args.cartridge)

    self.customizeWindow()
    self.embedView()
  }

  private func customizeWindow() {
    self.title = "Gameboy"
    self.backgroundColor = .black
    self.isMovableByWindowBackground = true

    self.setFrameAutosaveName("GameBoyWindow")

    // use this if your resized window, and you dont like new size
    // self.setContentSize(NSSize(width: width, height: height))
  }

  private func embedView() {
    guard let contentView = self.contentView else {
      print("Unable to find window content view.")
      exit(1)
    }

    self.mtkView.device = self.device
    self.mtkView.delegate = self
    self.mtkView.colorPixelFormat = .bgra8Unorm
    self.mtkView.framebufferOnly = true
    self.mtkView.translatesAutoresizingMaskIntoConstraints = false

    contentView.addSubview(self.mtkView)
    NSLayoutConstraint.activate([
      self.mtkView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      self.mtkView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      self.mtkView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      self.mtkView.heightAnchor.constraint(equalTo: contentView.heightAnchor)
    ])
  }

  // MARK: - Input

  private var buttonsState = ButtonsState()
  private var directionKeysState = DirectionKeysState()

  public func getButtonsState() -> ButtonsState {
    return self.buttonsState
  }

  public func getDirectionKeysState() -> DirectionKeysState {
    return self.directionKeysState
  }

  public override func keyDown(with event: NSEvent) {
    self.updateKeyState(event: event, isDown: true)
  }

  public override func keyUp(with event: NSEvent) {
    self.updateKeyState(event: event, isDown: false)
  }

  private func updateKeyState(event: NSEvent, isDown: Bool) {
    if event.isARepeat { return }

    switch event.keyCode {
    case KeyMap.a:      self.buttonsState.a = isDown
    case KeyMap.b:      self.buttonsState.b = isDown
    case KeyMap.start:  self.buttonsState.start = isDown
    case KeyMap.select: self.buttonsState.select = isDown

    case KeyMap.up:     self.directionKeysState.up = isDown
    case KeyMap.down:   self.directionKeysState.down = isDown
    case KeyMap.left:   self.directionKeysState.left = isDown
    case KeyMap.right:  self.directionKeysState.right = isDown

    default:
      // use this if you want to proagate event down the responder chain:
      // super.keyDown(with: event)
      break
    }
  }

  // MARK: - MTKViewDelegate

  public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) { }

  public func draw(in view: MTKView) {
    let frame = self.gameBoy.tickFrame()
    self.updateFramebuffer(from: frame)

    guard let drawable = view.currentDrawable,
          let renderPassDesc = view.currentRenderPassDescriptor else {
        fatalError("Error when rendering Metal frame: unable to obtain drawable.")
    }

    guard let commandBuffer = self.commandQueue.makeCommandBuffer(),
          let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDesc) else {
        fatalError("Error when rendering Metal frame: unable to create command buffer.")
    }

    commandEncoder.setRenderPipelineState(self.pipeline)
    commandEncoder.setVertexBuffer(self.vertexBuffer, offset: 0, index: 0)
    commandEncoder.setFragmentTexture(self.texture, index: 0)
    commandEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
    commandEncoder.endEncoding()

    commandBuffer.present(drawable)
    commandBuffer.commit()
  }

  private func updateFramebuffer(from framebuffer: Framebuffer) {
    let data   = framebuffer.data
    let region = MTLRegionMake2D(0, 0, framebufferWidth, framebufferHeight)

    data.withUnsafeBytes { ptr in
      guard let baseAddress = ptr.baseAddress else { return }
      texture.replace(
        region:      region,
        mipmapLevel: 0,
        withBytes:   baseAddress,
        bytesPerRow: framebufferWidth * MemoryLayout<UInt8>.size
      )
    }
  }
}
