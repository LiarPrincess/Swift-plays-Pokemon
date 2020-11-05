// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public struct LcdControl {

  internal enum Masks {
    internal static let isLcdEnabled:        UInt8 = 1 << 7
    internal static let isWindowEnabled:     UInt8 = 1 << 5
    internal static let windowTileMap:       UInt8 = 1 << 6
    internal static let backgroundTileMap:   UInt8 = 1 << 3
    internal static let tileData:            UInt8 = 1 << 4
    internal static let spriteSize:          UInt8 = 1 << 2
    internal static let isSpriteEnabled:     UInt8 = 1 << 1
    internal static let isBackgroundVisible: UInt8 = 1 << 0
  }

  public internal(set) var value = UInt8()

  // MARK: - Is enabled

  /// Control bit 7 - LCD Display Enable
  public var isLcdEnabled: Bool {
    return isSet(self.value, mask: Masks.isLcdEnabled)
  }

  /// Control bit 5 - Window Display Enable
  public var isWindowEnabled: Bool {
    return isSet(self.value, mask: Masks.isWindowEnabled)
  }

  /// Control bit 1 - OBJ (Sprite) Display Enable
  public var isSpriteEnabled: Bool {
    return isSet(self.value, mask: Masks.isSpriteEnabled)
  }

  // MARK: - Tile map

  /// Control bit 6 - Window Tile Map Display Select
  public var windowTileMap: LcdTileMap {
    return isSet(self.value, mask: Masks.windowTileMap) ? .from9c00to9fff : .from9800to9bff
  }

  /// Control bit 3 - BG Tile Map Display Select
  public var backgroundTileMap: LcdTileMap {
    return isSet(self.value, mask: Masks.backgroundTileMap) ? .from9c00to9fff : .from9800to9bff
  }

  // MARK: - Tile data

  /// Control bit 4 - BG & Window Tile Data Select
  public var tileDataSelect: LcdTileData {
    return isSet(self.value, mask: Masks.tileData) ? .from8000to8fff : .from8800to97ff
  }

  // MARK: - Other

  /// Control bit 0 - BG Display
  public var isBackgroundVisible: Bool {
    return isSet(self.value, mask: Masks.isBackgroundVisible)
  }

  /// Control bit 2 - OBJ (Sprite) Size
  public var spriteHeight: Int {
    return isSet(self.value, mask: Masks.spriteSize) ? 16 : 8
  }

  /// Control bit 2 - OBJ (Sprite) Size
  public var spriteSize: Int {
    return self.spriteHeight
  }
}

private func isSet(_ value: UInt8, mask: UInt8) -> Bool {
  return (value & mask) == mask
}
