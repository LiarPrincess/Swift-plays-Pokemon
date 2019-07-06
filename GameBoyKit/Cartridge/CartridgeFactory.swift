// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public enum CartridgeFactoryError: Error, CustomStringConvertible {
  case invalidChecksum(UInt8)
  case unsupportedRomSize(UInt8)
  case unsupportedRamSize(UInt8)
  case unsupportedType(UInt8)
  case romSizeNotConsistentWithHeader(size: Int, headerSize: Int)

  public var description: String {
    switch self {
    case let .invalidChecksum(value):
      let range = CartridgeMap.headerChecksumRange
      let compare = CartridgeConstants.checksumCompare
      return "Checksum (bytes: \(range.start.hex)-\(range.end.hex)) is not " +
             "valid (it is \(value.hex), but it should be \(compare.hex))."

    case let .unsupportedRomSize(value):
      let address = CartridgeMap.romSize
      return "Unsupported ROM size \(value.hex) (at: \(address.hex))."

    case let .unsupportedRamSize(value):
      let address = CartridgeMap.ramSize
      return "Unsupported RAM size \(value.hex) (at: \(address.hex))."

    case let .unsupportedType(type):
      return "ROM type: '\(type.hex)' is not currently supported."

    case let .romSizeNotConsistentWithHeader(size, headerSize):
      return "Expected \(headerSize) bytes of cartridge ROM, got \(size)."
    }
  }
}

public enum CartridgeFactory {

  // swiftlint:disable:next function_body_length cyclomatic_complexity
  public static func fromData(_ data: Data) throws -> Cartridge {
    let type = data[CartridgeMap.type]
    switch type {
    case 0x00: return try NoMbc(rom: data)
    case 0x08: return try NoMbc(rom: data) // ram
    case 0x09: return try NoMbc(rom: data) // ram, battery

    case 0x01: return try MBC1(rom: data)
    case 0x02: return try MBC1(rom: data) // ram
    case 0x03: return try MBC1(rom: data) // ram, battery

//    case 0x05: return try Mbc2(rom: data)
//    case 0x06: return try Mbc2(rom: data) // battery

/* case .mbc3RamBattery: return try MBC1(rom: data) // TODO: for bootrom tests */
//    case 0x11: return Mbc3(ram: false, battery: false, rtc: false)
//    case 0x12: return Mbc3(ram: true, battery: false, rtc: false)
//    case 0x13: return Mbc3(ram: true, battery: true, rtc: false)
//    case 0x0f: return Mbc3(ram: false, battery: true, rtc: true)
//    case 0x10: return Mbc3(ram: true, battery: true, rtc: true)

//    case 0x19: return Mbc5(ram: false, battery: false, rumble: false)
//    case 0x1a: return Mbc5(ram: true, battery: false, rumble: false)
//    case 0x1b: return Mbc5(ram: true, battery: true, rumble: false)
//    case 0x1c: return Mbc5(ram: false, battery: false, rumble: true)
//    case 0x1d: return Mbc5(ram: true, battery: false, rumble: true)
//    case 0x1e: return Mbc5(ram: true, battery: true, rumble: true)

//    case 0x20: return Mbc6
//    case 0x22: return Mbc7
//    case 0xff: return Huc1
//    case 0xfe: return Huc3
    default: break
    }

    throw CartridgeFactoryError.unsupportedType(type)
  }
}
