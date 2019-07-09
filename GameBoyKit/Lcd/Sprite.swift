// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

private let flipYMask: UInt8 = 1 << 6
private let flipXMask: UInt8 = 1 << 5
private let paletteNumberShift: UInt8 = 4
private let isAboveBackgroundMask: UInt8 = 1 << 7

internal struct Sprite {

  /// Byte 0 - Y Position;
  /// Specifies the sprites vertical position on the screen (minus 16).
  internal var positionY: UInt8 = 0

  /// Byte 1 - X Position;
  /// Specifies the sprites horizontal position on the screen (minus 8).
  internal var positionX: UInt8 = 0

  /// Byte 2 - Tile/Pattern Number
  /// Specifies the sprites Tile Number (00-FF).
  internal var tile: UInt8 = 0

  /// Byte 3 - Attributes/Flags
  internal var flags: UInt8 = 0

  // MARK: - Flags

  /// Flags bit 7 - OBJ-to-BG Priority
  internal var isAboveBackground: Bool {
    return !isSet(self.flags, mask: isAboveBackgroundMask)
  }

  /// Flags bit 6 - Y flip
  internal var flipY: Bool {
    return isSet(self.flags, mask: flipYMask)
  }

  /// Flags bit 5 - X flip
  internal var flipX: Bool {
    return isSet(self.flags, mask: flipXMask)
  }

  /// Flags bit 4 - Palette number (Non CGB Mode Only)
  internal var palette: UInt8 {
    return (self.flags >> paletteNumberShift) & 0b1
  }
}

private func isSet(_ value: UInt8, mask: UInt8) -> Bool {
  return (value & mask) == mask
}
