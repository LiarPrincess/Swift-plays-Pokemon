// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

// Basically:
// http://bgb.bircd.org/pandocs.htm#thecartridgeheader
extension Cartridge {

  // MARK: - Checksum

  internal enum ChecksumResult {
    case valid
    case invalid(UInt8)
  }

  /// Code from bootrom: 0x00f1 to 0x00fa:
  /// if 0x19 + bytes from 0x0134-0x014d don't add to 0 ->  lock up
  internal static func isChecksumValid(_ data: Data) -> ChecksumResult {
    var hl: UInt16 = CartridgeMap.headerChecksumRange.start

    var b: UInt8 = 0x19 // 0x00f1
    var a: UInt8 = b    // 0x00f3

    while b > 0 {
      a &+= data[hl] // 0x00f4
      hl += 1        // 0x00f5
      b -= 1         // 0x00f6
    }
    a &+= data[hl] // 0x00f9

    let isValid = a == checksumCompare // 0x00fa
    return isValid ? .valid : .invalid(a)
  }

  // MARK: - Header

  internal static func getInterruptVectors(rom: Data) -> Data {
    return rom[CartridgeMap.interruptVectors]
  }

  internal static func getEntryPoint(rom: Data) -> Data {
    return rom[CartridgeMap.entryPoint]
  }

  internal static func getNintendoLogo(rom: Data) -> Data {
    return rom[CartridgeMap.nintendoLogo]
  }

  internal static func getTitle(rom: Data) -> String? {
    return asci(from: rom[CartridgeMap.title])
  }

  internal static func getManufacturerCode(rom: Data) -> String? {
    return asci(from: rom[CartridgeMap.manufacturerCode])
  }

  internal static func getDestination(rom: Data) -> CartridgeDestination {
    switch rom[CartridgeMap.destinationCode] {
    case 0: return .japanese
    case 1: return .nonJapanese
    default: return .unknown
    }
  }

  internal static func getVersionNumber(rom: Data) -> UInt8 {
    return rom[CartridgeMap.versionNumber]
  }

  internal static func getNewLicenseeCode(rom: Data) -> String? {
    return asci(from: rom[CartridgeMap.newLicenseeCode])
  }

  internal static func getOldLicenseeCode(rom: Data) -> UInt8 {
    return rom[CartridgeMap.oldLicenseeCode]
  }

  internal static func getCgbFlag(rom: Data) -> UInt8 {
    return rom[CartridgeMap.cgbFlag]
  }

  internal static func getSgbFlag(rom: Data) -> UInt8 {
    return rom[CartridgeMap.sgbFlag]
  }

  // swiftlint:disable:next function_body_length cyclomatic_complexity
  internal static func getType(rom: Data) -> CartridgeType {
    switch rom[CartridgeMap.type] {
    case 0x00: return .romOnly
    case 0x01: return .mbc1
    case 0x02: return .mbc1Ram
    case 0x03: return .mbc1RamBattery
    case 0x05: return .mbc2
    case 0x06: return .mbc2Battery
    case 0x08: return .romRam
    case 0x09: return .romRamBattery
    case 0x0b: return .mmm01
    case 0x0c: return .mmm01Ram
    case 0x0d: return .mmm01RamBattery
    case 0x0f: return .mbc3TimerBattery
    case 0x10: return .mbc3TimerRamBattery
    case 0x11: return .mbc3
    case 0x12: return .mbc3Ram
    case 0x13: return .mbc3RamBattery
    case 0x15: return .mbc4
    case 0x16: return .mbc4Ram
    case 0x17: return .mbc4RamBattery
    case 0x19: return .mbc5
    case 0x1a: return .mbc5Ram
    case 0x1b: return .mbc5RamBattery
    case 0x1c: return .mbc5Rumble
    case 0x1d: return .mbc5RumbleRam
    case 0x1e: return .mbc5RumbleRamBattery
    case 0xfc: return .pocketCamera
    case 0xfd: return .bandaiTama5
    case 0xfe: return .huc3
    case 0xff: return .huc1RamBattery
    default: return .romOnly // not really possible (UInt8)
    }
  }

  internal static func getRomSize(rom: Data) -> UInt8 {
    return rom[CartridgeMap.romSize]
  }

  internal static func getRamSize(rom: Data) -> UInt8 {
    return rom[CartridgeMap.ramSize]
  }

  internal static func getHeaderChecksum(rom: Data) -> UInt8 {
    return rom[CartridgeMap.headerChecksum]
  }

  internal static func getGlobalChecksum(rom: Data) -> Data {
    return rom[CartridgeMap.globalChecksum]
  }
}

private func asci(from data: Data) -> String? {
  var endIndex = data.endIndex.advanced(by: -1)
  while endIndex >= data.startIndex && data[endIndex] == 0 {
    endIndex = endIndex.advanced(by: -1)
  }

  let titleData = data.prefix(upTo: endIndex + 1)
  return endIndex <= data.startIndex ? nil :
    String(data: titleData, encoding: .ascii)
}
