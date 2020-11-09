// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import MetalKit
import GameBoyKit

enum Metal {

  static func createDevice() -> MTLDevice {
    if let lowPowerDevice = MTLCopyAllDevices().first(where:  { $0.isLowPower }) {
      return lowPowerDevice
    }

    if let device = MTLCreateSystemDefaultDevice() {
      return device
    }

    fatalError("Error when initializing Metal: unable to initialize device.")
  }

  static func makeLibrary(device: MTLDevice) -> MTLLibrary {
    // 1. Try to take library from bundle (SPM)
    if let libraryFile = Bundle.main.path(forResource: "Shader", ofType: "metallib") {
      do {
        return try device.makeLibrary(filepath: libraryFile)
      } catch {
        /* fallback to default */
      }
    }

    // 2. Just use default (XCode)
    if let library = device.makeDefaultLibrary() {
      return library
    }

    // 3. Nope
    fatalError("Error when initializing Metal: unable to load library.")
  }

  static func makePipeline(device: MTLDevice, library: MTLLibrary) -> MTLRenderPipelineState {
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

  static func makeCommandQueue(device: MTLDevice) -> MTLCommandQueue {
    if let commandQueue = device.makeCommandQueue() {
      return commandQueue
    }

    fatalError("Error when initializing Metal: unable to create commandQueue.")
  }

  static func makeFullscreenVertexBuffer(device: MTLDevice) -> MTLBuffer {
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

  static func makeFramebuffer(device: MTLDevice) -> MTLTexture {
    let textureDesc = MTLTextureDescriptor.texture2DDescriptor(
      pixelFormat: .r8Uint,
      width:       GameBoyKit.Framebuffer.width,
      height:      GameBoyKit.Framebuffer.height,
      mipmapped:   false
    )

    if let texture = device.makeTexture(descriptor: textureDesc) {
      return texture
    }

    fatalError("Error when initializing Metal: unable to create texture.")
  }
}
