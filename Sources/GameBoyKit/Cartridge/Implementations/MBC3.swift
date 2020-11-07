// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

private let firstRomBank = 1

/// http://bgb.bircd.org/pandocs.htm#mbc3max2mbyteromandor32kbyteramandtimer
internal class MBC3: Cartridge {

  private var romBank = firstRomBank
  private var isRamRtcEnabled = false
  /// RAM or RTC? RTC is not supported.
  private var ramRtcSelect: UInt8 = 0

  override internal func writeRom(_ address: UInt16, value: UInt8) {
    switch address {

    // 0000-1FFF - RAM Enable
    case 0x0000...0x1fff:
      self.isRamRtcEnabled = (value & 0xff) == 0x0a

    // 2000-3FFF - ROM Bank Number
    case 0x2000...0x3fff:
      self.romBank = max(firstRomBank, Int(value))
      self.romLowerBankStart = 0x0000
      self.romUpperBankStart = self.romBank * CartridgeConstants.romBankSizeInBytes

    // 4000-5FFF - RAM Bank Number - or - RTC Register Select
    case 0x4000...0x5fff:
      self.ramRtcSelect = value & 0b1111
      let ramBank = Int(self.ramRtcSelect & 0b11)
      self.ramBankStart = ramBank * CartridgeConstants.ramBankSizeInBytes

    // 6000-7FFF - Latch Clock Data
    case 0x6000...0x7fff:
      break

    default:
      print("Writing to invalid ROM address: \(address.hex).")
    }
  }
}
