// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

private let isLineCompareInterruptEnabledMask: UInt8 = 1 << 6
private let isOamInterruptEnabledMask:    UInt8 = 1 << 5
private let isVBlankInterruptEnabledMask: UInt8 = 1 << 4
private let isHBlankInterruptEnabledMask: UInt8 = 1 << 3
private let isLineCompareInterruptMask:   UInt8 = 1 << 2
private let modeMask: UInt8 = 0b11

public enum LcdMode {

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

public class LcdStatus {

  /// Bit 6 - LYC=LY Coincidence Interrupt
  public internal(set) var isLineCompareInterruptEnabled: Bool = false

  /// Bit 5 - Mode 2 OAM Interrupt
  public internal(set) var isOamInterruptEnabled: Bool = false

  /// Bit 4 - Mode 1 V-Blank Interrupt
  public internal(set) var isVBlankInterruptEnabled: Bool = false

  /// Bit 3 - Mode 0 H-Blank Interrupt
  public internal(set) var isHBlankInterruptEnabled: Bool = false

  /// Bit 2 - Coincidence Flag (0:LYC<>LY, 1:LYC=LY)
  public internal(set) var isLineCompareInterrupt: Bool = false

  /// Bit 1-0 - Mode Flag
  public internal(set) var mode: LcdMode = .hBlank

  private var _value: UInt8 = 0

  /// Raw byte
  public internal(set) var value: UInt8 {
    get { return self._value }
    set {
      self._value = newValue

      self.isLineCompareInterruptEnabled = isSet(newValue, mask: isLineCompareInterruptEnabledMask)
      self.isOamInterruptEnabled         = isSet(newValue, mask: isOamInterruptEnabledMask)
      self.isVBlankInterruptEnabled      = isSet(newValue, mask: isVBlankInterruptEnabledMask)
      self.isHBlankInterruptEnabled      = isSet(newValue, mask: isHBlankInterruptEnabledMask)
      self.isLineCompareInterrupt        = isSet(newValue, mask: isLineCompareInterruptMask)

      switch newValue & modeMask {
      case 0b00: self.mode = .hBlank
      case 0b01: self.mode = .vBlank
      case 0b10: self.mode = .oamSearch
      case 0b11: self.mode = .pixelTransfer
      default:break
      }
    }
  }
}

private func isSet(_ value: UInt8, mask: UInt8) -> Bool {
  return (value & mask) == mask
}
