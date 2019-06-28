// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

internal enum LcdConstants {

  // MARK: - Resolution

  /// 160 px = 20 tiles
  internal static let width = 160

  /// 144 px = 18 tiles
  internal static let height = 144

  // MARK: - Line phase

  /// Cycle in which we end OAM search
  internal static let oamSearchEnd = 80

  /// Cycle in which we end pixel transfer
  internal static let pixelTransferEnd = oamSearchEnd + 175

  /// Cycle in which we end H-Blank
  internal static let hBlankEnd = cyclesPerLine

  // MARK: - Line count

  /// Length of vBlank period (in lines, where 1 line = 'lineLength' cycles)
  public static let vBlankLineCount = 10

  /// Total number of lines (lcd + vBlank)
  internal static let totalLineCount = height + vBlankLineCount

  // MARK: - Cycles

  /// Number of cycles needed to draw the whole line
  /// (from: http://bgb.bircd.org/pandocs.htm#lcdstatusregister)
  internal static let cyclesPerLine = 456

  /// How many cycles does it take to render a full frame?
  /// (from: http://bgb.bircd.org/pandocs.htm#lcdstatusregister)
  internal static let cyclesPerFrame = 70_224
}