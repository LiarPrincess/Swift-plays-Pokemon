// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

private let color0Shift: UInt8 = 0
private let color1Shift: UInt8 = 2
private let color2Shift: UInt8 = 4
private let color3Shift: UInt8 = 6

public struct BackgroundColorPalette {

  public let color0: UInt8
  public let color1: UInt8
  public let color2: UInt8
  public let color3: UInt8

  public let value: UInt8

  internal init(value: UInt8) {
    self.value = value
    self.color0 = (value >> color0Shift) & 0b11
    self.color1 = (value >> color1Shift) & 0b11
    self.color2 = (value >> color2Shift) & 0b11
    self.color3 = (value >> color3Shift) & 0b11
  }

  public subscript(rawColor: UInt8) -> UInt8 {
    switch rawColor {
    case 0: return self.color0
    case 1: return self.color1
    case 2: return self.color2
    case 3: return self.color3
    default: return 0
    }
  }
}
