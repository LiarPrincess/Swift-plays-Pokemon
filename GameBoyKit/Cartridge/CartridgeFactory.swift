// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public enum CartridgeFactory {

  // swiftlint:disable:next function_body_length cyclomatic_complexity
  public static func fromData(_ data: Data) throws -> Cartridge {
    let checksum = CartridgeHeader.isChecksumValid(data)
    if case let ChecksumResult.invalid(value) = checksum {
      throw CartridgeInitError.invalidChecksum(value)
    }

    let type = CartridgeHeader.getType(rom: data)
    switch type {
    case .romOnly: return try RomOnly(rom: data)

    case .mbc1: return try MBC1(rom: data)
    case .mbc1Ram: return try MBC1(rom: data)
    case .mbc1RamBattery: return try MBC1(rom: data)

    case .mbc2: break
    case .mbc2Battery: break

    case .romRam: break
    case .romRamBattery: break

    case .mmm01: break
    case .mmm01Ram: break
    case .mmm01RamBattery: break

    case .mbc3TimerBattery: break
    case .mbc3TimerRamBattery: break
    case .mbc3: break
    case .mbc3Ram: break
    case .mbc3RamBattery: break

    case .mbc4: break
    case .mbc4Ram: break
    case .mbc4RamBattery: break

    case .mbc5: break
    case .mbc5Ram: break
    case .mbc5RamBattery: break
    case .mbc5Rumble: break
    case .mbc5RumbleRam: break
    case .mbc5RumbleRamBattery: break

    case .pocketCamera: break
    case .bandaiTama5: break
    case .huc3: break
    case .huc1RamBattery: break
    }

    throw CartridgeInitError.unsupportedType(type)
  }
}
