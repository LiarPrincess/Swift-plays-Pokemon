// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public enum CartridgeError: Error, CustomStringConvertible {

  case invalidChecksum(UInt8)
  case unsupportedRomSize(UInt8)
  case unsupportedRamSize(UInt8)
  case unsupportedType(UInt8)
  case romSizeNotConsistentWithHeader(headerSize: CartridgeRomSize, actualSize: Int)
  case ramInCartridgeThatDoesNotSupportRam(type: CartridgeType, headerRamSize: CartridgeRamSize)
  case ramSizeMissingInHeader(type: CartridgeType)

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
      return "ROM type '\(type.hex)' is currently not supported."

    case let .romSizeNotConsistentWithHeader(headerSize, actualSize):
      return "Expected \(headerSize.byteCount) bytes of cartridge ROM, got \(actualSize)."
    case let .ramInCartridgeThatDoesNotSupportRam(_, ramSize):
      return "Cartridge type does not support ram but ram is declared in header" +
             "(\(ramSize.byteCount) bytes)."
    case .ramSizeMissingInHeader:
      return "Cartridge type supports ram, but its size is missing in header."
    }
  }
}
