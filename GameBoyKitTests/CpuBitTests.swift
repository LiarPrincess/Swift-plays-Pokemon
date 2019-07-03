// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import GameBoyKit

class CpuBitTests: XCTestCase {

  // MARK: - Bit

  /// When A = 80h and L = EFh
  /// BIT 7, A ; Z←0,H←1,N←0
  func test_bit_r_1() {
    let bus = FakeCpuBus()
    let cpu = self.createCpu(bus: bus)
    cpu.registers.a = 0x80
    cpu.registers.l = 0xef
    _ = cpu.bit_r(7, .a)

    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, true)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
  }

  /// When A = 80h and L = EFh
  /// BIT 4, L ; Z←1,H←1,N←0
  func test_bit_r_2() {
    let bus = FakeCpuBus()
    let cpu = self.createCpu(bus: bus)
    cpu.registers.a = 0x80
    cpu.registers.l = 0xef
    _ = cpu.bit_r(4, .l)

    XCTAssertEqual(cpu.registers.zeroFlag, true)
    XCTAssertEqual(cpu.registers.halfCarryFlag, true)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
  }

  /// When (HL) = FEh,
  /// BIT 0, (HL) ; Z←1,H←1,N←0
  func test_bit_pHL_1() {
    let bus = FakeCpuBus()
    let cpu = self.createCpu(bus: bus)
    cpu.registers.hl = 0xfefe
    bus.write(0xfefe, value: 0xfe)
    _ = cpu.bit_pHL(0)

    XCTAssertEqual(cpu.registers.zeroFlag, true)
    XCTAssertEqual(cpu.registers.halfCarryFlag, true)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
  }

  /// When (HL) = FEh,
  /// BIT 1, (HL) ; Z←0,H←1,N←0
  func test_bit_pHL_2() {
    let bus = FakeCpuBus()
    let cpu = self.createCpu(bus: bus)
    cpu.registers.hl = 0xfefe
    bus.write(0xfefe, value: 0xfe)
    _ = cpu.bit_pHL(1)

    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, true)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
  }

  // MARK: - Set

  /// When A = 80h and L = 3Bh,
  /// SET 3, A ; A←0x84
  func test_set_r_1() {
    let bus = FakeCpuBus()
    let cpu = self.createCpu(bus: bus)
    cpu.registers.a = 0x80
    cpu.registers.l = 0x3b
    _ = cpu.set_r(3, .a)

    // Error in documentation (or they count from 1):
    // Before: 1000 0000 (0x80)
    // After:  1000 1000 (0x88)

    XCTAssertEqual(cpu.registers.a, 0x88)
  }

  /// When A = 80h and L = 3Bh,
  /// SET 7, L ; L←0xBB
  func test_set_r_2() {
    let bus = FakeCpuBus()
    let cpu = self.createCpu(bus: bus)
    cpu.registers.a = 0x80
    cpu.registers.l = 0x3b
    _ = cpu.set_r(7, .l)

    XCTAssertEqual(cpu.registers.l, 0xbb)
  }

  /// When 00h is the memory contents specified by H and L,
  /// SET 3, (HL) ; (HL) ← 04H
  func test_set_pHL() {
    let bus = FakeCpuBus()
    let cpu = self.createCpu(bus: bus)
    cpu.registers.hl = 0xfefe
    bus.write(0xfefe, value: 0x00)
    _ = cpu.set_pHL(3)

    // Error in documentation (or they count from 1):
    // Before: 0000 0000 (0x00)
    // After:  0000 1000 (0x08)

    XCTAssertEqual(bus.read(0xfefe), 0x08)
  }

  // MARK: - Reset

  /// When A = 80h and L = 3Bh,
  /// RES 7,A;A←00h
  func test_res_r_1() {
    let bus = FakeCpuBus()
    let cpu = self.createCpu(bus: bus)
    cpu.registers.a = 0x80
    cpu.registers.l = 0x3b
    _ = cpu.res_r(7, .a)

    XCTAssertEqual(cpu.registers.a, 0x00)
  }

  /// When A = 80h and L = 3Bh,
  /// RES 1, L ; L ← 39h
  func test_res_r_2() {
    let bus = FakeCpuBus()
    let cpu = self.createCpu(bus: bus)
    cpu.registers.a = 0x80
    cpu.registers.l = 0x3b
    _ = cpu.res_r(1, .l)

    XCTAssertEqual(cpu.registers.l, 0x39)
  }

  /// When 0xFF is the memory contents specified by H and L,
  /// RES 3, (HL) ; (HL) ← F7h
  func test_res_pHL() {
    let bus = FakeCpuBus()
    let cpu = self.createCpu(bus: bus)
    cpu.registers.hl = 0xfefe
    bus.write(0xfefe, value: 0xff)
    _ = cpu.res_pHL(3)

    XCTAssertEqual(bus.read(0xfefe), 0xf7)
  }
}
