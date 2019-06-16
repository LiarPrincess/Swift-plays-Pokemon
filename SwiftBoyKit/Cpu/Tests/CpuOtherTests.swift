// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length
// swiftlint:disable type_body_length

import XCTest
@testable import SwiftBoyKit

class CpuOtherTests: XCTestCase {

  func test_nop() {
    let bus = FakeCpuBus()
    let cpu = Cpu(bus: bus)
    cpu.pc = 0xfefe
    cpu.nop()

    XCTAssertEqual(cpu.pc, 0xfeff)
  }

  /// When A = 35h,
  /// CPL ; A ← CAh
  func test_cpl() {
    let bus = FakeCpuBus()
    let cpu = Cpu(bus: bus)
    cpu.registers.a = 0x35
    cpu.cpl()

    XCTAssertEqual(cpu.registers.a, 0xca)
  }

  func test_scf() {
    let bus = FakeCpuBus()
    let cpu = Cpu(bus: bus)
    cpu.registers.carryFlag = false
    cpu.ccf()

    XCTAssertEqual(cpu.registers.carryFlag, true)
  }

  /// When CY = 1,
  /// CCF ; CY ← 0
  func test_ccf() {
    let bus = FakeCpuBus()
    let cpu = Cpu(bus: bus)
    cpu.registers.carryFlag = true
    cpu.ccf()

    XCTAssertEqual(cpu.registers.carryFlag, false)
  }
}
