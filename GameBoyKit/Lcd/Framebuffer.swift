// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

private let lcdWidth = Int(Lcd.width)

// TODO: Check memory leaks (after we implement loading cartridge)

// This is one MASSIVE allocation, but we need it this way,
// so that we can upload it to gpu.
// Also this class is CRUCIAL for performance.
public class Framebuffer {

  /// Data that should be put on screen
  public private(set) lazy var data: UnsafeMutableBufferPointer<UInt8> = {
    let count = Int(Lcd.width) * Int(Lcd.height)
    return UnsafeMutableBufferPointer<UInt8>.allocate(capacity: count)
  }()

  deinit {
    self.data.deallocate()
  }

  public internal(set) subscript(x: Int, y: Int) -> UInt8 {
    get {
      // for performance we have to disable range checks (even in debug)
      let index = y * lcdWidth + x
      return self.data[index]
    }
    set {
      // for performance we have to disable range checks (even in debug)
      let index = y * lcdWidth + x
      self.data[index] = newValue
    }
  }
}
