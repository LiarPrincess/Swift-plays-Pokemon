// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

// Sources:
// - http://bgb.bircd.org/pandocs.htm#thecartridgeheader
// - https://github.com/Gekkio/mooneye-gb
// - https://gekkio.fi/files/gb-docs/gbctr.pdf
public struct CartridgeHeader {

  public let title: String
  public let type: CartridgeType
  public let romSize: CartridgeRomSize
  public let ramSize: CartridgeRamSize

  internal init(rom: Data, skipChecks: Bool) throws {
    let performChecks = !skipChecks

    if performChecks {
      switch isChecksumValid(rom) {
      case .valid: break
      case .invalid(let value): throw CartridgeError.invalidChecksum(value)
      }
    }

    self.title = getTitle(rom: rom) ?? "??"

    let typeRaw = rom[CartridgeMap.type]
    self.type = try CartridgeType(headerValue: typeRaw)

    let romSizeRaw = rom[CartridgeMap.romSize]
    self.romSize = try CartridgeRomSize(headerValue: romSizeRaw)

    let ramSizeRaw = rom[CartridgeMap.ramSize]
    self.ramSize = try CartridgeRamSize(headerValue: ramSizeRaw)

    if performChecks {
      try self.performChecks(rom: rom)
    }
  }

  private func performChecks(rom: Data) throws {
    if rom.count != self.romSize.byteCount {
      throw CartridgeError.romSizeNotConsistentWithHeader(
        headerSize: self.romSize,
        rom: rom
      )
    }

    let hasRamByType = self.type.hasRam
    let hasRamByHeader = self.ramSize.byteCount != 0

    if hasRamByType && !hasRamByHeader {
      throw CartridgeError.ramSizeMissingInCartridgeThatRequiresRam(type: self.type)
    }

    if !hasRamByType && hasRamByHeader {
      throw CartridgeError.ramInCartridgeThatDoesNotSupportRam(
        type: self.type,
        headerRamSize: self.ramSize
      )
    }
  }
}

// MARK: - Checksum

private enum ChecksumResult {
  case valid
  case invalid(UInt8)
}

/// Code from bootrom: 0x00f1 to 0x00fa:
/// If 0x19 + bytes from 0x0134-0x014d don't add to 0 ->  lock up.
private func isChecksumValid(_ data: Data) -> ChecksumResult {
  var hl: UInt16 = CartridgeMap.headerChecksumRange.start

  var b: UInt8 = 0x19 // bootrom: 0x00f1
  var a: UInt8 = b // bootrom: 0x00f3

  while b > 0 {
    a &+= data[hl] // bootrom: 0x00f4
    hl += 1 // bootrom: 0x00f5
    b -= 1 // bootrom: 0x00f6
  }
  a &+= data[hl] // bootrom: 0x00f9

  let isValid = a == CartridgeConstants.checksumCompare // bootrom: 0x00fa
  return isValid ? .valid : .invalid(a)
}

// MARK: - Title

private func getTitle(rom: Data) -> String? {
  let isNewCartridge = rom[CartridgeMap.oldLicenseeCode] == 0x33
  let range = isNewCartridge ? CartridgeMap.newTitle : CartridgeMap.oldTitle

  // For some reason if we don't cast to Int we get:
  // 'Not enough bits to represent the passed value'
  let start = Int(range.start)
  let end = Int(range.end)
  return asci(from: rom[start...end])
}

private func asci(from data: Data) -> String? {
  var endIndex = data.endIndex.advanced(by: -1)
  while endIndex >= data.startIndex && data[endIndex] == 0 {
    endIndex = endIndex.advanced(by: -1)
  }

  let titleData = data.prefix(upTo: endIndex + 1)
  return endIndex <= data.startIndex ?
    nil :
    String(data: titleData, encoding: .ascii)
}
