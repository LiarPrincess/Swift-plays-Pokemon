// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import AppKit
import MetalKit
import GameBoyKit

class GameBoyWindow: NSWindow, GameboyInputProvider, MTKViewDelegate {

  // swiftlint:disable:next implicitly_unwrapped_optional
  private(set) var gameBoy: GameBoy!
  let mtkView: MTKView
  let keyMap: KeyMap

  let device:       MTLDevice
  let pipeline:     MTLRenderPipelineState
  let commandQueue: MTLCommandQueue
  let vertexBuffer: MTLBuffer
  let texture:      MTLTexture

  override var canBecomeKey:  Bool { return true }
  override var canBecomeMain: Bool { return true }

  init(scale: Int, bootrom: Bootrom?, cartridge: Cartridge, keyMap: KeyMap) {
    self.mtkView = MTKView()
    self.keyMap = keyMap

    self.device = Metal.createDevice()
    let library       = Metal.makeLibrary(device: self.device)
    self.pipeline     = Metal.makePipeline(device: self.device, library: library)
    self.commandQueue = Metal.makeCommandQueue(device: self.device)
    self.vertexBuffer = Metal.makeFullscreenVertexBuffer(device: self.device)
    self.texture      = Metal.makeFramebuffer(device: self.device)

    super.init(
      contentRect: NSRect(
        x: 0,
        y: 0,
        width: scale * Framebuffer.width,
        height: scale * Framebuffer.height
      ),
      styleMask: [.titled, .closable, .miniaturizable, .resizable],
      backing: .buffered,
      defer: false
    )

    self.gameBoy = GameBoy(
      bootrom: bootrom,
      cartridge: cartridge,
      input: self
    )

    self.customizeWindow(title: cartridge.header.title)
    self.addMtkSubview()
  }

  private func customizeWindow(title: String) {
    self.title = title
    self.backgroundColor = .black
    self.isMovableByWindowBackground = true
    self.center()

    self.setFrameAutosaveName("GameBoyWindow")

    // Use this if you resized window, and you don't like new size
    // self.setContentSize(NSSize(width: width, height: height))
  }

  private func addMtkSubview() {
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

  private var input = GameboyInput()

  func getGameboyInput() -> GameboyInput {
    return input
  }

  override func keyDown(with event: NSEvent) {
    self.updateKeyState(event: event, isDown: true)
  }

  override func keyUp(with event: NSEvent) {
    self.updateKeyState(event: event, isDown: false)
  }

  private func updateKeyState(event: NSEvent, isDown: Bool) {
    if event.isARepeat { return }

    switch event.keyCode {
    case self.keyMap.a.value:      self.input.a = isDown
    case self.keyMap.b.value:      self.input.b = isDown
    case self.keyMap.start.value:  self.input.start = isDown
    case self.keyMap.select.value: self.input.select = isDown
    case self.keyMap.up.value:     self.input.up = isDown
    case self.keyMap.down.value:   self.input.down = isDown
    case self.keyMap.left.value:   self.input.left = isDown
    case self.keyMap.right.value:  self.input.right = isDown

    default:
      // Use this if you want to propagate event down the responder chain:
      // super.keyDown(with: event)
      break
    }
  }

  // MARK: - MTKViewDelegate

  func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) { }

  func draw(in view: MTKView) {
    self.gameBoy.tickFrame()
    self.updateFramebuffer()

    guard let drawable = view.currentDrawable,
          let renderPassDesc = view.currentRenderPassDescriptor else {
        fatalError("Error when rendering Metal frame: unable to obtain drawable.")
    }

    guard let cmdBuffer = self.commandQueue.makeCommandBuffer(),
          let cmdEncoder = cmdBuffer.makeRenderCommandEncoder(descriptor: renderPassDesc) else {
      fatalError("Error when rendering Metal frame: unable to create command buffer.")
    }

    cmdEncoder.setRenderPipelineState(self.pipeline)
    cmdEncoder.setVertexBuffer(self.vertexBuffer, offset: 0, index: 0)
    cmdEncoder.setFragmentTexture(self.texture, index: 0)
    cmdEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
    cmdEncoder.endEncoding()

    cmdBuffer.present(drawable)
    cmdBuffer.commit()
  }

  private func updateFramebuffer() {
    let framebuffer = self.gameBoy.framebuffer
    let region = MTLRegionMake2D(0, 0, Framebuffer.width, Framebuffer.height)

    framebuffer.pixels.withUnsafeBytes { ptr in
      guard let baseAddress = ptr.baseAddress else { return }
      texture.replace(
        region:      region,
        mipmapLevel: 0,
        withBytes:   baseAddress,
        bytesPerRow: Framebuffer.width * MemoryLayout<UInt8>.size
      )
    }
  }
}
