// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length
// swiftlint:disable type_body_length

import XCTest
@testable import SwiftBoyKit

class CpuOtherTests: XCTestCase {

  func test_nop() {
    let cpu = Cpu()
    cpu.pc = 0xfefe
    cpu.nop()

    XCTAssertEqual(cpu.pc, 0xfeff)
  }

  /// When A = 35h,
  /// CPL ; A ← CAh
  func test_cpl() {
    let cpu = Cpu()
    cpu.registers.a = 0x35
    cpu.cpl()

    XCTAssertEqual(cpu.registers.a, 0xca)
  }

  func test_scf() {
    let cpu = Cpu()
    cpu.registers.carryFlag = false
    cpu.ccf()

    XCTAssertEqual(cpu.registers.carryFlag, true)
  }

  /// When CY = 1,
  /// CCF ; CY ← 0
  func test_ccf() {
    let cpu = Cpu()
    cpu.registers.carryFlag = true
    cpu.ccf()

    XCTAssertEqual(cpu.registers.carryFlag, false)
  }
}
