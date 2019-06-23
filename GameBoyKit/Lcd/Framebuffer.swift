// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

private let lcdWidth = Int(Lcd.width)
private let framebufferSize = Int(Lcd.width) * Int(Lcd.height)

// TODO: Check memory leaks (after we implement loading cartridge)

// This is one MASSIVE allocation, but we need it this way,
// so that we can upload it to gpu.
// Btw. this class is CRUCIAL for performance.
public class Framebuffer {

  /// Data that should be put on screen
  public private(set) lazy var data: UnsafeMutableBufferPointer<UInt8> = {
    UnsafeMutableBufferPointer<UInt8>.allocate(capacity: framebufferSize)
  }()

  /// Flag to avoid repeated clear on every tick
  private var isClear: Bool = true

  deinit {
    self.data.deallocate()
  }

  internal subscript(x: Int, y: Int) -> UInt8 {
    get {
      // for performance we have to disable range checks (even in debug)
      let index = y * lcdWidth + x
      return self.data[index]
    }
    set {
      // for performance we have to disable range checks (even in debug)
      let index = y * lcdWidth + x
      self.data[index] = newValue
      self.isClear = false // faster than checking if == 0
    }
  }

  internal func clear() {
    if self.isClear { return }

    self.data.assign(repeating: 0)
    self.isClear = true
  }
}
