// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public class Framebuffer {

  /// 160 px = 20 tiles
  public static let width: UInt8 = Lcd.width

  /// 144 px = 18 tiles
  public static let height: UInt8 = Lcd.height

  // This is one MASSIVE allocation, but we need it this way,
  // so that we can upload it to gpu.

  /// Data that should be put on screen
  public private(set) lazy var data: [UInt8] = {
    let count = UInt16(Lcd.width) * UInt16(Lcd.height)
    return [UInt8](repeating: 0, count: count)
  }()

  public internal(set) subscript(x: UInt8, y: UInt8) -> UInt8 {
    get {
      assert(self.contains(x: x, y: y), "Index out of range")
      let index = self.index(x: x, y: y)
      return self.data[index]
    }
    set {
      assert(self.contains(x: x, y: y), "Index out of range")
      let index = self.index(x: x, y: y)
      self.data[index] = newValue
    }
  }

  public func index(x: UInt8, y: UInt8) -> Int {
    return Int(y) * Int(Lcd.width) + Int(x)
  }

  private func contains(x: UInt8, y: UInt8) -> Bool {
    let index = self.index(x: x, y: y)
    return index < self.data.count
  }
}
