// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

public enum CartridgeFactory {

  /// This function creates new cartridge from given data.
  public static func create(rom: Data,
                            ram: ExternalRamState?) throws -> Cartridge {
    let header = try CartridgeHeader(rom: rom, skipChecks: false)
    try Self.checkRamSizeConsistency(header: header, ram: ram)
    return try Self.create(header: header, rom: rom, ram: ram)
  }

  /// This function creates new cartridge from given data.
  ///
  /// It will skip any check (for example: checksum, rom size etc.).
  public static func unchecked(rom: Data,
                               ram: ExternalRamState?) throws -> Cartridge {
    let header = try CartridgeHeader(rom: rom, skipChecks: true)
    return try Self.create(header: header, rom: rom, ram: ram)
  }

  private static func create(header: CartridgeHeader,
                             rom: Data,
                             ram: ExternalRamState?) throws -> Cartridge {
    let ram = ram?.data

    switch header.type.value {
    case .noMBC:
      return NoMBC(header: header, rom: rom, ram: ram)
    case .mbc1:
      return MBC1(header: header, rom: rom, ram: ram)
    case .mbc3:
      return MBC3(header: header, rom: rom, ram: ram)
    // Not implemented:
    // case .mbc2
    // case .mbc4
    // case .mbc5
    // case .mbc6
    // case .mbc7
    // case .huc1
    // case .huc3
    default:
      let raw = rom[CartridgeMap.type]
      throw CartridgeError.unsupportedType(raw)
    }
  }

  private static func checkRamSizeConsistency(header: CartridgeHeader,
                                              ram: ExternalRamState?) throws {
    guard let ram = ram else {
      return
    }

    let headerRam = header.ramSize
    let ramCount = ram.data.count

    if headerRam.byteCount != ramCount {
      throw CartridgeError.ramSizeNotConsistentProvidedSaveData(
        headerSize: headerRam,
        saveSize: ramCount
      )
    }
  }
}
