// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

@testable import GameBoyKit

class FakeBusCartridge: BusCartridge {

  lazy var rom: Data = {
    let count = MemoryMap.rom0.count + MemoryMap.rom1.count
    return Data(count: count)
  }()

  lazy var ram: Data = {
    let count = MemoryMap.externalRam.count
    return Data(count: count)
  }()

  func readRomBank0(_ address: UInt16) -> UInt8 {
    return self.rom[address - MemoryMap.rom0.start]
  }

  func readRomBankN(_ address: UInt16) -> UInt8 {
    return self.rom[address - MemoryMap.rom0.start]
  }

  func writeRomBank0(_ address: UInt16, value: UInt8) {
    self.rom[address - MemoryMap.rom0.start] = value
  }

  func writeRomBankN(_ address: UInt16, value: UInt8) {
    self.rom[address - MemoryMap.rom0.start] = value
  }

  func readRam(_ address: UInt16) -> UInt8 {
    return self.ram[address - MemoryMap.externalRam.start]
  }

  func writeRam(_ address: UInt16, value: UInt8) {
    self.ram[address - MemoryMap.externalRam.start] = value
  }
}
