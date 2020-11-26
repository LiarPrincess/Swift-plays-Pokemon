// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// Values encoded inside 'LcdStatus' lowest bits
private let hBlankValue = UInt8(0b00)
private let vBlankValue = UInt8(0b01)
private let oamSearchValue = UInt8(0b10)
private let pixelTransferValue = UInt8(0b11)

public struct LcdMode: Equatable {

  /// Mode 0: The LCD controller is in the H-Blank period.
  /// CPU can access both the display RAM (8000h-9FFFh) and OAM (FE00h-FE9Fh)
  public static let hBlank = LcdMode(lcdStatus: hBlankValue)
  /// Mode 1: The LCD contoller is in the V-Blank period (or the display is disabled).
  /// CPU can access both the display RAM (8000h-9FFFh) and OAM (FE00h-FE9Fh)
  public static let vBlank = LcdMode(lcdStatus: vBlankValue)
  /// Mode 2: The LCD controller is reading from OAM memory.
  /// The CPU <cannot> access OAM memory (FE00h-FE9Fh) during this period.
  public static let oamSearch = LcdMode(lcdStatus: oamSearchValue)
  /// Mode 3: The LCD controller is reading from both OAM and VRAM,
  /// The CPU <cannot> access OAM and VRAM during this period.
  public static let pixelTransfer = LcdMode(lcdStatus: pixelTransferValue)

  public let rawValue: UInt8

  internal init(lcdStatus: UInt8) {
    self.rawValue = lcdStatus & LcdStatus.Masks.mode
  }
}
