// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public struct LcdStatus {

  internal enum Masks {
    internal static let isLineCompareInterruptEnabled: UInt8 = 1 << 6
    internal static let isOamInterruptEnabled:    UInt8 = 1 << 5
    internal static let isVBlankInterruptEnabled: UInt8 = 1 << 4
    internal static let isHBlankInterruptEnabled: UInt8 = 1 << 3
    internal static let isLineCompareInterrupt:   UInt8 = 1 << 2
    internal static let mode: UInt8 = 0b11
  }

  public let value: UInt8

  internal init(value: UInt8) {
    self.value = value
  }

  // MARK: - Interrupts

  /// Status bit 5 - Mode 2 OAM Interrupt
  internal var isOamInterruptEnabled: Bool {
    return isSet(self.value, mask: Masks.isOamInterruptEnabled)
  }

  /// Status bit 4 - Mode 1 V-Blank Interrupt
  internal var isVBlankInterruptEnabled: Bool {
    return isSet(self.value, mask: Masks.isVBlankInterruptEnabled)
  }

  /// Status bit 3 - Mode 0 H-Blank Interrupt
  internal var isHBlankInterruptEnabled: Bool {
    return isSet(self.value, mask: Masks.isHBlankInterruptEnabled)
  }

  // MARK: - Line compare

  /// Status bit 6 - LYC=LY Coincidence Interrupt
  internal var isLineCompareInterruptEnabled: Bool {
    return isSet(self.value, mask: Masks.isLineCompareInterruptEnabled)
  }

  /// Status bit 2 - Coincidence Flag (0:LYC<>LY, 1:LYC=LY)
  internal var isLineCompareInterrupt: Bool {
    return isSet(self.value, mask: Masks.isLineCompareInterrupt)
  }

  // MARK: - Mode

  /// Status bit 1-0 - Mode Flag
  internal var mode: LcdMode {
    let rawMode = self.value & Masks.mode
    switch rawMode {
    case LcdMode.hBlankValue: return .hBlank
    case LcdMode.vBlankValue: return .vBlank
    case LcdMode.oamSearchValue: return .oamSearch
    case LcdMode.pixelTransferValue: return .pixelTransfer
    default: fatalError("Invalid mode bits: '\(rawMode.bin)'.") // how?
    }
  }
}

private func isSet(_ value: UInt8, mask: UInt8) -> Bool {
  return (value & mask) == mask
}
