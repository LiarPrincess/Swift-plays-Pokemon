// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

import XCTest
@testable import SwiftBoyKit

class CpuJumpTests: XCTestCase {

  // MARK: - JP

  /// JP 8000h ; Jump to 8000h.
  func test_jp_nn() {
    let cpu = Cpu()
    cpu.jp_nn(0x8000)

    XCTAssertEqual(cpu.pc, 0x8000)
  }

  /// When Z=1andC=0,
  /// JP NZ, 8000h ; Moves to next instruction after 3 cycles.
  func test_jp_cc_nn_nz() {
    let cpu = Cpu()
    cpu.registers.zeroFlag = true
    cpu.registers.carryFlag = false
    cpu.pc = 0xfefe
    cpu.jp_cc_nn(.nz, 0x8000)

    XCTAssertEqual(cpu.pc, 0xfefe)
  }

  /// When Z=1andC=0,
  /// JP Z, 8000h ; Jumps to address 8000h.
  func test_jp_cc_nn_z() {
    let cpu = Cpu()
    cpu.registers.zeroFlag = true
    cpu.registers.carryFlag = false
    cpu.pc = 0xfefe
    cpu.jp_cc_nn(.z, 0x8000)

    XCTAssertEqual(cpu.pc, 0x8000)
  }

  /// When Z=1andC=0,
  /// JP C, 8000h ; Moves to next instruction after 3 cycles.
  func test_jp_cc_nn_c() {
    let cpu = Cpu()
    cpu.registers.zeroFlag = true
    cpu.registers.carryFlag = false
    cpu.pc = 0xfefe
    cpu.jp_cc_nn(.c, 0x8000)

    XCTAssertEqual(cpu.pc, 0xfefe)
  }

  /// When Z=1andC=0,
  /// JP NC, 8000h ; Jumps to address 8000h.
  func test_jp_cc_nn_nc() {
    let cpu = Cpu()
    cpu.registers.zeroFlag = true
    cpu.registers.carryFlag = false
    cpu.pc = 0xfefe
    cpu.jp_cc_nn(.nc, 0x8000)

    XCTAssertEqual(cpu.pc, 0x8000)
  }

  /// When HL = 8000h,
  /// JP (HL) ; Jumps to 8000h.
  func test_jp_pHL() {
    let cpu = Cpu()
    cpu.registers.hl = 0x8000
    cpu.jp_pHL()

    XCTAssertEqual(cpu.pc, 0x8000)
  }

  // MARK: - JR

  /// Test taken from bootstrap
  func test_jr_e() {
    let cpu = Cpu()
    cpu.pc = 10
    cpu.jr_e(0xfb) // -2

    XCTAssertEqual(cpu.pc, 0x0007)
  }
}
