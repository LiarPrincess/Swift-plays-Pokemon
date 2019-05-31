// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length
// swiftlint:disable type_body_length

import XCTest
@testable import SwiftBoyKit

class CpuRotateTests: XCTestCase {

  // MARK: - Rotate left

  /// When A = 85h and CY = 0,
  /// RLCA ; A←0Ah,CY←1,Z←0,H←0,N←0
  func disabled_test_rlca() {
    let cpu = Cpu()
    cpu.registers.a = 0x85
    cpu.registers.carryFlag = false
    cpu.rlca()

    XCTAssertEqual(cpu.registers.a, 0x0a)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, true)
  }

  /// When A = 95h and CY = 1,
  /// RLA ; A ←2Bh,C←1,Z←0,H←0,N←0
  func test_rla() {
    let cpu = Cpu()
    cpu.registers.a = 0x95
    cpu.registers.carryFlag = true
    cpu.rla()

    XCTAssertEqual(cpu.registers.a, 0x2b)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, true)
  }

  // MARK: - Rotate right

  /// When A = 3Bh and CY = 0,
  /// RRCA ; A←9Dh,CY←1,Z←0,H←0,N←0
  func test_rrca() {
    let cpu = Cpu()
    cpu.registers.a = 0x3b
    cpu.registers.carryFlag = false
    cpu.rrca()

    XCTAssertEqual(cpu.registers.a, 0x9d)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, true)
  }

  /// When A = 81h and CY = 0,
  /// RRA ; A←40h,CY←1,Z←0,H←0,N←0
  func test_rra() {
    let cpu = Cpu()
    cpu.registers.a = 0x81
    cpu.registers.carryFlag = false
    cpu.rra()

    XCTAssertEqual(cpu.registers.a, 0x40)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, true)
  }

  // MARK: - Prefix rotate left

  /// When B = 85h, (HL) = 0, and CY = 0,
  /// RLC B ; B←0Bh,CY←1,Z←0,H←0,N←0
  func test_rlc_r() {
    let cpu = Cpu()
    cpu.registers.b = 0x85
    cpu.registers.hl = 0xfefe
    cpu.memory.write(0xfefe, value: 0)
    cpu.registers.carryFlag = false
    cpu.rlc_r(.b)

    XCTAssertEqual(cpu.registers.b, 0x0b)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, true)
  }

  /// When B = 85h, (HL) = 0, and CY = 0,
  /// RLC (HL) ; (HL)←00h,CY←0,Z←1,H←0,N←0
  func test_rlc_pHL() {
    let cpu = Cpu()
    cpu.registers.b = 0x85
    cpu.registers.hl = 0xfefe
    cpu.memory.write(0xfefe, value: 0)
    cpu.registers.carryFlag = false
    cpu.rlc_pHL()

    XCTAssertEqual(cpu.memory.read(0xfefe), 0x00)
    XCTAssertEqual(cpu.registers.zeroFlag, true)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, false)
  }

  /// When L = 80h, (HL) = 11h, and CY = 0,
  /// RL L ; L←00h,CY←1,Z←1,H←0,N←0
  func test_rl_r() {
    let cpu = Cpu()
    cpu.registers.b = 0x80 // we use 'b' instead of 'l'
    cpu.registers.hl = 0xfefe
    cpu.memory.write(0xfefe, value: 0x11)
    cpu.registers.carryFlag = false
    cpu.rl_r(.b)

    XCTAssertEqual(cpu.registers.b, 0x00)
    XCTAssertEqual(cpu.registers.zeroFlag, true)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, true)
  }

  /// When L = 80h, (HL) = 11h, and CY = 0,
  /// RL (HL) ; (HL)←22h,CY←0,Z←0,H←0,N←0
  func test_rl_pHL() {
    let cpu = Cpu()
    cpu.registers.b = 0x80 // we use 'b' instead of 'l'
    cpu.registers.hl = 0xfefe
    cpu.memory.write(0xfefe, value: 0x11)
    cpu.registers.carryFlag = false
    cpu.rl_pHL()

    XCTAssertEqual(cpu.memory.read(0xfefe), 0x22)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, false)
  }

  // MARK: - Prefix rotate right

  /// When C = 1h, (HL) = 0h, CY = 0,
  /// RRC C ; C←80h,CY←1,Z←0,H←0,N←0
  func test_rrc_r() {
    let cpu = Cpu()
    cpu.registers.c = 0x01
    cpu.registers.hl = 0xfefe
    cpu.memory.write(0xfefe, value: 0)
    cpu.registers.carryFlag = false
    cpu.rrc_r(.c)

    XCTAssertEqual(cpu.registers.c, 0x80)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, true)
  }

  /// When C = 1h, (HL) = 0h, CY = 0,
  /// RRC (HL) ; (HL)←00h,CY←0,Z←1,H←0,N←0
  func test_rrc_pHL() {
    let cpu = Cpu()
    cpu.registers.c = 0x01
    cpu.registers.hl = 0xfefe
    cpu.memory.write(0xfefe, value: 0)
    cpu.registers.carryFlag = false
    cpu.rrc_pHL()

    XCTAssertEqual(cpu.memory.read(0xfefe), 0x00)
    XCTAssertEqual(cpu.registers.zeroFlag, true)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, false)
  }

  /// When A = 1h, (HL) = 8Ah, CY = 0,
  /// RR A ; A←00h,CY←1,Z←1,H←0,N←0
  func test_rr_r() {
    let cpu = Cpu()
    cpu.registers.a = 0x01
    cpu.registers.hl = 0xfefe
    cpu.memory.write(0xfefe, value: 0x8a)
    cpu.registers.carryFlag = false
    cpu.rr_r(.a)

    XCTAssertEqual(cpu.registers.a, 0x00)
    XCTAssertEqual(cpu.registers.zeroFlag, true)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, true)
  }

  /// When A = 1h, (HL) = 8Ah, CY = 0,
  /// RR (HL) ; (HL)←45h,CY←0,Z←0,H←0,N←0
  func test_rr_pHL() {
    let cpu = Cpu()
    cpu.registers.a = 0x01
    cpu.registers.hl = 0xfefe
    cpu.memory.write(0xfefe, value: 0x8a)
    cpu.registers.carryFlag = false
    cpu.rr_pHL()

    XCTAssertEqual(cpu.memory.read(0xfefe), 0x45)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, false)
  }
}
