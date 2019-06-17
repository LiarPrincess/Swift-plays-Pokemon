// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

private let color0Shift: UInt8 = 0
private let color1Shift: UInt8 = 2
private let color2Shift: UInt8 = 4
private let color3Shift: UInt8 = 6

public class ColorPalette {

  public internal(set) var color0: UInt8 = 0
  public internal(set) var color1: UInt8 = 0
  public internal(set) var color2: UInt8 = 0
  public internal(set) var color3: UInt8 = 0

  public internal(set) var value: UInt8 {
    get {
      var result: UInt8 = 0
      result |= self.color0 << color0Shift
      result |= self.color1 << color1Shift
      result |= self.color2 << color2Shift
      result |= self.color3 << color3Shift
      return result
    }
    set {
      self.color0 = (newValue >> color0Shift) & 0b11
      self.color1 = (newValue >> color1Shift) & 0b11
      self.color2 = (newValue >> color2Shift) & 0b11
      self.color3 = (newValue >> color3Shift) & 0b11
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

public class TransparentColorPalette {

  public internal(set) var color1: UInt8 = 0
  public internal(set) var color2: UInt8 = 0
  public internal(set) var color3: UInt8 = 0

  public internal(set) var value: UInt8 {
    get {
      var result: UInt8 = 0
      result |= self.color1 << color1Shift
      result |= self.color2 << color2Shift
      result |= self.color3 << color3Shift
      return result
    }
    set {
      self.color1 = (newValue >> color1Shift) & 0b11
      self.color2 = (newValue >> color2Shift) & 0b11
      self.color3 = (newValue >> color3Shift) & 0b11
    }
  }

  internal func getColor(tileValue: UInt8) -> UInt8 {
    switch tileValue {
    case 1: return self.color1
    case 2: return self.color2
    case 3: return self.color3
    default: return 0
    }
  }
}
