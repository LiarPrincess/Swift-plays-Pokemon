// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

// TODO: Implement ROM banking
// TODO: Implement RAM banking

public class Cartridge {

  internal static let minSize = MemoryMap.rom0.count

  /// 0000-3FFF 16KB ROM Bank 00 (in cartridge, fixed at bank 00)
//  public private(set) lazy var rom0 = self.rom[MemoryMap.rom0]

  /// 4000-7FFF 16KB ROM Bank 01..NN (in cartridge, switchable bank number)
//  public private(set) lazy var rom1 = self.rom[MemoryMap.rom1]

  public let rom: Data

  /// A000-BFFF External RAM (in cartridge, switchable bank, if any)
  public internal(set) var ram: Data

  public init(rom: Data) throws {
    guard rom.count >= Cartridge.minSize else {
      throw CartridgeInitError.invalidSize
    }

    let checksum = CartridgeHeader.isChecksumValid(rom)
    if case let ChecksumResult.invalid(value) = checksum {
      throw CartridgeInitError.invalidChecksum(value)
    }

    self.rom = rom

    let ramSize = try CartridgeHeader.getRamSize(rom: rom)
    self.ram = Data(count: ramSize)
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
