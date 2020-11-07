// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

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
