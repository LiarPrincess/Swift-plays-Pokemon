// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length
// swiftlint:disable type_body_length

import XCTest
@testable import SwiftBoyKit

class CpuShiftTests: XCTestCase {

  // MARK: - Shift

  /// When D = 80h, (HL) = FFh, and CY = 0,
  /// SLA D ; D←00h,CY←1,Z←1,H←0,N←0
  func test_sla_r() {
    let bus = FakeCpuBus()
    let cpu = Cpu(bus: bus)
    cpu.registers.d = 0x80
    cpu.registers.hl = 0xfefe
    bus.write(0xfefe, value: 0xff)
    cpu.registers.carryFlag = false
    cpu.sla_r(.d)

    XCTAssertEqual(cpu.registers.d, 0x00)
    XCTAssertEqual(cpu.registers.zeroFlag, true)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, true)
  }

  /// When D = 80h, (HL) = FFh, and CY = 0,
  /// SLA (HL) ; (HL)←FEh,CY←1,Z←0,H←0,N←0
  func test_sla_pHL() {
    let bus = FakeCpuBus()
    let cpu = Cpu(bus: bus)
    cpu.registers.d = 0x80
    cpu.registers.hl = 0xfefe
    bus.write(0xfefe, value: 0xff)
    cpu.registers.carryFlag = false
    cpu.sla_pHL()

    XCTAssertEqual(bus.read(0xfefe), 0xfe)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, true)
  }

  /// When A = 8Ah, (HL) = 01h, and CY = 0,
  /// SRA D ; A←C5h,CY←0,Z←0,H←0,N←0
  func test_sra_r() {
    let bus = FakeCpuBus()
    let cpu = Cpu(bus: bus)
    cpu.registers.a = 0x8a
    cpu.registers.hl = 0xfefe
    bus.write(0xfefe, value: 0x01)
    cpu.registers.carryFlag = false
    cpu.sra_r(.a)
    // documentation does not make sense here, it should be 'SRA A'

    XCTAssertEqual(cpu.registers.a, 0xc5)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, false)
  }

  /// When A = 8Ah, (HL) = 01h, and CY = 0,
  /// SRA (HL) ; (HL)←00h,CY←1,Z←1,H←0,N←0
  func test_sra_pHL() {
    let bus = FakeCpuBus()
    let cpu = Cpu(bus: bus)
    cpu.registers.a = 0x8a
    cpu.registers.hl = 0xfefe
    bus.write(0xfefe, value: 0x01)
    cpu.registers.carryFlag = false
    cpu.sra_pHL()

    XCTAssertEqual(bus.read(0xfefe), 0x00)
    XCTAssertEqual(cpu.registers.zeroFlag, true)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, true)
  }

  /// When A = 01h, (HL) = FFh, CY + 0,
  /// SRL A ; A←00h,CY←1,Z←1,H←0,N←0
  func test_srl_r() {
    let bus = FakeCpuBus()
    let cpu = Cpu(bus: bus)
    cpu.registers.a = 0x01
    cpu.registers.hl = 0xfefe
    bus.write(0xfefe, value: 0xff)
    cpu.registers.carryFlag = false
    cpu.srl_r(.a)

    XCTAssertEqual(cpu.registers.a, 0x00)
    XCTAssertEqual(cpu.registers.zeroFlag, true)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, true)
  }

  /// When A = 01h, (HL) = FFh, CY + 0,
  /// SRL (HL) ; (HL)←7Fh,CY←1,Z←0,H←0,N←0
  func test_srl_pHL() {
    let bus = FakeCpuBus()
    let cpu = Cpu(bus: bus)
    cpu.registers.a = 0x01
    cpu.registers.hl = 0xfefe
    bus.write(0xfefe, value: 0xff)
    cpu.registers.carryFlag = false
    cpu.srl_pHL()

    XCTAssertEqual(bus.read(0xfefe), 0x7f)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, true)
  }

  // MARK: - Swap

  /// When A = 00h and (HL) = F0h,
  /// SWAP A ; A←00h,Z←1,H←0,N←0,CY←0
  func test_swap_r() {
    let bus = FakeCpuBus()
    let cpu = Cpu(bus: bus)
    cpu.registers.a = 0x00
    cpu.registers.hl = 0xfefe
    bus.write(0xfefe, value: 0xf0)
    cpu.swap_r(.a)

    XCTAssertEqual(cpu.registers.a, 0x00)
    XCTAssertEqual(cpu.registers.zeroFlag, true)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, false)
  }

  /// When A = 00h and (HL) = F0h,
  /// SWAP(HL) ; (HL)←0Fh,Z←0,H←0,N←0,CY←0
  func test_swap_pHL() {
    let bus = FakeCpuBus()
    let cpu = Cpu(bus: bus)
    cpu.registers.a = 0x00
    cpu.registers.hl = 0xfefe
    bus.write(0xfefe, value: 0xf0)
    cpu.swap_pHL()

    XCTAssertEqual(bus.read(0xfefe), 0x0f)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, false)
  }
}
