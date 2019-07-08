// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

internal enum LcdConstants {

  // MARK: - Resolution

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

  // MARK: - Sprite

  /// Total number of sprites.
  internal static let spriteCount = 40

  /// Number of bytes that define single sprite.
  internal static let spriteByteCount = 4

  // MARK: - Other

  /// Size of a single tile map.
  internal static let tileMapCount = 0x0400
}
