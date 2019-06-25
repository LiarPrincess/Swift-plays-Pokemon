// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

// TODO: Implement ROM banking
// TODO: Implement RAM banking

public class Cartridge {

  internal static let checksumCompare: UInt8 = 0

  internal static let minSize = MemoryMap.rom0.count

  /// 0000-3FFF 16KB ROM Bank 00 (in cartridge, fixed at bank 00)
//  public private(set) lazy var rom0 = self.rom[MemoryMap.rom0]

  /// 4000-7FFF 16KB ROM Bank 01..NN (in cartridge, switchable bank number)
//  public private(set) lazy var rom1 = self.rom[MemoryMap.rom1]

  public let rom: Data

  /// A000-BFFF 8KB External RAM (in cartridge, switchable bank, if any)
  public internal(set) var ram = Data(memoryRange: MemoryMap.externalRam)

  public init(rom: Data) throws {
    guard rom.count >= Cartridge.minSize else {
      throw CartridgeInitError.invalidSize
    }

    let checksum = Cartridge.isChecksumValid(rom)
    if case let ChecksumResult.invalid(value) = checksum {
      throw CartridgeInitError.invalidChecksum(value)
    }

    self.rom = rom
  }

  // MARK: - Header

  /// 0134-0143 - Title (Uppercase ASCII)
  public var title: String? {
    return Cartridge.getTitle(rom: self.rom)
  }

  /// 013F-0142 - Manufacturer Code
  public var manufacturerCode: String? {
    return Cartridge.getManufacturerCode(rom: self.rom)
  }

  /// 0147 - Cartridge Type
  public var type: CartridgeType {
    return Cartridge.getType(rom: self.rom)
  }

  /// 014A - Destination Code
  public var destination: CartridgeDestination {
    return Cartridge.getDestination(rom: self.rom)
  }
}
