// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

// Common code for all cartridge implementations
internal protocol CartridgeMixin {

  var rom: Data { get }
  var ram: Data { get set }

  /// Offset to selected 0000-3FFF bank.
  var romLowerBankStart: Int { get }
  /// Offset to selected 4000-7FFF bank.
  var romUpperBankStart: Int { get }
  /// Offset to selected ram bank.
  var ramBankStart: Int { get }
}

extension CartridgeMixin {

  // MARK: - Rom

  /// 0000-3FFF 16KB ROM Bank 00 (in cartridge, fixed at bank 00);
  internal func readRomLowerBankMixin(_ address: UInt16) -> UInt8 {
    let index = self.toRomIndex(bankStart: self.romLowerBankStart, address: address)
    return self.rom[index]
  }

  /// 4000-7FFF 16KB ROM Bank 01..NN (in cartridge, switchable bank number)
  internal func readRomUpperBankMixin(_ address: UInt16) -> UInt8 {
    let index = self.toRomIndex(bankStart: self.romUpperBankStart, address: address)
    return self.rom[index]
  }

  internal func toRomIndex(bankStart: Int, address: UInt16) -> Int {
    // Given a number that is a power of 2, if we do '-1' we get its bit mask.
    // For example: 0b1000 -> 0b0111.
    let bankSizeMask = CartridgeConstants.romBankSizeInBytes - 1
    let result = bankStart | (Int(address) & bankSizeMask)
    assert(result < self.rom.count)
    return result
  }

  // MARK: - Ram

  internal func readRamMixin(_ address: UInt16) -> UInt8 {
    if self.ram.isEmpty {
      return CartridgeConstants.defaultRam
    }

    let index = self.toRamIndex(address: address)
    return self.ram[index]
  }

  internal mutating func writeRamMixin(_ address: UInt16, value: UInt8) {
    if self.ram.isEmpty {
      return
    }

    let index = self.toRamIndex(address: address)
    self.ram[index] = value
  }

  internal func toRamIndex(address: UInt16) -> Int {
    // Given a number that is a power of 2, if we do '-1' we get its bit mask.
    // For example: 0b1000 -> 0b0111.
    let bankSizeMask = CartridgeConstants.ramBankSizeInBytes - 1
    let result = self.ramBankStart | (Int(address) & bankSizeMask)
    assert(result < self.ram.count)
    return result
  }
}
