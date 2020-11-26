// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import AppKit
import MetalKit
import GameBoyKit

class GameBoyWindow: NSWindow, GameBoyInputProvider, MTKViewDelegate {

  // swiftlint:disable:next implicitly_unwrapped_optional
  private(set) var gameBoy: GameBoy!
  let cartridgePath: String
  let keyMap: KeyMap

  let device: MTLDevice
  let pipeline: MTLRenderPipelineState
  let commandQueue: MTLCommandQueue
  let vertexBuffer: MTLBuffer
  let texture: MTLTexture

  override var canBecomeKey: Bool { return true }
  override var canBecomeMain: Bool { return true }

  // swiftlint:disable:next function_body_length
  init(scale: Int,
       bootrom: Bootrom?,
       cartridge: Cartridge,
       cartridgePath: String,
       keyMap: KeyMap) {
    self.cartridgePath = cartridgePath
    self.keyMap = keyMap

    self.device = Metal.createDevice()
    let library = Metal.makeLibrary(device: self.device)
    self.pipeline = Metal.makePipeline(device: self.device, library: library)
    self.commandQueue = Metal.makeCommandQueue(device: self.device)
    self.vertexBuffer = Metal.makeFullscreenVertexBuffer(device: self.device)
    self.texture = Metal.makeFramebuffer(device: self.device)

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

    self.contentView = {
      let view = MTKView()
      view.device = self.device
      view.delegate = self
      view.colorPixelFormat = .bgra8Unorm
      view.framebufferOnly = true
      view.translatesAutoresizingMaskIntoConstraints = false
      return view
    }()

    self.title = cartridge.title
    self.backgroundColor = .black
    self.isMovableByWindowBackground = true
    self.center()

    self.setFrameAutosaveName("GameBoyWindow")

    // Use this if you resized window, and you don't like new size
    // self.setContentSize(NSSize(width: width, height: height))
  }

  // MARK: - Input

  private var input = GameBoyInput()

  func getGameBoyInput() -> GameBoyInput {
    return self.input
  }

  override func keyDown(with event: NSEvent) {
    self.updateKeyState(event: event, isDown: true)
  }

  override func keyUp(with event: NSEvent) {
    self.updateKeyState(event: event, isDown: false)
  }

  // swiftlint:disable:next cyclomatic_complexity
  private func updateKeyState(event: NSEvent, isDown: Bool) {
    if event.isARepeat { return }

    switch event.keyCode {
    // swiftformat:disable consecutiveSpaces
    case self.keyMap.a.value:      self.input.a = isDown
    case self.keyMap.b.value:      self.input.b = isDown
    case self.keyMap.start.value:  self.input.start = isDown
    case self.keyMap.select.value: self.input.select = isDown
    case self.keyMap.up.value:     self.input.up = isDown
    case self.keyMap.down.value:   self.input.down = isDown
    case self.keyMap.left.value:   self.input.left = isDown
    case self.keyMap.right.value:  self.input.right = isDown
    // swiftformat:enable consecutiveSpaces

    case self.keyMap.save.value:
      if isDown {
        FileSystem.saveExternalRam(gameBoy: self.gameBoy, romPath: self.cartridgePath)
      }

    default:
      // Use this if you want to propagate event down the responder chain:
      // super.keyDown(with: event)
      break
    }
  }

  // MARK: - MTKViewDelegate

  func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}

  func draw(in view: MTKView) {
    self.gameBoy.tickFrame()
    self.updateFramebuffer()

    guard let drawable = view.currentDrawable,
          let renderPassDesc = view.currentRenderPassDescriptor
    else {
        fatalError("Error when rendering Metal frame: unable to obtain drawable.")
    }

    guard let cmdBuffer = self.commandQueue.makeCommandBuffer(),
          let cmdEncoder = cmdBuffer.makeRenderCommandEncoder(descriptor: renderPassDesc)
    else {
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
        region: region,
        mipmapLevel: 0,
        withBytes: baseAddress,
        bytesPerRow: Framebuffer.width * MemoryLayout<UInt8>.size
      )
    }
  }
}
