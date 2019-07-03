// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

private let isLcdEnabledMask:        UInt8 = 1 << 7
private let isWindowEnabledMask:     UInt8 = 1 << 5
private let windowTileMapMask:       UInt8 = 1 << 6
private let backgroundTileMapMask:   UInt8 = 1 << 3
private let tileDataMask:            UInt8 = 1 << 4
private let spriteSizeMask:          UInt8 = 1 << 2
private let isSpriteEnabledMask:     UInt8 = 1 << 1
private let isBackgroundVisibleMask: UInt8 = 1 << 0

public enum TileMap {
  case from9800to9bff
  case from9c00to9fff
}

public enum TileData {
  case from8800to97ff
  case from8000to8fff
}

public enum SpriteSize {
  case size8x8
  case size8x16
}

public struct LcdControl {

  /// Bit 7 - LCD Display Enable
  public private(set) var isLcdEnabled: Bool = false

  /// Bit 0 - BG Display
  public private(set) var isBackgroundVisible: Bool = false

  /// Bit 5 - Window Display Enable
  public private(set) var isWindowEnabled: Bool = false

  /// Bit 1 - OBJ (Sprite) Display Enable
  public private(set) var isSpriteEnabled: Bool = false

  /// Bit 6 - Window Tile Map Display Select
  public private(set) var windowTileMap: TileMap = .from9800to9bff

  /// Bit 3 - BG Tile Map Display Select
  public private(set) var backgroundTileMap: TileMap = .from9800to9bff

  /// Bit 4 - BG & Window Tile Data Select
  public private(set) var tileData: TileData = .from8800to97ff

  /// Bit 2 - OBJ (Sprite) Size
  public private(set) var spriteSize: SpriteSize = .size8x8

  private var _value: UInt8 = 0

  /// Raw byte
  public internal(set) var value: UInt8 {
    get { return self._value }
    set {
      self._value = newValue
      self.isLcdEnabled    = isSet(newValue, mask: isLcdEnabledMask)
      self.isWindowEnabled = isSet(newValue, mask: isWindowEnabledMask)
      self.windowTileMap     = isSet(newValue, mask: windowTileMapMask)     ? .from9c00to9fff : .from9800to9bff
      self.backgroundTileMap = isSet(newValue, mask: backgroundTileMapMask) ? .from9c00to9fff : .from9800to9bff
      self.tileData          = isSet(newValue, mask: tileDataMask)          ? .from8000to8fff : .from8800to97ff
      self.spriteSize        = isSet(newValue, mask: spriteSizeMask)        ? .size8x16 : .size8x8
      self.isSpriteEnabled     = isSet(newValue, mask: isSpriteEnabledMask)
      self.isBackgroundVisible = isSet(newValue, mask: isBackgroundVisibleMask)
    }
  }
}

private func isSet(_ value: UInt8, mask: UInt8) -> Bool {
  return (value & mask) == mask
}
