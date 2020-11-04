// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

private typealias Constants = CartridgeConstants

// Sources:
// - https://github.com/Gekkio/mooneye-gb
// - https://gekkio.fi/files/gb-docs/gbctr.pdf
// - http://bgb.bircd.org/pandocs.htm#thecartridgeheader
public class Cartridge: CartridgeMemory {

  /// Game title.
  public let title: String

  /// 0000-3FFF 16KB ROM Bank 00 (in cartridge, fixed at bank 00);
  /// 4000-7FFF 16KB ROM Bank 01..NN (in cartridge, switchable bank number)
  public let rom: Data

  /// A000-BFFF External RAM (in cartridge, switchable bank, if any)
  public internal(set) var ram: MemoryData

  /// Offset to selected 0000-3FFF bank.
  internal var romLowerBankStart = Int(MemoryMap.rom0.start)

  /// Offset to selected 4000-7FFF bank.
  internal var romUpperBankStart = Int(MemoryMap.rom1.start)

  /// Offset to selected ram bank.
  internal var ramBankStart = 0

  internal init(rom: Data, _ isTest: Bool) throws {
    let checksum: ChecksumResult = isTest ? .valid : isChecksumValid(rom)
    if case let ChecksumResult.invalid(value) = checksum {
      throw CartridgeFactoryError.invalidChecksum(value)
    }

    let isNewCartridge = rom[CartridgeMap.oldLicenseeCode] == 0x33
    let titleRange = isNewCartridge ? CartridgeMap.newTitle : CartridgeMap.oldTitle

    // For some reason if we don't cast to Int we get:
    // 'Not enough bits to represent the passed value'
    let start = Int(titleRange.start)
    let end   = Int(titleRange.end)
    self.title = asci(from: rom[start...end]) ?? ""

    let romSize = try getRomSize(rom[CartridgeMap.romSize])
    guard isTest || rom.count == romSize else {
      throw CartridgeFactoryError
        .romSizeNotConsistentWithHeader(size: rom.count, headerSize: romSize)
    }
    self.rom = rom

    let ramSize = try getRamSize(rom[CartridgeMap.ramSize])
    self.ram = MemoryData.allocate(capacity: ramSize)
  }

  deinit {
    self.ram.deallocate()
  }

  // MARK: - Rom

  /// 0000-3FFF 16KB ROM Bank 00 (in cartridge, fixed at bank 00);
  /// 4000-7FFF 16KB ROM Bank 01..NN (in cartridge, switchable bank number)
  public func readRom(_ address: UInt16) -> UInt8 {
    switch address {
    case MemoryMap.rom0:
      let index = self.romLowerBankStart | (Int(address) & 0x3fff)
      return self.rom[index]

    case MemoryMap.rom1:
      let index = self.romUpperBankStart | (Int(address) & 0x3fff)
      return self.rom[index]

    default:
      print("Reading from invalid ROM address: \(address.hex).")
      return 0
    }
  }

  /// 0000-3FFF 16KB ROM Bank 00 (in cartridge, fixed at bank 00);
  /// 4000-7FFF 16KB ROM Bank 01..NN (in cartridge, switchable bank number)
  internal func writeRom(_ address: UInt16, value: UInt8) {
    // to override
  }

  // MARK: - Ram

  /// A000-BFFF External RAM (in cartridge, switchable bank, if any)
  public func readRam(_ address: UInt16) -> UInt8 {
    if self.ram.isEmpty { return Constants.defaultRam }

    let index = self.translateRamAddressToRamIndex(address)
    assert(index < self.ram.count)
    return self.ram[index]
  }

  /// A000-BFFF External RAM (in cartridge, switchable bank, if any)
  internal func writeRam(_ address: UInt16, value: UInt8) {
    if self.ram.isEmpty { return }

    let index = self.translateRamAddressToRamIndex(address)
    assert(index < self.ram.count)
    self.ram[index] = value
  }

  private func translateRamAddressToRamIndex(_ address: UInt16) -> Int {
    let bankOffset = address - MemoryMap.externalRam.start
    return self.ramBankStart + Int(bankOffset)
  }
}

// MARK: - Checksum

private enum ChecksumResult {
  case valid
  case invalid(UInt8)
}

/// Code from bootrom: 0x00f1 to 0x00fa:
/// If 0x19 + bytes from 0x0134-0x014d don't add to 0 ->  lock up.
private func isChecksumValid(_ data: Data) -> ChecksumResult {
  var hl: UInt16 = CartridgeMap.headerChecksumRange.start

  var b: UInt8 = 0x19 // bootrom: 0x00f1
  var a: UInt8 = b    // bootrom: 0x00f3

  while b > 0 {
    a &+= data[hl] // bootrom: 0x00f4
    hl += 1        // bootrom: 0x00f5
    b -= 1         // bootrom: 0x00f6
  }
  a &+= data[hl] // bootrom: 0x00f9

  let isValid = a == Constants.checksumCompare // bootrom: 0x00fa
  return isValid ? .valid : .invalid(a)
}

// MARK: - Banks

// swiftlint:disable:next cyclomatic_complexity
private func getRomSize(_ value: UInt8) throws -> Int {
  let bankSize = Constants.romBankSizeInBytes
  switch value {
  case 0x00: return   2 * bankSize // 32 KB (no ROM banking)
  case 0x01: return   4 * bankSize // 64 KB
  case 0x02: return   8 * bankSize // 128 KB
  case 0x03: return  16 * bankSize // 256 KB
  case 0x04: return  32 * bankSize // 512 KB
  case 0x05: return  64 * bankSize // 1 MB
  case 0x06: return 128 * bankSize // 2 MB
  case 0x07: return 256 * bankSize // 4 MB
  case 0x08: return 512 * bankSize // 8 MB
  case 0x52: return  72 * bankSize // 1.1 MB
  case 0x53: return  80 * bankSize // 1.2 MB
  case 0x54: return  96 * bankSize // 1.5 MB
  default:
    throw CartridgeFactoryError.unsupportedRomSize(value)
  }
}

private func getRamSize(_ value: UInt8) throws -> Int {
  switch value {
  case 0x00: return      0
  case 0x01: return   2_048 //   2 KB
  case 0x02: return   8_192 //   8 Kb
  case 0x03: return  32_768 //  32 KB
  case 0x04: return 131_072 // 128 KB
  case 0x05: return  65_536 //  64 KB
  default:
    throw CartridgeFactoryError.unsupportedRamSize(value)
  }
}

// MARK: - ASCII

private func asci(from data: Data) -> String? {
  var endIndex = data.endIndex.advanced(by: -1)
  while endIndex >= data.startIndex && data[endIndex] == 0 {
    endIndex = endIndex.advanced(by: -1)
  }

  let titleData = data.prefix(upTo: endIndex + 1)
  return endIndex <= data.startIndex ?
    nil :
    String(data: titleData, encoding: .ascii)
}
