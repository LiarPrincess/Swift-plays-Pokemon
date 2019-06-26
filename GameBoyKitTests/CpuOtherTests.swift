// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length
// swiftlint:disable type_body_length

import XCTest
@testable import GameBoyKit

class CpuOtherTests: XCTestCase {

  /// When A = 45h and B = 38h,
  /// ADD A,B ; A←7Dh,N←0
  /// DAA     ; A←7Dh+06h(83h), CY←0
  /// SUB A,B ; A←83h–38h(4Bh), N←1
  /// DAA     ; A←4Bh+FAh(45h)
  func test_daa() {
    let bus = FakeCpuBus()
    let cpu = self.createCpu(bus: bus)
    cpu.registers.a = 0x45
    cpu.registers.b = 0x38

    cpu.add_a_r(.b)
    XCTAssertEqual(cpu.registers.a, 0x7d)
    XCTAssertEqual(cpu.registers.subtractFlag, false)

    cpu.daa() // CY: 0, H: 0
    XCTAssertEqual(cpu.registers.a, 0x83)
    XCTAssertEqual(cpu.registers.carryFlag,     false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false) // by me
    XCTAssertEqual(cpu.registers.zeroFlag,      false) // by me

    cpu.sub_a_r(.b)
    XCTAssertEqual(cpu.registers.a, 0x4b)
    XCTAssertEqual(cpu.registers.subtractFlag, true)

    cpu.daa() // CY: 0, H: 1
    XCTAssertEqual(cpu.registers.a, 0x45)
    XCTAssertEqual(cpu.registers.carryFlag,     false) // by me
    XCTAssertEqual(cpu.registers.halfCarryFlag, false) // by me
    XCTAssertEqual(cpu.registers.zeroFlag,      false) // by me
  }

  func test_nop() {
    let bus = FakeCpuBus()
    let cpu = self.createCpu(bus: bus)
    cpu.pc = 0xfefe
    cpu.nop()

    XCTAssertEqual(cpu.pc, 0xfeff)
  }

  /// When A = 35h,
  /// CPL ; A ← CAh
  func test_cpl() {
    let bus = FakeCpuBus()
    let cpu = self.createCpu(bus: bus)
    cpu.registers.a = 0x35
    cpu.cpl()

    XCTAssertEqual(cpu.registers.a, 0xca)
  }

  func test_scf() {
    let bus = FakeCpuBus()
    let cpu = self.createCpu(bus: bus)
    cpu.registers.carryFlag = false
    cpu.ccf()

    XCTAssertEqual(cpu.registers.carryFlag, true)
  }

  /// When CY = 1,
  /// CCF ; CY ← 0
  func test_ccf() {
    let bus = FakeCpuBus()
    let cpu = self.createCpu(bus: bus)
    cpu.registers.carryFlag = true
    cpu.ccf()

    XCTAssertEqual(cpu.registers.carryFlag, false)
  }
}
