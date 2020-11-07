// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

private let firstRomBank = 1

/// http://bgb.bircd.org/pandocs.htm#mbc3max2mbyteromandor32kbyteramandtimer
internal struct MBC3: Cartridge, CartridgeMixin {

  internal let header: CartridgeHeader
  internal let rom: Data
  internal var ram: Data

  /// Offset to selected 0000-3FFF bank.
  internal private(set) var romLowerBankStart = Int(MemoryMap.rom0.start)
  /// Offset to selected 4000-7FFF bank.
  internal private(set) var romUpperBankStart = Int(MemoryMap.rom1.start)
  /// Offset to selected ram bank.
  internal private(set) var ramBankStart = 0

  // We have MBC, so we do support switching upper rom bank.
  private var romBank = firstRomBank
  /// RAM or RTC? RTC is not supported.
  private var ramRtcSelect = UInt8()
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

    // 2000-3FFF - ROM Bank Number
    case 0x2000...0x3fff:
      self.romBank = max(firstRomBank, Int(value))
      self.romLowerBankStart = 0x0000
      self.romUpperBankStart = self.romBank * CartridgeConstants.romBankSizeInBytes

    // 4000-5FFF - RAM Bank Number - or - RTC Register Select
    case 0x4000...0x5fff:
      self.ramRtcSelect = value & 0b1111
      // Should we check if 'ramRtcSelect' <= 3 before setting 'ramBankStart'?
      let ramBank = Int(self.ramRtcSelect & 0b11)
      self.ramBankStart = ramBank * CartridgeConstants.ramBankSizeInBytes

    // 6000-7FFF - Latch Clock Data
    case 0x6000...0x7fff:
      break

    default:
      print("Writing to invalid ROM address: \(address.hex).")
    }
  }

  // MARK: - Ram

  private var isRamEnabledAndRtcSelectAllowsRam: Bool {
    return self.isRamEnabled && self.ramRtcSelect <= 0x03
  }

  internal func readRam(_ address: UInt16) -> UInt8 {
    if self.isRamEnabledAndRtcSelectAllowsRam {
      return self.readRamMixin(address)
    }

    return CartridgeConstants.defaultRam
  }

  internal mutating func writeRam(_ address: UInt16, value: UInt8) {
    if self.isRamEnabledAndRtcSelectAllowsRam {
      self.writeRamMixin(address, value: value)
    }
  }
}
