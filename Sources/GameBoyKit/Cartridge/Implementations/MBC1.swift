// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

internal final class MBC1: Cartridge {

  /// The 5-bit BANK1 register is used as the lower 5 bits of the ROM
  /// bank number when the CPU accesses the 4000-7FFF memory area.
  private var bank1: Int = 1

  /// The 2-bit BANK2 register can be used as the upper bits
  /// of the ROM bank number, or as the 2-bit RAM bank number.
  private var bank2: Int = 0

  /// true  - BANK2 affects 0000-3FFF, 4000-7FFF, A000-BFFF
  /// false - BANK2 affects 4000-7FFF + RAM
  private var mode = false

  ///  ram_en: bool
  private var isRamEnabled = false

  override internal func writeRom(_ address: UInt16, value: UInt8) {
    switch address {

    // 0000-1FFF - RAM Enable
    case 0x0000...0x1fff:
      self.isRamEnabled = (value & 0xf) == 0xa

    // 2000-3FFF - ROM Bank Number (5 lower bits)
    case 0x2000...0x3fff:
      let value5 = value & 0b1_1111
      self.bank1 = max(1, Int(value5))
      self.updateRomBankStart()

    // 4000-5FFF - RAM Bank Number or ROM Bank Number (2 upper bits)
    case 0x4000...0x5fff:
      self.bank2 = Int(value & 0x11)
      self.updateRomBankStart()
      self.updateRamBankStart()

    // 6000-7FFF - ROM/RAM Mode Select
    case 0x6000...0x7fff:
      self.mode = (value & 0b1) == 0b0
      self.updateRomBankStart()
      self.updateRamBankStart()

    default:
      print("Writing to invalid ROM address: \(address.hex).")
    }
  }

  private func updateRomBankStart() {
    let upperBits = self.bank2 << 5
    let lowerBits = self.bank1

    let lowerBank = self.mode ? upperBits : 0
    let upperBank = upperBits | lowerBits

    self.romLowerBankStart = lowerBank * CartridgeConstants.romBankSizeInBytes
    self.romUpperBankStart = upperBank * CartridgeConstants.romBankSizeInBytes
  }

  private func updateRamBankStart() {
    let bank = self.mode ? self.bank2 : 0
    self.ramBankStart = bank * CartridgeConstants.ramBankSizeInBytes
  }

  /// (mooneye) When RAM access is disabled, all reads return 0xFF.
  override internal func readRam(_ address: UInt16) -> UInt8 {
    return self.isRamEnabled ? super.readRam(address) : CartridgeConstants.defaultRam
  }

  /// (mooneye) When RAM access is disabled, all writes
  /// to the external RAM area 0xA000-0xBFFF are ignored.
  override internal func writeRam(_ address: UInt16, value: UInt8) {
    if self.isRamEnabled {
      super.writeRam(address, value: value)
    }
  }
}
