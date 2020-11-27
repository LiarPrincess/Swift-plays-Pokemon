// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

/// Data that should be put on the screen
public struct Framebuffer {

  public typealias PixelBufferPointer = UnsafeMutableBufferPointer<UInt8>

  public static let width = Lcd.Constants.width
  public static let height = Lcd.Constants.height

  /// Data that should be put on the screen:
  /// - 0 - White
  /// - 1 - Light gray
  /// - 2 - Dark gray
  /// - 3 - Black
  public let pixels: PixelBufferPointer

  /// Base address of the array of pixels
  public var baseAddress: UnsafeMutablePointer<UInt8> {
    if let result = self.pixels.baseAddress {
      return result
    }

    fatalError("Unable to obtain framebuffer address.")
  }

  internal init() {
    let count = Framebuffer.width * Framebuffer.height
    self.pixels = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: count)
    self.pixels.assign(repeating: 0)
  }

  internal func clear() {
    self.pixels.assign(repeating: 0)
  }

  internal func deallocate() {
    self.pixels.deallocate()
  }
}
