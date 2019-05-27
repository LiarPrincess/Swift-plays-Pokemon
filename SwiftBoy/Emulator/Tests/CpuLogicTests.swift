// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

import XCTest
@testable import SwiftBoy

class CpuLogicTests: XCTestCase {

  // MARK: - And

  /// When A = 5Ah, L = 3Fh and (HL) = 0h,
  /// AND L ; A←1Ah,Z←0,H←1,N←0 CY←0
  func test_and_a_r() {
    var cpu = Cpu()
    cpu.registers.a = 0x5a
    cpu.registers.e = 0x3f // we are using .e instead of .l
    cpu.registers.hl = 0xfefe
    cpu.memory.write(0xfefe, value: 0x00)
    cpu.and_a_r(.e)

    XCTAssertEqual(cpu.registers.a, 0x1a)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, true)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, false)
  }

  /// When A = 5Ah, L = 3Fh and (HL) = 0h,
  /// AND 38h ; A←18h,Z←0,H←1,N←0 CY←0
  func test_and_a_d8() {
    var cpu = Cpu()
    cpu.registers.a = 0x5a
    cpu.registers.e = 0x3f // we are using .e instead of .l
    cpu.registers.hl = 0xfefe
    cpu.memory.write(0xfefe, value: 0x00)
    cpu.and_a_d8(0x38)

    XCTAssertEqual(cpu.registers.a, 0x18)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, true)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, false)
  }

  /// When A = 5Ah, L = 3Fh and (HL) = 0h,
  /// AND (HL) ; A←00h,Z←1,H←1,N←0 CY←0
  func test_and_a_pHL() {
    var cpu = Cpu()
    cpu.registers.a = 0x5a
    cpu.registers.e = 0x3f // we are using .e instead of .l
    cpu.registers.hl = 0xfefe
    cpu.memory.write(0xfefe, value: 0x00)
    cpu.and_a_pHL()

    XCTAssertEqual(cpu.registers.a, 0x00)
    XCTAssertEqual(cpu.registers.zeroFlag, true)
    XCTAssertEqual(cpu.registers.halfCarryFlag, true)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, false)
  }

  // MARK: - Or

  /// When A = 5Ah, (HL) = 0Fh,
  /// OR A ; A←5Ah,Z←0
  func test_or_a_r() {
    var cpu = Cpu()
    cpu.registers.a = 0x5a
    cpu.registers.hl = 0xfefe
    cpu.memory.write(0xfefe, value: 0x0f)
    cpu.or_a_r(.a)

    XCTAssertEqual(cpu.registers.a, 0x5a)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, false)
  }

  /// When A = 5Ah, (HL) = 0Fh,
  /// OR 3 ; A←5Bh,Z←0
  func test_or_a_d8() {
    var cpu = Cpu()
    cpu.registers.a = 0x5a
    cpu.registers.hl = 0xfefe
    cpu.memory.write(0xfefe, value: 0x0f)
    cpu.or_a_d8(0x03)

    XCTAssertEqual(cpu.registers.a, 0x5b)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, false)
  }

  /// When A = 5Ah, (HL) = 0Fh,
  /// OR (HL); A←5Fh,Z←0
  func test_or_a_pHL() {
    var cpu = Cpu()
    cpu.registers.a = 0x5a
    cpu.registers.hl = 0xfefe
    cpu.memory.write(0xfefe, value: 0x0f)
    cpu.or_a_pHL()

    XCTAssertEqual(cpu.registers.a, 0x5f)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, false)
  }

  // MARK: - Xor

  /// When A = FFh and (HL) = 8Ah,
  /// XOR A ; A←00h,Z←1
  func test_xor_a_r() {
    var cpu = Cpu()
    cpu.registers.a = 0xff
    cpu.registers.hl = 0xfefe
    cpu.memory.write(0xfefe, value: 0x8a)
    cpu.xor_a_r(.a)

    XCTAssertEqual(cpu.registers.a, 0x00)
    XCTAssertEqual(cpu.registers.zeroFlag, true)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, false)
  }

  /// When A = FFh and (HL) = 8Ah,
  /// XOR 0x0F ; A←F0h,Z←0
  func test_xor_a_d8() {
    var cpu = Cpu()
    cpu.registers.a = 0xff
    cpu.registers.hl = 0xfefe
    cpu.memory.write(0xfefe, value: 0x8a)
    cpu.xor_a_d8(0x0f)

    XCTAssertEqual(cpu.registers.a, 0xf0)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, false)
  }

  /// When A = FFh and (HL) = 8Ah,
  /// XOR (HL) ; A←75h,Z←0
  func test_xor_a_pHL() {
    var cpu = Cpu()
    cpu.registers.a = 0xff
    cpu.registers.hl = 0xfefe
    cpu.memory.write(0xfefe, value: 0x8a)
    cpu.xor_a_pHL()

    XCTAssertEqual(cpu.registers.a, 0x75)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, false)
  }
}
