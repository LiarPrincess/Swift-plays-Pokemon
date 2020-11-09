// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import GameBoyKit

class CpuOtherInstructionsTests: CpuTestCase {

  /// When A = 45h and B = 38h,
  /// ADD A,B ; A←7Dh,N←0
  /// DAA     ; A←7Dh+06h(83h), CY←0
  /// SUB A,B ; A←83h–38h(4Bh), N←1
  /// DAA     ; A←4Bh+FAh(45h)
  func test_daa() {
    let memory = self.createFakeMemory()
    let cpu = self.createCpu(memory: memory)
    cpu.registers.a = 0x45
    cpu.registers.b = 0x38

    _ = cpu.add_a_r(.b)
    XCTAssertEqual(cpu.registers.a, 0x7d)
    XCTAssertEqual(cpu.registers.subtractFlag, false)

    _ = cpu.daa() // CY: 0, H: 0
    XCTAssertEqual(cpu.registers.a, 0x83)
    XCTAssertEqual(cpu.registers.carryFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false) // added by me
    XCTAssertEqual(cpu.registers.zeroFlag, false) // added by me

    _ = cpu.sub_a_r(.b)
    XCTAssertEqual(cpu.registers.a, 0x4b)
    XCTAssertEqual(cpu.registers.subtractFlag, true)

    _ = cpu.daa() // CY: 0, H: 1
    XCTAssertEqual(cpu.registers.a, 0x45)
    XCTAssertEqual(cpu.registers.carryFlag, false) // added by me
    XCTAssertEqual(cpu.registers.halfCarryFlag, false) // added by me
    XCTAssertEqual(cpu.registers.zeroFlag, false) // added by me
  }

  func test_nop() {
    let memory = self.createFakeMemory()
    let cpu = self.createCpu(memory: memory)
    cpu.pc = 0xfefe
    _ = cpu.nop()

    XCTAssertEqual(cpu.pc, 0xfeff)
  }

  /// When A = 35h,
  /// CPL ; A ← CAh
  func test_cpl() {
    let memory = self.createFakeMemory()
    let cpu = self.createCpu(memory: memory)
    cpu.registers.a = 0x35
    _ = cpu.cpl()

    XCTAssertEqual(cpu.registers.a, 0xca)
  }

  func test_scf() {
    let memory = self.createFakeMemory()
    let cpu = self.createCpu(memory: memory)
    cpu.registers.carryFlag = false
    _ = cpu.ccf()

    XCTAssertEqual(cpu.registers.carryFlag, true)
  }

  /// When CY = 1,
  /// CCF ; CY ← 0
  func test_ccf() {
    let memory = self.createFakeMemory()
    let cpu = self.createCpu(memory: memory)
    cpu.registers.carryFlag = true
    _ = cpu.ccf()

    XCTAssertEqual(cpu.registers.carryFlag, false)
  }
}
