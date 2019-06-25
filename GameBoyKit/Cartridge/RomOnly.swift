// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

internal class RomOnly: Cartridge {

  internal override func writeRom(_ address: UInt16, value: UInt8) {
    switch address {
    case 0x2000...0x3fff:
      var val = max(1, Int(value))
      if val == 0x20 || val == 0x40 || val == 0x60 {
        val += 1
      }
      self.selectedRomBank = val

    default:
      print("Writing to invalid ROM address: \(address.hex).")
    }
  }

  internal override func writeRam(_ address: UInt16, value: UInt8) {
    let addr = address - MemoryMap.externalRam.start
    self.ramBanks[self.selectedRamBank][addr] = value
  }
}
