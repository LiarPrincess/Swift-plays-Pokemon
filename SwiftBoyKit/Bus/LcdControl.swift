// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

public enum TileMap: UInt8, Codable {
  case from9800to9bff = 0
  case from9c00to9fff = 1
}

public enum TileData: UInt8, Codable {
  case from8800to97ff = 0
  case from8000to8fff = 1
}

public enum SpriteSize: UInt8, Codable {
  case size8x8  = 0
  case size8x16 = 1
}

public class LcdControl: Codable {

  private static let isLcdEnabledMask:        UInt8 = 1 << 7
  private static let isWindowEnabledMask:     UInt8 = 1 << 5
  private static let windowTileMapMask:       UInt8 = 1 << 6
  private static let backgroundTileMapMask:   UInt8 = 1 << 3
  private static let tileDataMask:            UInt8 = 1 << 4
  private static let spriteSizeMask:          UInt8 = 1 << 2
  private static let isSpriteEnabledMask:     UInt8 = 1 << 1
  private static let isBackgroundVisibleMask: UInt8 = 1 << 0

  /// Bit 7 - LCD Display Enable
  public var isLcdEnabled: Bool = false

  /// Bit 5 - Window Display Enable
  public var isWindowEnabled: Bool = false

  /// Bit 6 - Window Tile Map Display Select
  public var windowTileMap: TileMap = .from9800to9bff

  /// Bit 3 - BG Tile Map Display Select
  public var backgroundTileMap: TileMap = .from9800to9bff

  /// Bit 4 - BG & Window Tile Data Select
  public var tileData: TileData = .from8800to97ff

  /// Bit 2 - OBJ (Sprite) Size
  public var spriteSize: SpriteSize = .size8x8

  /// Bit 1 - OBJ (Sprite) Display Enable
  public var isSpriteEnabled: Bool = false

  /// Bit 0 - BG Display
  public var isBackgroundVisible: Bool = false

  /// Raw byte
  public var byte: UInt8 {
    get {
      var result: UInt8 = 0
      result |= self.isLcdEnabled    ? LcdControl.isLcdEnabledMask : 0
      result |= self.isWindowEnabled ? LcdControl.isWindowEnabledMask : 0
      result |= self.windowTileMap     == .from9c00to9fff ? LcdControl.windowTileMapMask : 0
      result |= self.backgroundTileMap == .from9c00to9fff ? LcdControl.backgroundTileMapMask : 0
      result |= self.tileData          == .from8000to8fff ? LcdControl.tileDataMask : 0
      result |= self.spriteSize        == .size8x16       ? LcdControl.spriteSizeMask : 0
      result |= self.isSpriteEnabled     ? LcdControl.isSpriteEnabledMask : 0
      result |= self.isBackgroundVisible ? LcdControl.isBackgroundVisibleMask : 0
      return result
    }
    set {
      self.isLcdEnabled    = isSet(newValue, mask: LcdControl.isLcdEnabledMask)
      self.isWindowEnabled = isSet(newValue, mask: LcdControl.isWindowEnabledMask)
      self.windowTileMap     = isSet(newValue, mask: LcdControl.windowTileMapMask)     ? .from9c00to9fff : .from9800to9bff
      self.backgroundTileMap = isSet(newValue, mask: LcdControl.backgroundTileMapMask) ? .from9c00to9fff : .from9800to9bff
      self.tileData          = isSet(newValue, mask: LcdControl.tileDataMask)          ? .from8000to8fff : .from8800to97ff
      self.spriteSize        = isSet(newValue, mask: LcdControl.spriteSizeMask)        ? .size8x16 : .size8x8
      self.isSpriteEnabled     = isSet(newValue, mask: LcdControl.isSpriteEnabledMask)
      self.isBackgroundVisible = isSet(newValue, mask: LcdControl.isBackgroundVisibleMask)
    }
  }
}

private func isSet(_ value: UInt8, mask: UInt8) -> Bool {
  return (value & mask) == mask
}
