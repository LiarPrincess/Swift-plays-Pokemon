// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

private enum CartridgeMemoryModel {
  case rom
  case ram
}

internal class MBC1: Cartridge {

  private var memoryModel: CartridgeMemoryModel = .rom

  internal override func writeRom(_ address: UInt16, value: UInt8) {
    switch address {

    // 0000-1FFF - RAM Enable
    case 0x0000...0x1fff:
      self.isRamBankEnabled = (value & 0b00001111) == 0x0a

    // 2000-3FFF - ROM Bank Number
    case 0x2000...0x3fff:
      let val = max(1, Int(value))
      let high = self.selectedRomBank & 0b11100000
      let low  = (val & 0b00011111)
      self.selectedRomBank = high | low

    // 4000-5FFF - RAM Bank Number - or - Upper Bits of ROM Bank Number
    case 0x4000...0x5fff:
      switch self.memoryModel {
      case .rom:
        let high = (Int(value) & 0b11) << 5
        let low  = self.selectedRomBank & 0b00011111
        self.selectedRomBank = high | low
      case .ram:
        self.selectedRamBank = Int(value & 0b00000011)
      }

    // 6000-7FFF - ROM/RAM Mode Select
    case 0x6000...0x7fff:
      let isRom = (value & 0b1) == 0b0
      self.memoryModel = isRom ? .rom : .ram

    default:
      print("Writing to invalid ROM address: \(address.hex).")
    }
  }

  internal override func writeRam(_ address: UInt16, value: UInt8) {
    let addr = address - MemoryMap.externalRam.start
    self.ramBanks[self.selectedRamBank][addr] = value
  }
}
