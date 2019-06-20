// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public enum TileMap {
  case from9800to9bff
  case from9c00to9fff

  public var range: ClosedRange<UInt16> {
    switch self {
    case .from9800to9bff: return 0x9800...0x9bff
    case .from9c00to9fff: return 0x9c00...0x9fff
    }
  }
}

public enum TileData {
  case from8800to97ff
  case from8000to8fff

  public var range: ClosedRange<UInt16> {
    switch self {
    case .from8800to97ff: return 0x8800...0x97ff
    case .from8000to8fff: return 0x8000...0x8fff
    }
  }
}

public enum SpriteSize {
  case size8x8
  case size8x16
}

private let isLcdEnabledMask:        UInt8 = 1 << 7
private let isWindowEnabledMask:     UInt8 = 1 << 5
private let windowTileMapMask:       UInt8 = 1 << 6
private let backgroundTileMapMask:   UInt8 = 1 << 3
private let tileDataMask:            UInt8 = 1 << 4
private let spriteSizeMask:          UInt8 = 1 << 2
private let isSpriteEnabledMask:     UInt8 = 1 << 1
private let isBackgroundVisibleMask: UInt8 = 1 << 0

public class LcdControl {

  /// Bit 7 - LCD Display Enable
  public internal(set) var isLcdEnabled: Bool = false

  /// Bit 5 - Window Display Enable
  public internal(set) var isWindowEnabled: Bool = false

  /// Bit 6 - Window Tile Map Display Select
  public internal(set) var windowTileMap: TileMap = .from9800to9bff

  /// Bit 3 - BG Tile Map Display Select
  public internal(set) var backgroundTileMap: TileMap = .from9800to9bff

  /// Bit 4 - BG & Window Tile Data Select
  public internal(set) var tileData: TileData = .from8800to97ff

  /// Bit 2 - OBJ (Sprite) Size
  public internal(set) var spriteSize: SpriteSize = .size8x8

  /// Bit 1 - OBJ (Sprite) Display Enable
  public internal(set) var isSpriteEnabled: Bool = false

  /// Bit 0 - BG Display
  public internal(set) var isBackgroundVisible: Bool = false

  /// Raw byte
  public internal(set) var value: UInt8 {
    get {
      var result: UInt8 = 0
      result |= self.isLcdEnabled    ? isLcdEnabledMask : 0
      result |= self.isWindowEnabled ? isWindowEnabledMask : 0
      result |= self.windowTileMap     == .from9c00to9fff ? windowTileMapMask : 0
      result |= self.backgroundTileMap == .from9c00to9fff ? backgroundTileMapMask : 0
      result |= self.tileData          == .from8000to8fff ? tileDataMask : 0
      result |= self.spriteSize        == .size8x16       ? spriteSizeMask : 0
      result |= self.isSpriteEnabled     ? isSpriteEnabledMask : 0
      result |= self.isBackgroundVisible ? isBackgroundVisibleMask : 0
      return result
    }
    set {
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
