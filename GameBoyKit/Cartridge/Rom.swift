// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

public class Rom {

  /// Size of single unit of rom (16 KBytes).
  public static let romBankSizeInBytes: UInt16 = 16 * 1_024

  /// 0000-3FFF 16KB ROM Bank 00 (in cartridge, fixed at bank 00)
  //  public private(set) lazy var rom0 = self.rom[MemoryMap.rom0]

  /// 4000-7FFF 16KB ROM Bank 01..NN (in cartridge, switchable bank number)
  //  public private(set) lazy var rom1 = self.rom[MemoryMap.rom1]

  public let data: Data

  internal var selectedRamBank: UInt16 = 0

  internal init(data: Data) {
    self.data = data
  }

  internal func readBank0(_ address: UInt16) -> UInt8 {
    return self.data[address]
  }

  internal func readBankN(_ address: UInt16) -> UInt8 {
    let bankStart = self.selectedRamBank * Rom.romBankSizeInBytes
    let bankOffset = address - MemoryMap.rom1.start
    return self.data[bankStart + bankOffset]
  }

  internal func writeBank0(_ address: UInt16, value: UInt8) {
    // to override
  }

  internal func writeBankN(_ address: UInt16, value: UInt8) {
    // to override
  }
}
