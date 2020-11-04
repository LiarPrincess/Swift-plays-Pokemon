// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import GameBoyKit

class CpuRegistersTests: XCTestCase {

  func test_get_f() {
    var registers = Registers()
    XCTAssertEqual(registers.f, 0b000_00000)

    registers.zeroFlag = true
    XCTAssertEqual(registers.f, 0b1000_0000)

    registers.subtractFlag = true
    XCTAssertEqual(registers.f, 0b1100_0000)

    registers.halfCarryFlag = true
    XCTAssertEqual(registers.f, 0b1110_0000)

    registers.carryFlag = true
    XCTAssertEqual(registers.f, 0b1111_0000)

    registers.zeroFlag = false
    XCTAssertEqual(registers.f, 0b0111_0000)

    registers.subtractFlag = false
    XCTAssertEqual(registers.f, 0b0011_0000)

    registers.halfCarryFlag = false
    XCTAssertEqual(registers.f, 0b0001_0000)

    registers.carryFlag = false
    XCTAssertEqual(registers.f, 0b0000_0000)
  }

  // swiftlint:disable:next function_body_length
  func test_set_f() {
    var registers = Registers()

    registers.f = 0b0000_0000
    XCTAssertEqual(registers.zeroFlag, false)
    XCTAssertEqual(registers.subtractFlag, false)
    XCTAssertEqual(registers.halfCarryFlag, false)
    XCTAssertEqual(registers.carryFlag, false)

    for shift in 0...3 {
      registers.f |= 0b1 << shift
      XCTAssertEqual(registers.zeroFlag, false)
      XCTAssertEqual(registers.subtractFlag, false)
      XCTAssertEqual(registers.halfCarryFlag, false)
      XCTAssertEqual(registers.carryFlag, false)
    }

    registers.f |= 0b0001_0000
    XCTAssertEqual(registers.zeroFlag, false)
    XCTAssertEqual(registers.subtractFlag, false)
    XCTAssertEqual(registers.halfCarryFlag, false)
    XCTAssertEqual(registers.carryFlag, true)

    registers.f |= 0b0010_0000
    XCTAssertEqual(registers.zeroFlag, false)
    XCTAssertEqual(registers.subtractFlag, false)
    XCTAssertEqual(registers.halfCarryFlag, true)
    XCTAssertEqual(registers.carryFlag, true)

    registers.f |= 0b0100_0000
    XCTAssertEqual(registers.zeroFlag, false)
    XCTAssertEqual(registers.subtractFlag, true)
    XCTAssertEqual(registers.halfCarryFlag, true)
    XCTAssertEqual(registers.carryFlag, true)

    registers.f |= 0b1000_0000
    XCTAssertEqual(registers.zeroFlag, true)
    XCTAssertEqual(registers.subtractFlag, true)
    XCTAssertEqual(registers.halfCarryFlag, true)
    XCTAssertEqual(registers.carryFlag, true)
  }

  func test_get_af() {
    var registers = Registers()
    registers.a = 0x16
    registers.f = 0xc0
    XCTAssertEqual(registers.af, 0x16c0)
  }

  func test_set_af() {
    var registers = Registers()
    registers.af = 0x16c0
    XCTAssertEqual(registers.a, 0x16)
    XCTAssertEqual(registers.f, 0xc0)
  }

  func test_get_bc() {
    var registers = Registers()
    registers.b = 0x16
    registers.c = 0xc0
    XCTAssertEqual(registers.bc, 0x16c0)
  }

  func test_set_bc() {
    var registers = Registers()
    registers.bc = 0x16c0
    XCTAssertEqual(registers.b, 0x16)
    XCTAssertEqual(registers.c, 0xc0)
  }

  func test_get_de() {
    var registers = Registers()
    registers.d = 0x16
    registers.e = 0xc0
    XCTAssertEqual(registers.de, 0x16c0)
  }

  func test_set_de() {
    var registers = Registers()
    registers.de = 0x16c0
    XCTAssertEqual(registers.d, 0x16)
    XCTAssertEqual(registers.e, 0xc0)
  }

  func test_get_hl() {
    var registers = Registers()
    registers.h = 0x16
    registers.l = 0xc0
    XCTAssertEqual(registers.hl, 0x16c0)
  }

  func test_set_hl() {
    var registers = Registers()
    registers.hl = 0x16c0
    XCTAssertEqual(registers.h, 0x16)
    XCTAssertEqual(registers.l, 0xc0)
  }
}
