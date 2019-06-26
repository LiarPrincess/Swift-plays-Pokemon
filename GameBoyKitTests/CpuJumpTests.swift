// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length
// swiftlint:disable type_body_length

import XCTest
@testable import GameBoyKit

class CpuJumpTests: XCTestCase {

  // MARK: - JP

  /// JP 8000h ; Jump to 8000h.
  func test_jp_nn() {
    let bus = FakeCpuBus()
    let cpu = self.createCpu(bus: bus)
    cpu.jp_nn(0x8000)

    XCTAssertEqual(cpu.pc, 0x8000)
  }

  /// When Z=1andC=0,
  /// JP NZ, 8000h ; Moves to next instruction after 3 cycles.
  func test_jp_cc_nn_nz() {
    let bus = FakeCpuBus()
    let cpu = self.createCpu(bus: bus)
    cpu.registers.zeroFlag = true
    cpu.registers.carryFlag = false
    cpu.pc = 0xfefe
    cpu.jp_cc_nn(.nz, 0x8000)

    XCTAssertEqual(cpu.pc, 0xfefe + 0x3)
  }

  /// When Z=1andC=0,
  /// JP Z, 8000h ; Jumps to address 8000h.
  func test_jp_cc_nn_z() {
    let bus = FakeCpuBus()
    let cpu = self.createCpu(bus: bus)
    cpu.registers.zeroFlag = true
    cpu.registers.carryFlag = false
    cpu.pc = 0xfefe
    cpu.jp_cc_nn(.z, 0x8000)

    XCTAssertEqual(cpu.pc, 0x8000)
  }

  /// When Z=1andC=0,
  /// JP C, 8000h ; Moves to next instruction after 3 cycles.
  func test_jp_cc_nn_c() {
    let bus = FakeCpuBus()
    let cpu = self.createCpu(bus: bus)
    cpu.registers.zeroFlag = true
    cpu.registers.carryFlag = false
    cpu.pc = 0xfefe
    cpu.jp_cc_nn(.c, 0x8000)

    XCTAssertEqual(cpu.pc, 0xfefe + 0x3)
  }

  /// When Z=1andC=0,
  /// JP NC, 8000h ; Jumps to address 8000h.
  func test_jp_cc_nn_nc() {
    let bus = FakeCpuBus()
    let cpu = self.createCpu(bus: bus)
    cpu.registers.zeroFlag = true
    cpu.registers.carryFlag = false
    cpu.pc = 0xfefe
    cpu.jp_cc_nn(.nc, 0x8000)

    XCTAssertEqual(cpu.pc, 0x8000)
  }

  /// When HL = 8000h,
  /// JP (HL) ; Jumps to 8000h.
  func test_jp_pHL() {
    let bus = FakeCpuBus()
    let cpu = self.createCpu(bus: bus)
    cpu.registers.hl = 0x8000
    cpu.jp_pHL()

    XCTAssertEqual(cpu.pc, 0x8000)
  }

  // MARK: - JR

  /// Test taken from bootstrap (0x000a)
  func test_jr_cc_1() {
    let bus = FakeCpuBus()
    let cpu = self.createCpu(bus: bus)
    cpu.pc = 0x000a
    cpu.registers.zeroFlag = false
    cpu.jr_cc_e(.nz, 0xfb) // -2

    XCTAssertEqual(cpu.pc, 0x0007)
  }

  /// Test taken from bootstrap (0x004b)
  func test_jr_cc_2() {
    let bus = FakeCpuBus()
    let cpu = self.createCpu(bus: bus)
    cpu.pc = 0x004b
    cpu.registers.zeroFlag = true
    cpu.jr_cc_e(.z, 0x8) // -2

    XCTAssertEqual(cpu.pc, 0x0055)
  }
}