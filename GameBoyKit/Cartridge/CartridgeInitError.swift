// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public enum CartridgeInitError: Error, CustomStringConvertible {
  case invalidChecksum(UInt8)
  case invalidRomBankCount(UInt8)
  case invalidRamBankCount(UInt8)
  case unsupportedType(CartridgeType)

  // fatalError("Invalid ROM size, it should be at least \(minSize) bytes long.")
  // fatalError("Unable to parse ROM size \(value) (address: \(romSizeAddress.hex).")
  public var description: String {
    switch self {
    case let .invalidChecksum(value):
      let range = CartridgeMap.headerChecksumRange
      let compare = CartridgeHeader.checksumCompare
      return "ROM checksum (bytes: \(range.start.hex)-\(range.end.hex)) is not valid (it is \(value.hex), but it should be \(compare.hex))."

    case let .invalidRomBankCount(count):
      return "XXX"

    case let .invalidRamBankCount(count):
      return "XXX"

    case let .unsupportedType(type):
      return "Unsupported ROM type: '\(type)'."
    }
  }
}
