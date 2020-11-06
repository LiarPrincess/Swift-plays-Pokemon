// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

// swiftlint:disable cyclomatic_complexity

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
  public static func create(data: Data) throws -> Cartridge {
    let header = try CartridgeHeader(rom: data, skipChecks: false)
    return try Self.create(header: header, data: data)
  }

  /// This function creates new cartridge from given data.
  ///
  /// It will skip any check (for example: checksum, rom size etc.).
  public static func unchecked(data: Data) throws -> Cartridge {
    let header = try CartridgeHeader(rom: data, skipChecks: true)
    return try Self.create(header: header, data: data)
  }

  private static func create(header: CartridgeHeader, data: Data) throws -> Cartridge {
    switch header.type.value {
    case .noMBC:
      return NoMBC(header: header, rom: data)
    case .mbc1:
      return MBC1(header: header, rom: data)
    case .mbc3:
      return MBC3(header: header, rom: data)
    // Not implemented:
    // case .mbc2
    // case .mbc4
    // case .mbc5
    // case .mbc6
    // case .mbc7
    // case .huc1
    // case .huc3
    default:
      let raw = data[CartridgeMap.type]
      throw CartridgeError.unsupportedType(raw)
    }
  }
}
