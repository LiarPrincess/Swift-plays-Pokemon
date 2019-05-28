// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

import XCTest
@testable import SwiftBoy

class CpuCallTests: XCTestCase {

  // MARK: - Call

  /// Examples: When PC = 8000h and SP = FFFEh,
  /// Jumps to address 1234h
  /// (FFFDH) ← 80H (FFFCH) ← 03H SP ← FFFCH
  func test_call_a16() {
    var cpu = Cpu()
    cpu.pc = 0x8000
    cpu.sp = 0xfffe
    cpu.call_a16(0x1234)

    XCTAssertEqual(cpu.pc, 0x1234)
    XCTAssertEqual(cpu.sp, 0xfffc)
    XCTAssertEqual(cpu.memory.read(0xfffd), 0x80)
    XCTAssertEqual(cpu.memory.read(0xfffc), 0x03)
  }

  /// Examples: When Z = 1,
  /// CALL NZ, 1234h ; Moves to next instruction after 3 cycles.
  func test_call_cc_a16_nz() {
    var cpu = Cpu()
    cpu.pc = 0x8000
    cpu.sp = 0xfffe
    cpu.registers.zeroFlag = true
    cpu.call_cc_a16(.nz, 0x1234)

    XCTAssertEqual(cpu.pc, 0x8000) // moves AFTER instruction, not now
    XCTAssertEqual(cpu.sp, 0xfffe)
  }

  /// Examples: When Z = 1,
  /// CALL Z, 1234h ; Pushes 8003h to the stack, and jumps to 1234h.
  func test_call_cc_a16_z() {
    var cpu = Cpu()
    cpu.pc = 0x8000
    cpu.sp = 0xfffe
    cpu.registers.zeroFlag = true
    cpu.call_cc_a16(.z, 0x1234)

    XCTAssertEqual(cpu.pc, 0x1234)
    XCTAssertEqual(cpu.sp, 0xfffc)
    XCTAssertEqual(cpu.memory.read(0xfffd), 0x80)
    XCTAssertEqual(cpu.memory.read(0xfffc), 0x03)
  }

  // MARK: - Ret

  /// 8000H    CALL 9000H 8003H
  /// 9000H
  /// RET ; Returns to address 0x8003
  func test_ret() {
    var cpu = Cpu()
    cpu.pc = 0x8000
    cpu.sp = 0xfffe
    cpu.call_a16(0x9000)
    cpu.ret()

    XCTAssertEqual(cpu.pc, 0x8003)
    XCTAssertEqual(cpu.sp, 0xfffe)
  }

  /// 0040h
  /// RETI ; Pops the stack and returns to address 8001h.
  /// 8000H INC L :An external interrupt occurs here.
  /// 8001H
  func test_reti() {
    var cpu = Cpu()
    cpu.pc = 0x0040
    cpu.sp = 0xfffe
    cpu.push16(0x8000)
    cpu.reti()
    // TODO: Interrupt tests (reti)

    XCTAssertEqual(cpu.pc, 0x8000)
    XCTAssertEqual(cpu.sp, 0xfffe)
  }

  /// 8000h CALL 9000h
  /// 8003h
  /// Set Z
  /// 9000h RET Z ; Returns to address 8003h
  func test_ret_cc_z() {
    var cpu = Cpu()
    cpu.pc = 0x8000
    cpu.sp = 0xfffe
    cpu.call_a16(0x9000)
    cpu.registers.zeroFlag = true
    cpu.ret_cc(.z)

    XCTAssertEqual(cpu.pc, 0x8003)
    XCTAssertEqual(cpu.sp, 0xfffe)
  }

  /// 8000h CALL 9000h
  /// 8003h
  /// Clear Z
  /// 9000h RET Z ; Moves to next instruction after 2 cycles
  func test_ret_cc_nz() {
    var cpu = Cpu()
    cpu.pc = 0x8000
    cpu.sp = 0xfffe
    cpu.call_a16(0x9000)
    cpu.registers.zeroFlag = true
    cpu.ret_cc(.nz)

    XCTAssertEqual(cpu.pc, 0x9000)
    XCTAssertEqual(cpu.sp, 0xfffc)
  }

  /// Address
  /// 8000h RST 1 ; Pushes 8001h to the stack,
  /// 8001h         and jumps to 0008h.
  func test_rst() {
    var cpu = Cpu()
    cpu.pc = 0x8000
    cpu.sp = 0xfffe
    cpu.rst(0x08)

    XCTAssertEqual(cpu.pc, 0x0008)
    XCTAssertEqual(cpu.sp, 0xfffc)
    XCTAssertEqual(cpu.memory.read(0xfffd), 0x80)
    XCTAssertEqual(cpu.memory.read(0xfffc), 0x01)
  }
}
