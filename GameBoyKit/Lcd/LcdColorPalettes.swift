// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

private let color0Shift: UInt8 = 0
private let color1Shift: UInt8 = 2
private let color2Shift: UInt8 = 4
private let color3Shift: UInt8 = 6

public struct BackgroundColorPalette {

  private var color0: UInt8 = 0
  private var color1: UInt8 = 0
  private var color2: UInt8 = 0
  private var color3: UInt8 = 0

  private var _value: UInt8 = 0

  public internal(set) var value: UInt8
  {
    get { return self._value }
    set {
      self._value = newValue
      self.color0 = (newValue >> color0Shift) & 0b11
      self.color1 = (newValue >> color1Shift) & 0b11
      self.color2 = (newValue >> color2Shift) & 0b11
      self.color3 = (newValue >> color3Shift) & 0b11
    }
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

public struct ObjectColorPalette {

  private var color1: UInt8 = 0
  private var color2: UInt8 = 0
  private var color3: UInt8 = 0

  private var _value: UInt8 = 0

  public internal(set) var value: UInt8 {
    get { return self._value }
    set {
      self._value = newValue
      self.color1 = (newValue >> color1Shift) & 0b11
      self.color2 = (newValue >> color2Shift) & 0b11
      self.color3 = (newValue >> color3Shift) & 0b11
    }
  }

  public subscript(rawColor: UInt8) -> UInt8 {
    switch rawColor {
    case 1: return self.color1
    case 2: return self.color2
    case 3: return self.color3
    default: return 0
    }
  }
}
