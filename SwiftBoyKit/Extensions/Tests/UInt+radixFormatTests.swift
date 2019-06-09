// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import SwiftBoyKit

class UIntRadixFormatTests: XCTestCase {

  // MARK: - UInt8

  func test_uint8_dec() {
    XCTAssertEqual(UInt8(0x05).dec, "  5")
    XCTAssertEqual(UInt8(0xff).dec, "255")
  }

  func test_uint8_hex() {
    XCTAssertEqual(UInt8(0x05).hex, "0x05")
    XCTAssertEqual(UInt8(0xff).hex, "0xff")
  }

  func test_uint8_bin() {
    XCTAssertEqual(UInt8(0x05).bin, "0b00000101")
    XCTAssertEqual(UInt8(0xff).bin, "0b11111111")
  }

  // MARK: - UInt16

  func test_uint16_dec() {
    XCTAssertEqual(UInt16(0x0005).dec, "    5")
    XCTAssertEqual(UInt16(0xffff).dec, "65535")
  }

  func test_uint16_hex() {
    XCTAssertEqual(UInt16(0x0005).hex, "0x0005")
    XCTAssertEqual(UInt16(0xffff).hex, "0xffff")
  }

  func test_uint16_bin() {
    XCTAssertEqual(UInt16(0x0005).bin, "0b0000000000000101")
    XCTAssertEqual(UInt16(0xffff).bin, "0b1111111111111111")
  }
}
