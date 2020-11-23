// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public struct LcdStatus {

  public enum Masks {
    // swiftformat:disable consecutiveSpaces
    public static let isLineCompareInterruptEnabled: UInt8 = 1 << 6
    public static let isOamInterruptEnabled:    UInt8 = 1 << 5
    public static let isVBlankInterruptEnabled: UInt8 = 1 << 4
    public static let isHBlankInterruptEnabled: UInt8 = 1 << 3
    public static let isLineCompareInterrupt:   UInt8 = 1 << 2
    public static let mode: UInt8 = 0b11
    // swiftformat:enable consecutiveSpaces
  }

  public let value: UInt8

  internal init(value: UInt8) {
    self.value = value
  }

  internal init(isOamInterruptEnabled: Bool,
                isVBlankInterruptEnabled: Bool,
                isHBlankInterruptEnabled: Bool,
                isLineCompareInterruptEnabled: Bool,
                isLineCompareInterrupt: Bool,
                mode: LcdMode) {
    var value = UInt8()
    func set(_ mask: UInt8, if condition: Bool) {
      value |= condition ? mask : 0
    }

    set(Masks.isOamInterruptEnabled, if: isOamInterruptEnabled)
    set(Masks.isVBlankInterruptEnabled, if: isVBlankInterruptEnabled)
    set(Masks.isHBlankInterruptEnabled, if: isHBlankInterruptEnabled)
    set(Masks.isLineCompareInterruptEnabled, if: isLineCompareInterruptEnabled)
    set(Masks.isLineCompareInterrupt, if: isLineCompareInterrupt)

    set(LcdMode.hBlankValue, if: mode == .hBlank)
    set(LcdMode.vBlankValue, if: mode == .vBlank)
    set(LcdMode.oamSearchValue, if: mode == .oamSearch)
    set(LcdMode.pixelTransferValue, if: mode == .pixelTransfer)

    self.value = value
  }

  // MARK: - Interrupts

  /// Status bit 5 - Mode 2 OAM Interrupt
  public var isOamInterruptEnabled: Bool {
    return isSet(self.value, mask: Masks.isOamInterruptEnabled)
  }

  /// Status bit 4 - Mode 1 V-Blank Interrupt
  public var isVBlankInterruptEnabled: Bool {
    return isSet(self.value, mask: Masks.isVBlankInterruptEnabled)
  }

  /// Status bit 3 - Mode 0 H-Blank Interrupt
  public var isHBlankInterruptEnabled: Bool {
    return isSet(self.value, mask: Masks.isHBlankInterruptEnabled)
  }

  // MARK: - Line compare

  /// Status bit 6 - LYC=LY Coincidence Interrupt
  public var isLineCompareInterruptEnabled: Bool {
    return isSet(self.value, mask: Masks.isLineCompareInterruptEnabled)
  }

  /// Status bit 2 - Coincidence Flag (0:LYC<>LY, 1:LYC=LY)
  public var isLineCompareInterrupt: Bool {
    return isSet(self.value, mask: Masks.isLineCompareInterrupt)
  }

  // MARK: - Mode

  /// Status bit 1-0 - Mode Flag
  public var mode: LcdMode {
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
