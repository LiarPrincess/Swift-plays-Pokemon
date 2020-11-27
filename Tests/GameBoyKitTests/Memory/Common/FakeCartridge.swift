// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
@testable import GameBoyKit

class FakeCartridge: Cartridge {

  var header: CartridgeHeader {
    fatalError("Not implemented")
  }

  lazy var rom: Data = {
    let count = MemoryMap.rom0.count + MemoryMap.rom1.count
    return Data(count: count)
  }()

  lazy var ram: Data = {
    let count = MemoryMap.externalRam.count
    return Data(count: count)
  }()

  func readRomLowerBank(_ address: UInt16) -> UInt8 {
    return self.rom[address - MemoryMap.rom0.start]
  }

  func readRomUpperBank(_ address: UInt16) -> UInt8 {
    // 'rom0' not 'rom1'!
    return self.rom[address - MemoryMap.rom0.start]
  }

  func writeRom(_ address: UInt16, value: UInt8) {
    self.rom[address - MemoryMap.rom0.start] = value
  }

  func readRam(_ address: UInt16) -> UInt8 {
    return self.ram[address - MemoryMap.externalRam.start]
  }

  func writeRam(_ address: UInt16, value: UInt8) {
    self.ram[address - MemoryMap.externalRam.start] = value
  }
}
