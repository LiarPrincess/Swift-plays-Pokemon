// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

public class Cartridge: CartridgeMemory {

  public let header: CartridgeHeader

  /// 0000-3FFF 16KB ROM Bank 00 (in cartridge, fixed at bank 00);
  /// 4000-7FFF 16KB ROM Bank 01..NN (in cartridge, switchable bank number)
  public let rom: Data

  /// A000-BFFF External RAM (in cartridge, switchable bank, if any)
  public internal(set) var ram: MemoryBuffer

  /// Offset to selected 0000-3FFF bank.
  internal var romLowerBankStart = Int(MemoryMap.rom0.start)
  /// Offset to selected 4000-7FFF bank.
  internal var romUpperBankStart = Int(MemoryMap.rom1.start)
  /// Offset to selected ram bank.
  internal var ramBankStart = 0

  internal init(header: CartridgeHeader, rom: Data) {
    self.header = header
    self.rom = rom
    self.ram = MemoryBuffer(count: header.ramSize.byteCount)
  }

  deinit {
    self.ram.deallocate()
  }

  // MARK: - Rom

  public func readRomLowerBank(_ address: UInt16) -> UInt8 {
    let index = self.romLowerBankStart | (Int(address) & 0x3fff)
    return self.rom[index]
  }

  public func readRomUpperBank(_ address: UInt16) -> UInt8 {
    let index = self.romUpperBankStart | (Int(address) & 0x3fff)
    return self.rom[index]
  }

  internal func writeRom(_ address: UInt16, value: UInt8) {
    // to override
  }

  // MARK: - Ram

  /// A000-BFFF External RAM (in cartridge, switchable bank, if any)
  public func readRam(_ address: UInt16) -> UInt8 {
    if self.ram.isEmpty {
      return CartridgeConstants.defaultRam
    }

    let index = self.translateRamAddressToRamIndex(address)
    return self.ram[index]
  }

  /// A000-BFFF External RAM (in cartridge, switchable bank, if any)
  internal func writeRam(_ address: UInt16, value: UInt8) {
    if self.ram.isEmpty {
      return
    }

    let index = self.translateRamAddressToRamIndex(address)
    self.ram[index] = value
  }

  private func translateRamAddressToRamIndex(_ address: UInt16) -> Int {
    let bankOffset = address - MemoryMap.externalRam.start
    let index = self.ramBankStart + Int(bankOffset)

    assert(index < self.ram.count)
    return index
  }
}
