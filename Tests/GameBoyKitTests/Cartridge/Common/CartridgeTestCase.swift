// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import GameBoyKit

class CartridgeTestCase: XCTestCase {

  // MARK: - Has type

  func hasType(header: CartridgeHeader, allowedTypes: [CartridgeType]) -> Bool {
    return allowedTypes.contains { $0.headerValue == header.type.headerValue }
  }

  // MARK: - Create rom

  enum DestinationCode: UInt8 {
    case japanese = 0x00
    case nonJapanese = 0x01
  }

  // http://bgb.bircd.org/pandocs.htm#thecartridgeheader
  // swiftlint:disable:next function_parameter_count
  func createRom(title: String,
                 manufacturerCode: String,
                 type: CartridgeType,
                 destinationCode: DestinationCode,
                 romSize: CartridgeRomSize,
                 ramSize: CartridgeRamSize,
                 checksum: UInt8) -> Data {
    var data = Data(count: romSize.byteCount)

    // Taken from Tetris (means that title will be at 'CartridgeMap.newTitle')
    data[CartridgeMap.oldLicenseeCode] = 0x01

    let titleRange = CartridgeMap.newTitle
    assert(title.unicodeScalars.count <= titleRange.count)

    for (index, scalar) in title.unicodeScalars.enumerated() {
      assert(scalar.isASCII)
      data[Int(titleRange.start) + index] = UInt8(scalar.value)
    }

    let manufacturerRange = CartridgeMap.manufacturerCode
    assert(manufacturerCode.unicodeScalars.count <= manufacturerRange.count)

    for (index, scalar) in manufacturerCode.unicodeScalars.enumerated() {
      assert(scalar.isASCII)
      data[Int(manufacturerRange.start) + index] = UInt8(scalar.value)
    }

    data[CartridgeMap.type] = type.headerValue
    data[CartridgeMap.destinationCode] = destinationCode.rawValue

    data[CartridgeMap.romSize] = romSize.headerValue
    data[CartridgeMap.ramSize] = ramSize.headerValue

    data[CartridgeMap.headerChecksum] = checksum
    return data
  }

  // MARK: - Tetris, Pokemon

  /// noMbc(hasRam: false, hasBattery: false)
  func createTetrisRom() -> Data {
    return self.createRom(header: tetrisHeader, byteCount: 32_768)
  }

  /// mbc3(hasRam: true, hasBattery: true, hasRTC: false)
  func createPokemonRedRom() -> Data {
    return self.createRom(header: pokemonRedHeader, byteCount: 1_048_576)
  }

  private func createRom(header: [UInt8], byteCount: Int) -> Data {
    var data = Data(count: byteCount)

    let headerStart = 0x0100
    let headerEnd = headerStart + header.count
    data.replaceSubrange(headerStart..<headerEnd, with: header)

    return data
  }
}

// swiftlint:disable line_length
private let tetrisHeader: [UInt8] = [
/*            0     1     2     3     4     5     6     7     8     9    a      b     c     d     e     f */
/* 010X */ 0x00, 0xc3, 0x50, 0x01, 0xce, 0xed, 0x66, 0x66, 0xcc, 0x0d, 0x00, 0x0b, 0x03, 0x73, 0x00, 0x83,
/* 011X */ 0x00, 0x0c, 0x00, 0x0d, 0x00, 0x08, 0x11, 0x1f, 0x88, 0x89, 0x00, 0x0e, 0xdc, 0xcc, 0x6e, 0xe6,
/* 012X */ 0xdd, 0xdd, 0xd9, 0x99, 0xbb, 0xbb, 0x67, 0x63, 0x6e, 0x0e, 0xec, 0xcc, 0xdd, 0xdc, 0x99, 0x9f,
/* 013X */ 0xbb, 0xb9, 0x33, 0x3e, 0x54, 0x45, 0x54, 0x52, 0x49, 0x53, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
/* 014X */ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x01, 0x0a, 0x16, 0xbf
]

private let pokemonRedHeader: [UInt8] = [
/*            0     1     2     3     4     5     6     7     8     9    a      b     c     d     e     f */
/* 010X */ 0x00, 0xc3, 0x50, 0x01, 0xce, 0xed, 0x66, 0x66, 0xcc, 0x0d, 0x00, 0x0b, 0x03, 0x73, 0x00, 0x83,
/* 011X */ 0x00, 0x0c, 0x00, 0x0d, 0x00, 0x08, 0x11, 0x1f, 0x88, 0x89, 0x00, 0x0e, 0xdc, 0xcc, 0x6e, 0xe6,
/* 012X */ 0xdd, 0xdd, 0xd9, 0x99, 0xbb, 0xbb, 0x67, 0x63, 0x6e, 0x0e, 0xec, 0xcc, 0xdd, 0xdc, 0x99, 0x9f,
/* 013X */ 0xbb, 0xb9, 0x33, 0x3e, 0x50, 0x4f, 0x4b, 0x45, 0x4d, 0x4f, 0x4e, 0x20, 0x52, 0x45, 0x44, 0x00,
/* 014X */ 0x00, 0x00, 0x00, 0x00, 0x30, 0x31, 0x03, 0x13, 0x05, 0x03, 0x01, 0x33, 0x00, 0x20, 0x91, 0xe6
]
// swiftlint:enable line_length
