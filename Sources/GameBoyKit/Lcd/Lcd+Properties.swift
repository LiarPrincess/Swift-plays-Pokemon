// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public enum TileMap {
  case from9800to9bff
  case from9c00to9fff
}

public enum TileData {
  case from8800to97ff
  case from8000to8fff
}

internal enum LcdMode {

  /// Mode 0: The LCD controller is in the H-Blank period.
  /// CPU can access both the display RAM (8000h-9FFFh) and OAM (FE00h-FE9Fh)
  case hBlank

  /// Mode 1: The LCD contoller is in the V-Blank period (or the display is disabled).
  /// CPU can access both the display RAM (8000h-9FFFh) and OAM (FE00h-FE9Fh)
  case vBlank

  /// Mode 2: The LCD controller is reading from OAM memory.
  /// The CPU <cannot> access OAM memory (FE00h-FE9Fh) during this period.
  case oamSearch

  /// Mode 3: The LCD controller is reading from both OAM and VRAM,
  /// The CPU <cannot> access OAM and VRAM during this period.
  case pixelTransfer
}

extension WritableLcd {

  // MARK: - Control properties

  /// Control bit 7 - LCD Display Enable
  internal var isLcdEnabled: Bool {
    return isSet(self.control, mask: LcdControlMasks.isLcdEnabled)
  }

  /// Control bit 0 - BG Display
  internal var isBackgroundVisible: Bool {
    return isSet(self.control, mask: LcdControlMasks.isBackgroundVisible)
  }

  /// Control bit 5 - Window Display Enable
  internal var isWindowEnabled: Bool {
    return isSet(self.control, mask: LcdControlMasks.isWindowEnabled)
  }

  /// Control bit 1 - OBJ (Sprite) Display Enable
  internal var isSpriteEnabled: Bool {
    return isSet(self.control, mask: LcdControlMasks.isSpriteEnabled)
  }

  /// Control bit 6 - Window Tile Map Display Select
  internal var windowTileMap: TileMap {
    return isSet(self.control, mask: LcdControlMasks.windowTileMap) ?
      .from9c00to9fff : .from9800to9bff
  }

  /// Control bit 3 - BG Tile Map Display Select
  internal var backgroundTileMap: TileMap {
    return isSet(self.control, mask: LcdControlMasks.backgroundTileMap) ?
      .from9c00to9fff : .from9800to9bff
  }

  /// Control bit 4 - BG & Window Tile Data Select
  internal var tileDataSelect: TileData {
    return isSet(self.control, mask: LcdControlMasks.tileData) ?
      .from8000to8fff : .from8800to97ff
  }

  /// Control bit 2 - OBJ (Sprite) Size
  internal var spriteHeight: Int {
    return isSet(self.control, mask: LcdControlMasks.spriteSize) ? 16 : 8
  }

  // MARK: - Status properties

  /// Status bit 6 - LYC=LY Coincidence Interrupt
  internal var isLineCompareInterruptEnabled: Bool {
    return isSet(self.status, mask: LcdStatusMasks.isLineCompareInterruptEnabled)
  }

  /// Status bit 5 - Mode 2 OAM Interrupt
  internal var isOamInterruptEnabled: Bool {
    return isSet(self.status, mask: LcdStatusMasks.isOamInterruptEnabled)
  }

  /// Status bit 4 - Mode 1 V-Blank Interrupt
  internal var isVBlankInterruptEnabled: Bool {
    return isSet(self.status, mask: LcdStatusMasks.isVBlankInterruptEnabled)
  }

  /// Status bit 3 - Mode 0 H-Blank Interrupt
  internal var isHBlankInterruptEnabled: Bool {
    return isSet(self.status, mask: LcdStatusMasks.isHBlankInterruptEnabled)
  }

  /// Status bit 2 - Coincidence Flag (0:LYC<>LY, 1:LYC=LY)
  internal var isLineCompareInterrupt: Bool {
    return isSet(self.status, mask: LcdStatusMasks.isLineCompareInterrupt)
  }

  /// Status bit 1-0 - Mode Flag
  internal var mode: LcdMode {
    let rawMode = self.status & LcdStatusMasks.mode
    switch rawMode {
    case LcdModeValues.hBlank:        return .hBlank
    case LcdModeValues.vBlank:        return .vBlank
    case LcdModeValues.oamSearch:     return .oamSearch
    case LcdModeValues.pixelTransfer: return .pixelTransfer
    default:
      fatalError("Invalid mode bits: '\(rawMode.bin)'.") // ?
    }
  }
}

private func isSet(_ value: UInt8, mask: UInt8) -> Bool {
  return (value & mask) == mask
}
