// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

private let firstRomBank = 1

/// http://bgb.bircd.org/pandocs.htm#mbc1max2mbyteromandor32kbyteram
internal struct MBC1: Cartridge, CartridgeMixin {

  internal let header: CartridgeHeader
  internal let rom: Data
  internal var ram: Data

  /// Offset to selected 0000-3FFF bank.
  internal private(set) var romLowerBankStart = Int(MemoryMap.rom0.start)
  /// Offset to selected 4000-7FFF bank.
  internal private(set) var romUpperBankStart = Int(MemoryMap.rom1.start)
  /// Offset to selected ram bank.
  internal private(set) var ramBankStart = 0

  /// The 5-bit BANK1 register is used as the lower 5 bits of the ROM
  /// bank number when the CPU accesses the 4000-7FFF memory area.
  private var bank1: Int = 1
  /// The 2-bit BANK2 register can be used as the upper bits
  /// of the ROM bank number, or as the 2-bit RAM bank number.
  private var bank2: Int = 0

  /// true  - BANK2 affects 0000-3FFF, 4000-7FFF, A000-BFFF
  /// false - BANK2 affects 4000-7FFF + RAM
  private var mode = false
  private var isRamEnabled = false

  internal init(header: CartridgeHeader, rom: Data) {
    self.header = header
    self.rom = rom
    self.ram = Data(count: header.ramSize.byteCount)
  }

  // MARK: - Rom

  internal func readRomLowerBank(_ address: UInt16) -> UInt8 {
    return self.readRomLowerBankMixin(address)
  }

  internal func readRomUpperBank(_ address: UInt16) -> UInt8 {
    return self.readRomUpperBankMixin(address)
  }

  internal mutating func writeRom(_ address: UInt16, value: UInt8) {
    switch address {

    // 0000-1FFF - RAM Enable
    case 0x0000...0x1fff:
      self.isRamEnabled = (value & 0xf) == 0xa

    // 2000-3FFF - ROM Bank Number (5 lower bits)
    case 0x2000...0x3fff:
      let value5LowestBits = value & 0b1_1111
      self.bank1 = max(firstRomBank, Int(value5LowestBits))
      self.updateRomBankStart()

    // 4000-5FFF - RAM Bank Number or ROM Bank Number (2 upper bits)
    case 0x4000...0x5fff:
      self.bank2 = Int(value & 0b11)
      self.updateRomBankStart()
      self.updateRamBankStart()

    // 6000-7FFF - ROM/RAM Mode Select
    case 0x6000...0x7fff:
      self.mode = (value & 0b1) == 0b1
      self.updateRomBankStart()
      self.updateRamBankStart()

    default:
      print("Writing to invalid ROM address: \(address.hex).")
    }
  }

  private mutating func updateRomBankStart() {
    let upperBits = self.bank2 << 5
    let lowerBits = self.bank1

    let lowerBank = self.mode ? upperBits : 0
    let upperBank = upperBits | lowerBits

    self.romLowerBankStart = lowerBank * CartridgeConstants.romBankSizeInBytes
    self.romUpperBankStart = upperBank * CartridgeConstants.romBankSizeInBytes
  }

  private mutating func updateRamBankStart() {
    let bank = self.mode ? self.bank2 : 0
    self.ramBankStart = bank * CartridgeConstants.ramBankSizeInBytes
  }

  // MARK: - Ram

  /// (mooneye) When RAM access is disabled, all reads return 0xFF.
  internal func readRam(_ address: UInt16) -> UInt8 {
    if self.isRamEnabled {
      return self.readRamMixin(address)
    }

    return CartridgeConstants.defaultRam
  }

  /// (mooneye) When RAM access is disabled, all writes
  /// to the external RAM area 0xA000-0xBFFF are ignored.
  internal mutating func writeRam(_ address: UInt16, value: UInt8) {
    if self.isRamEnabled {
      self.writeRamMixin(address, value: value)
    }
  }
}
