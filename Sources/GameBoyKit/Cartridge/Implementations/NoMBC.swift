// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

/// Rom without memory bank controller
///
/// http://bgb.bircd.org/pandocs.htm#none32kbyteromonly
internal struct NoMBC: Cartridge, CartridgeMixin {

  internal let header: CartridgeHeader
  internal let rom: Data
  internal var ram: Data

  /// Offset to selected 0000-3FFF bank.
  internal let romLowerBankStart = Int(MemoryMap.rom0.start)
  /// Offset to selected 4000-7FFF bank.
  internal let romUpperBankStart = Int(MemoryMap.rom1.start)
  /// Offset to selected ram bank.
  internal let ramBankStart = 0

  internal init(header: CartridgeHeader, rom: Data, ram: Data?) {
    self.header = header
    self.rom = rom
    self.ram = ram ?? Data(count: header.ramSize.byteCount)
  }

  // MARK: - Rom

  internal func readRomLowerBank(_ address: UInt16) -> UInt8 {
    return self.readRomLowerBankMixin(address)
  }

  internal func readRomUpperBank(_ address: UInt16) -> UInt8 {
    return self.readRomUpperBankMixin(address)
  }

  internal func writeRom(_ address: UInt16, value: UInt8) {
    // Writing not supported
  }

  // MARK: - Ram

  internal func readRam(_ address: UInt16) -> UInt8 {
    return self.readRamMixin(address)
  }

  internal mutating func writeRam(_ address: UInt16, value: UInt8) {
    self.writeRamMixin(address, value: value)
  }
}
