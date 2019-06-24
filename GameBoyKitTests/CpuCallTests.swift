// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length
// swiftlint:disable type_body_length

import XCTest
@testable import GameBoyKit

class CpuCallTests: XCTestCase {

  // MARK: - Call

  /// Examples: When PC = 8000h and SP = FFFEh,
  /// Jumps to address 1234h
  /// (FFFDH) ← 80H (FFFCH) ← 03H SP ← FFFCH
  func test_call_a16() {
    let bus = FakeCpuBus()
    let cpu = self.createCpu(bus: bus)
    cpu.pc = 0x8000
    cpu.sp = 0xfffe
    cpu.call_a16(0x1234)

    XCTAssertEqual(cpu.pc, 0x1234)
    XCTAssertEqual(cpu.sp, 0xfffc)
    XCTAssertEqual(bus.read(0xfffd), 0x80)
    XCTAssertEqual(bus.read(0xfffc), 0x03)
  }

  /// Examples: When Z = 1,
  /// CALL NZ, 1234h ; Moves to next instruction after 3 cycles.
  func test_call_cc_a16_nz() {
    let bus = FakeCpuBus()
    let cpu = self.createCpu(bus: bus)
    cpu.pc = 0x8000
    cpu.sp = 0xfffe
    cpu.registers.zeroFlag = true
    cpu.call_cc_a16(.nz, 0x1234)

    XCTAssertEqual(cpu.pc, 0x8000 + 0x3)
    XCTAssertEqual(cpu.sp, 0xfffe)
  }

  /// Examples: When Z = 1,
  /// CALL Z, 1234h ; Pushes 8003h to the stack, and jumps to 1234h.
  func test_call_cc_a16_z() {
    let bus = FakeCpuBus()
    let cpu = self.createCpu(bus: bus)
    cpu.pc = 0x8000
    cpu.sp = 0xfffe
    cpu.registers.zeroFlag = true
    cpu.call_cc_a16(.z, 0x1234)

    XCTAssertEqual(cpu.pc, 0x1234)
    XCTAssertEqual(cpu.sp, 0xfffc)
    XCTAssertEqual(bus.read(0xfffd), 0x80)
    XCTAssertEqual(bus.read(0xfffc), 0x03)
  }

  // MARK: - Ret

  /// 8000H    CALL 9000H 8003H
  /// 9000H
  /// RET ; Returns to address 0x8003
  func test_ret() {
    let bus = FakeCpuBus()
    let cpu = self.createCpu(bus: bus)
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
    let bus = FakeCpuBus()
    let cpu = self.createCpu(bus: bus)
    cpu.pc = 0x0040
    cpu.sp = 0xfffe
    cpu.push16(0x8000)
    cpu.reti()
    // TODO: Interrupt tests (reti)

    XCTAssertEqual(cpu.pc, 0x8001)
    XCTAssertEqual(cpu.sp, 0xfffe)
  }

  /// 8000h CALL 9000h
  /// 8003h
  /// Set Z
  /// 9000h RET Z ; Returns to address 8003h
  func test_ret_cc_z() {
    let bus = FakeCpuBus()
    let cpu = self.createCpu(bus: bus)
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
    let bus = FakeCpuBus()
    let cpu = self.createCpu(bus: bus)
    cpu.pc = 0x8000
    cpu.sp = 0xfffe
    cpu.call_a16(0x9000)
    cpu.registers.zeroFlag = true
    cpu.ret_cc(.nz)

    XCTAssertEqual(cpu.pc, 0x9000 + 0x1)
    XCTAssertEqual(cpu.sp, 0xfffc)
  }

  /// Address
  /// 8000h RST 1 ; Pushes 8001h to the stack,
  /// 8001h         and jumps to 0008h.
  func test_rst() {
    let bus = FakeCpuBus()
    let cpu = self.createCpu(bus: bus)
    cpu.pc = 0x8000
    cpu.sp = 0xfffe
    cpu.rst(0x01)

    XCTAssertEqual(cpu.pc, 0x0001)
    XCTAssertEqual(cpu.sp, 0xfffc)
    XCTAssertEqual(bus.read(0xfffd), 0x80)
    XCTAssertEqual(bus.read(0xfffc), 0x01)
  }
}
