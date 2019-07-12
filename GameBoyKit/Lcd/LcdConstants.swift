// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

internal enum LcdConstants {

  // MARK: - Size

  /// 160 px = 20 tiles
  internal static let width = 160

  /// 144 px = 18 tiles
  internal static let height = 144

  /// Total number of lines (lcd + vBlank)
  internal static let heightWithVBlank = 154

  /// 256x256 pixels BG map (32x32 tiles).
  /// See: The Ultimate Game Boy Talk - 32:07.
  internal static let backgroundMapWidth = 256

  /// 256x256 pixels BG map (32x32 tiles).
  /// See: The Ultimate Game Boy Talk - 32:07.
  internal static let backgroundMapHeight = 256

  // MARK: - Line phase

  /// Cycle in which we end OAM search
  internal static let oamSearchEnd = 80

  /// Cycle in which we end pixel transfer
  internal static let pixelTransferEnd = oamSearchEnd + 175

  /// Cycle in which we end H-Blank
  internal static let hBlankEnd = cyclesPerLine

  // MARK: - Cycles

  /// Number of cycles needed to draw the whole line
  /// (from: http://bgb.bircd.org/pandocs.htm#lcdstatusregister)
  internal static let cyclesPerLine = 456

  /// How many cycles does it take to render a full frame?
  /// (from: http://bgb.bircd.org/pandocs.htm#lcdstatusregister)
  internal static let cyclesPerFrame = 70_224

  // MARK: - Other

  /// FF4B - WX - Window X Position minus 7.
  /// A postion of WX=7, WY=0 locates the window at upper left.
  internal static let windowXShift = 7
}

internal enum TileConstants {

  /// Total number of tiles (3 * 128)
  internal static let count = 3 * 128

  /// 8 pixels
  internal static let height = 8

  /// 8 pixels
  internal static let width = 8

  /// 1 tile line = 2 bytes
  internal static let bytesPerLine = 2

  /// 1 tile = 16 bytes
  internal static let byteCount = height * bytesPerLine

  /// 1 row (in background map) = 32 tiles
  internal static let tilesPerRow = 32
}

internal enum SpriteConstants {

  /// Total number of sprites (40)
  internal static let count = 40

  /// 1 line = max 10 sprites
  internal static let countPerLine = 10

  /// 1 sprite = 4 bytes
  internal static let byteCount = 4
}

internal enum LcdControlMasks {
  internal static let isLcdEnabled:        UInt8 = 1 << 7
  internal static let isWindowEnabled:     UInt8 = 1 << 5
  internal static let windowTileMap:       UInt8 = 1 << 6
  internal static let backgroundTileMap:   UInt8 = 1 << 3
  internal static let tileData:            UInt8 = 1 << 4
  internal static let spriteSize:          UInt8 = 1 << 2
  internal static let isSpriteEnabled:     UInt8 = 1 << 1
  internal static let isBackgroundVisible: UInt8 = 1 << 0
}

internal enum LcdStatusMasks {
  internal static let isLineCompareInterruptEnabled: UInt8 = 1 << 6
  internal static let isOamInterruptEnabled:    UInt8 = 1 << 5
  internal static let isVBlankInterruptEnabled: UInt8 = 1 << 4
  internal static let isHBlankInterruptEnabled: UInt8 = 1 << 3
  internal static let isLineCompareInterrupt:   UInt8 = 1 << 2
  internal static let mode: UInt8 = 0b11
}

internal enum LcdModeValues {
  internal static let hBlank:        UInt8 = 0b00
  internal static let vBlank:        UInt8 = 0b01
  internal static let oamSearch:     UInt8 = 0b10
  internal static let pixelTransfer: UInt8 = 0b11
}
