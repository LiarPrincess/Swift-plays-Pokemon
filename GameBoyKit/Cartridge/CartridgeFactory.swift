// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

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

  /// This function creates new cartridge from given data.
  ///
  /// - Parameter data: Cartridge content.
  /// - Parameter isTest: Tests have relaxed validation rules.
  public static func fromData(_ data: Data, isTest: Bool = false) throws -> Cartridge {
    let type = data[CartridgeMap.type]
    switch type {
    case 0x00: return try NoMBC(rom: data, isTest)
    case 0x08: return try NoMBC(rom: data, isTest) // ram
    case 0x09: return try NoMBC(rom: data, isTest) // ram, battery

    case 0x01: return try MBC1(rom: data, isTest)
    case 0x02: return try MBC1(rom: data, isTest) // ram
    case 0x03: return try MBC1(rom: data, isTest) // ram, battery

//    case 0x05: return try MBC2(rom: data, isTest)
//    case 0x06: return try MBC2(rom: data, isTest) // battery

    case 0x11: return try MBC3(rom: data, isTest)
    case 0x12: return try MBC3(rom: data, isTest) // ram
    case 0x13: return try MBC3(rom: data, isTest) // ram, battery
    case 0x0f: return try MBC3(rom: data, isTest) // battery, rtc
    case 0x10: return try MBC3(rom: data, isTest) // ram, battery, rtc

//    case 0x19: return try MBC5(rom: data, isTest)
//    case 0x1a: return try MBC5(rom: data, isTest) // ram
//    case 0x1b: return try MBC5(rom: data, isTest) // ram, battery
//    case 0x1c: return try MBC5(rom: data, isTest) // rumble
//    case 0x1d: return try MBC5(rom: data, isTest) // ram, rumble
//    case 0x1e: return try MBC5(rom: data, isTest) // ram, battery, rumble

//    case 0x20: return try MBC6(rom: data, isTest)
//    case 0x22: return try MBC7(rom: data, isTest)
//    case 0xff: return try Huc1(rom: data, isTest)
//    case 0xfe: return try Huc3(rom: data, isTest)

    default: break
    }

    throw CartridgeFactoryError.unsupportedType(type)
  }
}
