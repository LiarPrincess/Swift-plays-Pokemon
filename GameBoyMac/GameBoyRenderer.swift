// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import MetalKit
import GameBoyKit

public class GameBoyRenderer: NSObject, MTKViewDelegate {

  public let device:        MTLDevice
  private let pipeline:     MTLRenderPipelineState
  private let commandQueue: MTLCommandQueue
  private let vertexBuffer: MTLBuffer
  private var texture:      MTLTexture

  private var needsDisplay = false

  public override init() {
    self.device = createDevice()
    let library = makeLibrary(device: device)
    self.pipeline = makePipeline(device: device, library: library)
    self.commandQueue = makeCommandQueue(device: device)

    self.vertexBuffer = makeFullscreenVertexBuffer(device: device)
    self.texture = makeTexture(device: device)
    super.init()
  }

  public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    self.needsDisplay = true
  }

  public func draw(in view: MTKView) {
    guard self.needsDisplay else { return }

    // let texture = self.texture,
    guard let drawable = view.currentDrawable,
          let renderPassDesc = view.currentRenderPassDescriptor else {
        return
    }

    let commandBuffer = self.commandQueue.makeCommandBuffer()!
    let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDesc)!

    commandEncoder.setRenderPipelineState(self.pipeline)
    commandEncoder.setVertexBuffer(self.vertexBuffer, offset: 0, index: 0)
    commandEncoder.setFragmentTexture(self.texture, index: 0)
//    commandEncoder.setFragmentSamplerState(self.sampler, index: 0)
    commandEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
    commandEncoder.endEncoding()

    commandBuffer.present(drawable)
    commandBuffer.commit()

    self.needsDisplay = false
  }

  public func showFrame(data: [UInt8]) {
    needsDisplay = true
  }
}

private func createDevice() -> MTLDevice {
  if let lowPowerDevice = MTLCopyAllDevices().first(where:  { $0.isLowPower }) {
    return lowPowerDevice
  }

  if let device = MTLCreateSystemDefaultDevice() {
    return device
  }

  fatalError("Error when initializing Metal: unable to initialize device.")
}

private func makeLibrary(device: MTLDevice) -> MTLLibrary {
  if let library = device.makeDefaultLibrary() {
    return library
  }

  fatalError("Error when initializing Metal: unable to load library.")
}

private func makePipeline(device: MTLDevice, library: MTLLibrary) -> MTLRenderPipelineState {
  let pipelineDesc = MTLRenderPipelineDescriptor()
  pipelineDesc.vertexFunction   = library.makeFunction(name: "vertex_shader")
  pipelineDesc.fragmentFunction = library.makeFunction(name: "fragment_shader")
  pipelineDesc.colorAttachments[0].pixelFormat = .bgra8Unorm

  do {
    return try device.makeRenderPipelineState(descriptor: pipelineDesc)
  } catch {
    fatalError("Error when initializing Metal: unable to create render pipeline: \(error)")
  }
}

private func makeCommandQueue(device: MTLDevice) -> MTLCommandQueue {
  if let commandQueue = device.makeCommandQueue() {
    return commandQueue
  }

  fatalError("Error when initializing Metal: unable to create commandQueue.")
}

private func makeFullscreenVertexBuffer(device: MTLDevice) -> MTLBuffer {
  let data: [Float] = [
    -1.0, -1.0,
     1.0, -1.0, // swiftlint:disable:this collection_alignment
    -1.0,  1.0,
     1.0,  1.0  // swiftlint:disable:this collection_alignment
  ]

  if let buffer = device.makeBuffer(
    bytes:   data,
    length:  data.count * MemoryLayout<Float>.size,
    options: []) {

    return buffer
  }

  fatalError("Error when initializing Metal: unable to create vertex buffer.")
}

private func makeTexture(device: MTLDevice) -> MTLTexture {
  let width  = 2 // Int(Lcd.width)
  let height = 2 // Int(Lcd.height)

  let textureDesc = MTLTextureDescriptor.texture2DDescriptor(
    pixelFormat: .r8Uint,
    width:       width,
    height:      height,
    mipmapped: false
  )

  guard let texture = device.makeTexture(descriptor: textureDesc) else {
    fatalError("Error when initializing Metal: unable to create texture.")
  }

  let data: [UInt8] = [
    1, 0,
    0, 0
  ]

  let region  = MTLRegionMake2D(0, 0, width, height)
  let dataCount = data.count * MemoryLayout<UInt8>.size
  let rawData = Data(bytes: data, count: dataCount)

  rawData.withUnsafeBytes { ptr in
    texture.replace(
      region: region,
      mipmapLevel: 0,
      withBytes: ptr.baseAddress!,
      bytesPerRow: width * MemoryLayout<UInt8>.size
    )
  }

  return texture
}
