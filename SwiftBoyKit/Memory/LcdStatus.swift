// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

public enum LcdMode: UInt8, RawRepresentable, Codable {

  /// Mode 0: The LCD controller is in the H-Blank period.
  /// CPU can access both the display RAM (8000h-9FFFh) and OAM (FE00h-FE9Fh)
  case hBlank = 0b00

  /// Mode 1: The LCD contoller is in the V-Blank period (or the display is disabled).
  /// CPU can access both the display RAM (8000h-9FFFh) and OAM (FE00h-FE9Fh)
  case vBlank = 0b01

  /// Mode 2: The LCD controller is reading from OAM memory.
  /// The CPU <cannot> access OAM memory (FE00h-FE9Fh) during this period.
  case searchingOamRam = 0b10

  /// Mode 3: The LCD controller is reading from both OAM and VRAM,
  /// The CPU <cannot> access OAM and VRAM during this period.
  case pixelTransfer = 0b11
}

public class LcdStatus: Codable {

  private static let isLineCompareInterruptEnabledMask: UInt8 = 1 << 6
  private static let isOamInterruptEnabledMask: UInt8 = 1 << 5
  private static let isVBlankInterruptEnabledMask: UInt8 = 1 << 4
  private static let isHBlankInterruptEnabledMask: UInt8 = 1 << 3
  private static let isLineCompareInterruptMask: UInt8 = 1 << 2
  private static let modeMask: UInt8 = 0b11

  /// Bit 6 - LYC=LY Coincidence Interrupt
  public var isLineCompareInterruptEnabled: Bool = false

  /// Bit 5 - Mode 2 OAM Interrupt
  public var isOamInterruptEnabled: Bool = false

  /// Bit 4 - Mode 1 V-Blank Interrupt
  public var isVBlankInterruptEnabled: Bool = false

  /// Bit 3 - Mode 0 H-Blank Interrupt
  public var isHBlankInterruptEnabled: Bool = false

  /// Bit 2 - Coincidence Flag (0:LYC<>LY, 1:LYC=LY)
  public var isLineCompareInterrupt: Bool = false

  /// Bit 1-0 - Mode Flag
  public var mode: LcdMode = .hBlank

  /// Raw byte
  public var byte: UInt8 {
    get {
      var result: UInt8 = 0
      result |= self.isLineCompareInterruptEnabled ? LcdStatus.isLineCompareInterruptEnabledMask : 0
      result |= self.isOamInterruptEnabled         ? LcdStatus.isOamInterruptEnabledMask : 0
      result |= self.isVBlankInterruptEnabled      ? LcdStatus.isVBlankInterruptEnabledMask : 0
      result |= self.isHBlankInterruptEnabled      ? LcdStatus.isHBlankInterruptEnabledMask : 0
      result |= self.isLineCompareInterrupt        ? LcdStatus.isLineCompareInterruptMask : 0
      result |= self.mode.rawValue
      return result
    }
    set {
      self.isLineCompareInterruptEnabled = isSet(newValue, mask: LcdStatus.isLineCompareInterruptEnabledMask)
      self.isOamInterruptEnabled         = isSet(newValue, mask: LcdStatus.isOamInterruptEnabledMask)
      self.isVBlankInterruptEnabled      = isSet(newValue, mask: LcdStatus.isVBlankInterruptEnabledMask)
      self.isHBlankInterruptEnabled      = isSet(newValue, mask: LcdStatus.isHBlankInterruptEnabledMask)
      self.isLineCompareInterrupt        = isSet(newValue, mask: LcdStatus.isLineCompareInterruptMask)

      // swiftlint:disable:next force_unwrapping
      self.mode = LcdMode(rawValue: newValue & LcdStatus.modeMask)!
    }
  }
}

private func isSet(_ value: UInt8, mask: UInt8) -> Bool {
  return (value & mask) == mask
}
