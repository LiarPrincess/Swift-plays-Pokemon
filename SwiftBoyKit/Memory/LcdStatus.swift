// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

public enum LcdMode: UInt8, Codable {

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

  public static let isLineCompareInterruptEnabledMask: UInt8 = 1 << 6
  public static let isOamInterruptEnabledMask: UInt8 = 1 << 5
  public static let isVBlankInterruptEnabledMask: UInt8 = 1 << 4
  public static let isHBlankInterruptEnabledMask: UInt8 = 1 << 3
  public static let isLineCompareInterruptMask: UInt8 = 1 << 2
  public static let modeMask: UInt8 = 0b11

  /// Bit 6 - LYC=LY Coincidence Interrupt (1=Enable) (Read/Write)
  public var isLineCompareInterruptEnabled: Bool = false

  /// Bit 5 - Mode 2 OAM Interrupt         (1=Enable) (Read/Write)
  public var isOamInterruptEnabled: Bool = false

  /// Bit 4 - Mode 1 V-Blank Interrupt     (1=Enable) (Read/Write)
  public var isVBlankInterruptEnabled: Bool = false

  /// Bit 3 - Mode 0 H-Blank Interrupt     (1=Enable) (Read/Write)
  public var isHBlankInterruptEnabled: Bool = false

  /// Bit 2 - Coincidence Flag  (0:LYC<>LY, 1:LYC=LY) (Read Only)
  public var isLineCompareInterrupt: Bool = false

  public var mode: LcdMode = .hBlank

  internal var byte: UInt8 {
    var result: UInt8 = 0

    result |= self.isLineCompareInterruptEnabled ? LcdStatus.isLineCompareInterruptEnabledMask : 0
    result |= self.isOamInterruptEnabled ? LcdStatus.isOamInterruptEnabledMask : 0
    result |= self.isVBlankInterruptEnabled ? LcdStatus.isVBlankInterruptEnabledMask : 0
    result |= self.isHBlankInterruptEnabled ? LcdStatus.isHBlankInterruptEnabledMask : 0
    result |= self.isLineCompareInterrupt ? LcdStatus.isLineCompareInterruptMask : 0

    switch self.mode {
    case .hBlank: result |= 0b00
    case .vBlank: result |= 0b01
    case .searchingOamRam: result |= 0b10
    case .pixelTransfer: result |= 0b11
    }

    return result
  }

  internal func fillFrom(_ value: UInt8) {
    self.isLineCompareInterruptEnabled = self.isSet(value, mask: LcdStatus.isLineCompareInterruptEnabledMask)
    self.isOamInterruptEnabled = self.isSet(value, mask: LcdStatus.isOamInterruptEnabledMask)
    self.isVBlankInterruptEnabled = self.isSet(value, mask: LcdStatus.isVBlankInterruptEnabledMask)
    self.isHBlankInterruptEnabled = self.isSet(value, mask: LcdStatus.isHBlankInterruptEnabledMask)
    self.isLineCompareInterrupt = self.isSet(value, mask: LcdStatus.isLineCompareInterruptMask)

    switch value & LcdStatus.modeMask {
    case 0b00: self.mode = .hBlank
    case 0b01: self.mode = .vBlank
    case 0b10: self.mode = .searchingOamRam
    case 0b11: self.mode = .pixelTransfer
    default:
      fatalError("Invalid lcd mode value.")
    }
  }

  private func isSet(_ value: UInt8, mask: UInt8) -> Bool {
    return (value & mask) == mask
  }
}
