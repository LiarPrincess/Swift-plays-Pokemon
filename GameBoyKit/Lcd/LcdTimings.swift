// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public enum LcdTimings {

  /// How long does it take to draw a line (in cycles)
  public static let lineLength: UInt16 = 456

  /// Length of oam search period (in cycles)
  public static let oamSearchLength: UInt16 = 80

  /// Length of pixel transfer period (in cycles)
  public static let pixelTransferLength: UInt16 = 175

  /// Length of H-Blank period (in cycles)
  public static let hBlankLength: UInt16 = lineLength - oamSearchLength - pixelTransferLength

  /// Length of vBlank period (in lines, where 1 line = 'lineLength' cycles)
  public static let vBlankLineCount: UInt8 = 10
}
