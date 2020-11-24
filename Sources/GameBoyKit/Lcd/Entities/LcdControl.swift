// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public struct LcdControl {

  public enum Masks {
    // swiftformat:disable consecutiveSpaces
    public static let isLcdEnabled:        UInt8 = 1 << 7
    public static let isWindowEnabled:     UInt8 = 1 << 5
    public static let windowTileMap:       UInt8 = 1 << 6
    public static let backgroundTileMap:   UInt8 = 1 << 3
    public static let tileData:            UInt8 = 1 << 4
    public static let spriteSize:          UInt8 = 1 << 2
    public static let isSpriteEnabled:     UInt8 = 1 << 1
    public static let isBackgroundVisible: UInt8 = 1 << 0
    // swiftformat:enable consecutiveSpaces
  }

  public let value: UInt8

  internal init(value: UInt8) {
    self.value = value
  }

  internal init(isLcdEnabled: Bool,
                isBackgroundVisible: Bool,
                isWindowEnabled: Bool,
                isSpriteEnabled: Bool,
                windowTileMap: TileMap.Variant,
                backgroundTileMap: TileMap.Variant,
                tileDataSelect: TileData.Variant,
                isSpriteHeight16: Bool) {
    var value = UInt8()
    func set(_ mask: UInt8, if condition: Bool) {
      value |= condition ? mask : 0
    }

    set(Masks.isLcdEnabled, if: isLcdEnabled)
    set(Masks.isBackgroundVisible, if: isBackgroundVisible)
    set(Masks.isWindowEnabled, if: isWindowEnabled)
    set(Masks.isSpriteEnabled, if: isSpriteEnabled)

    set(Masks.backgroundTileMap, if: backgroundTileMap == .from9c00to9fff)
    set(Masks.windowTileMap, if: windowTileMap == .from9c00to9fff)
    set(Masks.tileData, if: tileDataSelect == .from8000to8fff)

    set(Masks.spriteSize, if: isSpriteHeight16)

    self.value = value
  }

  // MARK: - Is enabled

  /// Control bit 7 - LCD Display Enable
  public var isLcdEnabled: Bool {
    return isSet(self.value, mask: Masks.isLcdEnabled)
  }

  /// Control bit 0 - BG Display
  public var isBackgroundVisible: Bool {
    return isSet(self.value, mask: Masks.isBackgroundVisible)
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

  /// Control bit 3 - BG Tile Map Display Select
  public var backgroundTileMap: TileMap.Variant {
    return isSet(self.value, mask: Masks.backgroundTileMap) ?
      .from9c00to9fff :
      .from9800to9bff
  }

  /// Control bit 6 - Window Tile Map Display Select
  public var windowTileMap: TileMap.Variant {
    return isSet(self.value, mask: Masks.windowTileMap) ?
      .from9c00to9fff :
      .from9800to9bff
  }

  // MARK: - Tile data

  /// Control bit 4 - BG & Window Tile Data Select
  public var tileDataSelect: TileData.Variant {
    return isSet(self.value, mask: Masks.tileData) ?
      .from8000to8fff :
      .from8800to97ff
  }

  // MARK: - Other

  /// Control bit 2 - OBJ (Sprite) Size
  public var spriteHeight: Sprite.Size {
    return isSet(self.value, mask: Masks.spriteSize) ? .size16 : .size8
  }

  /// Control bit 2 - OBJ (Sprite) Size
  public var spriteSize: Sprite.Size {
    return self.spriteHeight
  }
}

private func isSet(_ value: UInt8, mask: UInt8) -> Bool {
  return (value & mask) == mask
}
