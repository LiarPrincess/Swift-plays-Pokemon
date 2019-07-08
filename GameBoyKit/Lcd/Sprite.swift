// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

private let flipYMask: UInt8 = 1 << 6
private let flipXMask: UInt8 = 1 << 5
private let paletteNumberShift: UInt8 = 4
private let isAboveBackgroundMask: UInt8 = 1 << 7

public class Sprite {

  /// Byte0 - Y Position;
  /// Specifies the sprites vertical position on the screen (minus 16).
  public internal(set) var positionY: UInt8 = 0

  /// Byte1 - X Position;
  /// Specifies the sprites horizontal position on the screen (minus 8).
  public internal(set) var positionX: UInt8 = 0

  /// Byte2 - Tile/Pattern Number
  /// Specifies the sprites Tile Number (00-FF).
  public internal(set) var tile: UInt8 = 0

  public internal(set) var flags: UInt8 = 0

  // MARK: - Flag values

  /// (0=OBJ Above BG, 1=OBJ Behind BG color 1-3)
  internal var isAboveBackground: Bool { return !isSet(self.flags, mask: isAboveBackgroundMask) }

  /// (0=Normal, 1=Vertically mirrored)
  internal var flipY: Bool { return isSet(self.flags, mask: flipYMask) }

  /// (0=Normal, 1=Horizontally mirrored)
  internal var flipX: Bool { return isSet(self.flags, mask: flipXMask) }

  /// **Non CGB Mode Only** (0=OBP0, 1=OBP1)
  internal var palette: UInt8 { return (self.flags >> paletteNumberShift) & 0b1 }

  /// **CGB Mode Only**     (0=Bank 0, 1=Bank 1)
  /// **CGB Mode Only**     (OBP0-7)
}

private func isSet(_ value: UInt8, mask: UInt8) -> Bool {
  return (value & mask) == mask
}
