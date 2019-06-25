// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

public class Cartridge {

  internal static let minSize = MemoryMap.rom0.count

  /// Size of single unit of ram (8 KBytes).
  public static let ramBankSizeInBytes = 8 * 1_024

  /// 0000-3FFF 16KB ROM Bank 00 (in cartridge, fixed at bank 00);
  /// 4000-7FFF 16KB ROM Bank 01..NN (in cartridge, switchable bank number)
  public let rom: Rom

  /// A000-BFFF External RAM (in cartridge, switchable bank, if any)
  public private(set) var ramBanks: [Data]

  private var selectedRamBank: Int = 0

  public init(rom: Data) throws {
    guard rom.count >= Cartridge.minSize else {
      throw CartridgeInitError.invalidSize
    }

    let checksum = CartridgeHeader.isChecksumValid(rom)
    if case let ChecksumResult.invalid(value) = checksum {
      throw CartridgeInitError.invalidChecksum(value)
    }

    self.rom = try RomFactory.create(rom)

    let ramBankCount = try CartridgeHeader.getRamBankCount(rom: rom)
    self.ramBanks = (0..<ramBankCount).map { _ in
      Data(count: Cartridge.ramBankSizeInBytes)
    }
  }

  // MARK: - Rom

  internal func readRomBank0(_ address: UInt16) -> UInt8 {
    return self.rom.readBank0(address)
  }

  internal func readRomBankN(_ address: UInt16) -> UInt8 {
    return self.rom.readBankN(address)
  }

  internal func writeRomBank0(_ address: UInt16, value: UInt8) {
    self.rom.writeBank0(address, value: value)
  }

  internal func writeRomBankN(_ address: UInt16, value: UInt8) {
    self.rom.writeBankN(address, value: value)
  }

  // MARK: - Ram

  public func readRam(_ address: UInt16) -> UInt8 {
    // TODO: RTC?
    // if self.rtc_enabled and 0x08 <= self.rambank_selected <= 0x0C:
    //   return self.rtc.getregister(self.rambank_selected)

    let addr = address - MemoryMap.externalRam.start
    return self.ramBanks[self.selectedRamBank][addr]
  }

  internal func writeRam(_ address: UInt16, value: UInt8) {
    let addr = address - MemoryMap.externalRam.start
    self.ramBanks[self.selectedRamBank][addr] = value
  }

  // MARK: - Header

  /// 0134-0143 - Title (Uppercase ASCII)
  public var title: String? {
    return CartridgeHeader.getTitle(rom: self.rom.data)
  }

  /// 013F-0142 - Manufacturer Code
  public var manufacturerCode: String? {
    return CartridgeHeader.getManufacturerCode(rom: self.rom.data)
  }

  /// 0147 - Cartridge Type
  public var type: CartridgeType {
    return CartridgeHeader.getType(rom: self.rom.data)
  }

  /// 014A - Destination Code
  public var destination: CartridgeDestination {
    return CartridgeHeader.getDestination(rom: self.rom.data)
  }
}
