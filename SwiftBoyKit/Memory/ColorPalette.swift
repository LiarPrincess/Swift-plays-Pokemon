// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

public class ColorPalette: Codable {

  private static let color0Shift: UInt8 = 0
  private static let color1Shift: UInt8 = 2
  private static let color2Shift: UInt8 = 4
  private static let color3Shift: UInt8 = 6

  public var color0: UInt8 = 0
  public var color1: UInt8 = 0
  public var color2: UInt8 = 0
  public var color3: UInt8 = 0

  public var byte: UInt8 {
    get {
      var result: UInt8 = 0
      result |= self.color0 << ColorPalette.color0Shift
      result |= self.color1 << ColorPalette.color1Shift
      result |= self.color2 << ColorPalette.color2Shift
      result |= self.color3 << ColorPalette.color3Shift
      return result
    }
    set {
      self.color0 = (newValue >> ColorPalette.color0Shift) & 0b11
      self.color1 = (newValue >> ColorPalette.color1Shift) & 0b11
      self.color2 = (newValue >> ColorPalette.color2Shift) & 0b11
      self.color3 = (newValue >> ColorPalette.color3Shift) & 0b11
    }
  }

  internal func getColor(tileValue: UInt8) -> UInt8 {
    switch tileValue {
    case 0: return self.color0
    case 1: return self.color1
    case 2: return self.color2
    case 3: return self.color3
    default: return 0
    }
  }
}
