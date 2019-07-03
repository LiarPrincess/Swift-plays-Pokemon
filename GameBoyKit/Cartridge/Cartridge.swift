// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

public class Cartridge: CartridgeMemory {

  /// Size of single unit of rom (16 KBytes).
  public static let romBankSizeInBytes = 16 * 1_024

  /// Size of single unit of ram (8 KBytes).
  public static let ramBankSizeInBytes = 8 * 1_024

  /// 0000-3FFF 16KB ROM Bank 00 (in cartridge, fixed at bank 00);
  /// 4000-7FFF 16KB ROM Bank 01..NN (in cartridge, switchable bank number)
  public let rom: Data

  /// A000-BFFF External RAM (in cartridge, switchable bank, if any)
  public internal(set) var ramBanks: [Data]

  internal var selectedRomBank = 1
  internal var selectedRamBank = 0

  // this will be ignored anyway, but for consistency we have to have it
  internal var isRamBankEnabled = false

  internal init(rom: Data) throws {
    self.rom = rom

    let ramBankCount = try CartridgeHeader.getRamBankCount(rom: rom)
    self.ramBanks = (0..<ramBankCount).map { _ in
      Data(count: Cartridge.ramBankSizeInBytes)
    }
  }

  // MARK: - Rom

  internal func readRom(_ address: UInt16) -> UInt8 {
    switch address {
    case MemoryMap.rom0:
      return self.rom[address]

    case MemoryMap.rom1:
      let bankStart = self.selectedRomBank * Cartridge.romBankSizeInBytes
      let bankOffset = address - MemoryMap.rom1.start
      return self.rom[bankStart + Int(bankOffset)]

    default:
      print("Reading from invalid ROM address: \(address.hex).")
      return 0
    }
  }

  internal func writeRom(_ address: UInt16, value: UInt8) {
    // to override
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
    // to override
  }

  // MARK: - Header

  /// 0134-0143 - Title (Uppercase ASCII)
  public var title: String? {
    return CartridgeHeader.getTitle(rom: self.rom)
  }

  /// 013F-0142 - Manufacturer Code
  public var manufacturerCode: String? {
    return CartridgeHeader.getManufacturerCode(rom: self.rom)
  }

  /// 0147 - Cartridge Type
  public var type: CartridgeType {
    return CartridgeHeader.getType(rom: self.rom)
  }

  /// 014A - Destination Code
  public var destination: CartridgeDestination {
    return CartridgeHeader.getDestination(rom: self.rom)
  }
}
