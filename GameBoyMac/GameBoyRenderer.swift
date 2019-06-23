// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import MetalKit
import GameBoyKit

internal let framebufferWidth  = Int(Lcd.width)
internal let framebufferHeight = Int(Lcd.height)

public class GameBoyRenderer: NSObject, MTKViewDelegate {

  private let gameBoy: GameBoy

  private let pipeline:     MTLRenderPipelineState
  private let commandQueue: MTLCommandQueue
  private let vertexBuffer: MTLBuffer
  private var texture:      MTLTexture

  public init(gameBoy: GameBoy, device: MTLDevice) {
    self.gameBoy = gameBoy

    let library       = makeLibrary(device: device)
    self.pipeline     = makePipeline(device: device, library: library)
    self.commandQueue = makeCommandQueue(device: device)
    self.vertexBuffer = makeFullscreenVertexBuffer(device: device)
    self.texture      = makeFramebuffer(device: device)

    super.init()
  }

  public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) { }

  public func draw(in view: MTKView) {
    let frame = self.gameBoy.tickFrame()
    self.updateFramebuffer(from: frame)

    guard let drawable = view.currentDrawable,
          let renderPassDesc = view.currentRenderPassDescriptor else {
        return
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
