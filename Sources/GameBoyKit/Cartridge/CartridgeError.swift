// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

public enum CartridgeError: Error, CustomStringConvertible {

  case invalidChecksum(UInt8)

  /// Type value in header is not known
  case unknownType(UInt8)
  /// Type is known, but not implemented
  case unimplementedType(CartridgeType)
  case unsupportedRomSize(UInt8)
  case unsupportedRamSize(UInt8)

  case romSizeNotConsistentWithHeader(headerSize: CartridgeRomSize, rom: Data)

  case ramSizeMissingInCartridgeThatRequiresRam(type: CartridgeType)
  case ramInCartridgeThatDoesNotSupportRam(type: CartridgeType, headerRamSize: CartridgeRamSize)
  case ramSizeNotConsistentWithHeader(headerSize: CartridgeRamSize, ram: ExternalRamState)

  public var description: String {
    switch self {
    case let .invalidChecksum(value):
      let range = CartridgeMap.headerChecksumRange
      let compare = CartridgeConstants.checksumCompare
      return "Checksum (bytes: \(range.start.hex)-\(range.end.hex)) is not " +
             "valid (it is \(value.hex), but it should be \(compare.hex))."

    case let .unknownType(value):
      return "Unknown ROM type '\(value)'."
    case let .unimplementedType(type):
      return "ROM type '\(type)' is currently not supported."
    case let .unsupportedRomSize(value):
      let address = CartridgeMap.romSize
      return "Unsupported ROM size \(value.hex) (at: \(address.hex))."
    case let .unsupportedRamSize(value):
      let address = CartridgeMap.ramSize
      return "Unsupported RAM size \(value.hex) (at: \(address.hex))."

    case let .romSizeNotConsistentWithHeader(headerSize, rom):
      let expected = headerSize.byteCount
      let actual = rom.count
      return "Expected \(expected) bytes of cartridge ROM, got \(actual)."

    case let .ramSizeMissingInCartridgeThatRequiresRam(type):
      return "Cartridge type '\(type)' requires ram, but its size is missing in header."
    case let .ramInCartridgeThatDoesNotSupportRam(_, ramSize):
      return "Cartridge type does not support ram, but ram is declared in header " +
             "(\(ramSize.byteCount) bytes)."
    case let .ramSizeNotConsistentWithHeader(headerSize, ram):
      let expected = headerSize.byteCount
      let actual = ram.data.count
      return "Expected \(expected) bytes of saved RAM, got \(actual)."
    }
  }
}
