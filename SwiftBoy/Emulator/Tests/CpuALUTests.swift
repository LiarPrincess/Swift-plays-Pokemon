// swiftlint:disable file_length

import XCTest
@testable import SwiftBoy

// 8-Bit Arithmetic and Logical Operation Instructions
// https://ia801906.us.archive.org/19/items/GameBoyProgManVer1.1/GameBoyProgManVer1.1.pdf
class CpuTests: XCTestCase {

  // MARK: - Add

  /// When A = 0x3A and B = 0xC6,
  /// ADD A, B ; A←0,Z←1,H←1,N←0,CY←1
  func test_add_r() {
    var cpu = Cpu()
    cpu.registers.a = 0x3a
    cpu.registers.b = 0xc6
    cpu.add_r(.b)

    XCTAssertEqual(cpu.registers.a, 0)
    XCTAssertEqual(cpu.registers.zeroFlag, true)
    XCTAssertEqual(cpu.registers.halfCarryFlag, true)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, true)
  }

  /// When A = 3Ch,
  /// ADDA.FFh ; A←3Bh,Z←0,H←1,N←0,CY←1
  func test_add_d8() {
    var cpu = Cpu()
    cpu.registers.a = 0x3c
    cpu.add_d8(0xff)

    XCTAssertEqual(cpu.registers.a, 0x3b)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, true)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, true)
  }

  /// When A = 3Ch and (HL) = 12h,
  /// ADD A, (HL) ; A←4Eh,Z←0,H←0,N←0,CY←0
  func test_add_pHL() {
    var cpu = Cpu()
    cpu.registers.a = 0x3c
    cpu.registers.hl = 0xfefe
    cpu.memory.write(0xfefe, value: 0x12)
    cpu.add_pHL()

    XCTAssertEqual(cpu.registers.a, 0x4e)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, false)
  }

  // MARK: - Adc

  /// WhenA=E1h,E=0Fh,(HL)=1Eh,andCY=1,
  /// ADC A, E ; A←F1h,Z←0,H←1,CY←0
  func test_adc_r() {
    var cpu = Cpu()
    cpu.registers.a = 0xe1
    cpu.registers.e = 0x0f
    cpu.registers.hl = 0xfefe
    cpu.memory.write(0xfefe, value: 0x1e)
    cpu.registers.carryFlag = true
    cpu.adc_r(.e)

    XCTAssertEqual(cpu.registers.a, 0xf1)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, true)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, false)
  }

  /// WhenA=E1h,E=0Fh,(HL)=1Eh,andCY=1,
  /// ADC A, 3Bh ; A←1Dh,Z←0,H←0,CY←-1
  func test_adc_d8() {
    var cpu = Cpu()
    cpu.registers.a = 0xe1
    cpu.registers.e = 0x0f
    cpu.registers.hl = 0xfefe
    cpu.memory.write(0xfefe, value: 0x1e)
    cpu.registers.carryFlag = true
    cpu.adc_d8(0x3b)

    XCTAssertEqual(cpu.registers.a, 0x1d)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, true)
  }

  /// WhenA=E1h,E=0Fh,(HL)=1Eh,andCY=1,
  /// ADC A, (HL) ; A←00h,Z←1,H←1,CY←1
  func test_adc_pHL() {
    var cpu = Cpu()
    cpu.registers.a = 0xe1
    cpu.registers.e = 0x0f
    cpu.registers.hl = 0xfefe
    cpu.memory.write(0xfefe, value: 0x1e)
    cpu.registers.carryFlag = true
    cpu.adc_pHL()

    XCTAssertEqual(cpu.registers.a, 0x00)
    XCTAssertEqual(cpu.registers.zeroFlag, true)
    XCTAssertEqual(cpu.registers.halfCarryFlag, true)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, true)
  }

  // MARK: - Sub

  /// When A = 3Eh, E = 3Eh, and (HL) = 40h,
  /// SUB E ; A←00h,Z←1,H←0,N←1 CY←0
  func test_sub_r() {
    var cpu = Cpu()
    cpu.registers.a = 0x3e
    cpu.registers.e = 0x3e
    cpu.registers.hl = 0xfefe
    cpu.memory.write(0xfefe, value: 0x40)
    cpu.sub_r(.e)

    XCTAssertEqual(cpu.registers.a, 0x00)
    XCTAssertEqual(cpu.registers.zeroFlag, true)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, true)
    XCTAssertEqual(cpu.registers.carryFlag, false)
  }

  /// When A = 3Eh, E = 3Eh, and (HL) = 40h,
  /// SUB 0Fh; A←2Fh,Z←0,H←1,N←1 CY←0
  func test_sub_d8() {
    var cpu = Cpu()
    cpu.registers.a = 0x3e
    cpu.registers.e = 0x3e
    cpu.registers.hl = 0xfefe
    cpu.memory.write(0xfefe, value: 0x40)
    cpu.sub_d8(0x0f)

    XCTAssertEqual(cpu.registers.a, 0x2f)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, true)
    XCTAssertEqual(cpu.registers.subtractFlag, true)
    XCTAssertEqual(cpu.registers.carryFlag, false)
  }

  /// When A = 3Eh, E = 3Eh, and (HL) = 40h,
  /// SUB (HL) ; A←FEh,Z←0,H←0,N←1 CY←1
  func test_sub_pHL() {
    var cpu = Cpu()
    cpu.registers.a = 0x3e
    cpu.registers.e = 0x3e
    cpu.registers.hl = 0xfefe
    cpu.memory.write(0xfefe, value: 0x40)
    cpu.sub_pHL()

    XCTAssertEqual(cpu.registers.a, 0xfe)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, true)
    XCTAssertEqual(cpu.registers.carryFlag, true)
  }

  // MARK: - Sbc

  /// WhenA=3Bh, (HL)=4Fh,H=2Ah,andCY=1,
  /// SBC A, H ; A←10h,Z←0,H←0,N←1 CY←0
  func test_sbc_r() {
    var cpu = Cpu()
    cpu.registers.a = 0x3b
    cpu.registers.e = 0x2a // we are using .e instead of .h
    cpu.registers.hl = 0xfefe
    cpu.memory.write(0xfefe, value: 0x4f)
    cpu.registers.carryFlag = true
    cpu.sbc_r(.e)

    XCTAssertEqual(cpu.registers.a, 0x10)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, true)
    XCTAssertEqual(cpu.registers.carryFlag, false)
  }

  /// WhenA=3Bh, (HL)=4Fh,H=2Ah,andCY=1,
  /// SBC A, 3Ah; A←00h,Z←1,H←0,N←1 CY←0
  func test_sbc_d8() {
    var cpu = Cpu()
    cpu.registers.a = 0x3b
    cpu.registers.e = 0x2a // we are using .e instead of .h
    cpu.registers.hl = 0xfefe
    cpu.memory.write(0xfefe, value: 0x4f)
    cpu.registers.carryFlag = true
    cpu.sbc_d8(0x3a)

    XCTAssertEqual(cpu.registers.a, 0x00)
    XCTAssertEqual(cpu.registers.zeroFlag, true)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, true)
    XCTAssertEqual(cpu.registers.carryFlag, false)
  }

  /// WhenA=3Bh, (HL)=4Fh,H=2Ah,andCY=1,
  /// SBC A, (HL) ; A←EBh,Z←0,H←1,N←1 CY←1
  func test_sbc_pHL() {
    var cpu = Cpu()
    cpu.registers.a = 0x3b
    cpu.registers.e = 0x2a // we are using .e instead of .h
    cpu.registers.hl = 0xfefe
    cpu.memory.write(0xfefe, value: 0x4f)
    cpu.registers.carryFlag = true
    cpu.sbc_pHL()

    XCTAssertEqual(cpu.registers.a, 0xeb)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, true)
    XCTAssertEqual(cpu.registers.subtractFlag, true)
    XCTAssertEqual(cpu.registers.carryFlag, true)
  }

  // MARK: - And

  /// When A = 5Ah, L = 3Fh and (HL) = 0h,
  /// AND L ; A←1Ah,Z←0,H←1,N←0 CY←0
  func test_and_r() {
    var cpu = Cpu()
    cpu.registers.a = 0x5a
    cpu.registers.e = 0x3f // we are using .e instead of .l
    cpu.registers.hl = 0xfefe
    cpu.memory.write(0xfefe, value: 0x00)
    cpu.and_r(.e)

    XCTAssertEqual(cpu.registers.a, 0x1a)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, true)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, false)
  }

  /// When A = 5Ah, L = 3Fh and (HL) = 0h,
  /// AND 38h ; A←18h,Z←0,H←1,N←0 CY←0
  func test_and_d8() {
    var cpu = Cpu()
    cpu.registers.a = 0x5a
    cpu.registers.e = 0x3f // we are using .e instead of .l
    cpu.registers.hl = 0xfefe
    cpu.memory.write(0xfefe, value: 0x00)
    cpu.and_d8(0x38)

    XCTAssertEqual(cpu.registers.a, 0x18)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, true)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, false)
  }

  /// When A = 5Ah, L = 3Fh and (HL) = 0h,
  /// AND (HL) ; A←00h,Z←1,H←1,N←0 CY←0
  func test_and_pHL() {
    var cpu = Cpu()
    cpu.registers.a = 0x5a
    cpu.registers.e = 0x3f // we are using .e instead of .l
    cpu.registers.hl = 0xfefe
    cpu.memory.write(0xfefe, value: 0x00)
    cpu.and_pHL()

    XCTAssertEqual(cpu.registers.a, 0x00)
    XCTAssertEqual(cpu.registers.zeroFlag, true)
    XCTAssertEqual(cpu.registers.halfCarryFlag, true)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, false)
  }

  // MARK: - Or

  /// When A = 5Ah, (HL) = 0Fh,
  /// OR A ; A←5Ah,Z←0
  func test_or_r() {
    var cpu = Cpu()
    cpu.registers.a = 0x5a
    cpu.registers.hl = 0xfefe
    cpu.memory.write(0xfefe, value: 0x0f)
    cpu.or_r(.a)

    XCTAssertEqual(cpu.registers.a, 0x5a)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, false)
  }

  /// When A = 5Ah, (HL) = 0Fh,
  /// OR 3 ; A←5Bh,Z←0
  func test_or_d8() {
    var cpu = Cpu()
    cpu.registers.a = 0x5a
    cpu.registers.hl = 0xfefe
    cpu.memory.write(0xfefe, value: 0x0f)
    cpu.or_d8(0x03)

    XCTAssertEqual(cpu.registers.a, 0x5b)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, false)
  }

  /// When A = 5Ah, (HL) = 0Fh,
  /// OR (HL); A←5Fh,Z←0
  func test_or_pHL() {
    var cpu = Cpu()
    cpu.registers.a = 0x5a
    cpu.registers.hl = 0xfefe
    cpu.memory.write(0xfefe, value: 0x0f)
    cpu.or_pHL()

    XCTAssertEqual(cpu.registers.a, 0x5f)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, false)
  }

  // MARK: - Xor

  /// When A = FFh and (HL) = 8Ah,
  /// XOR A ; A←00h,Z←1
  func test_xor_r() {
    var cpu = Cpu()
    cpu.registers.a = 0xff
    cpu.registers.hl = 0xfefe
    cpu.memory.write(0xfefe, value: 0x8a)
    cpu.xor_r(.a)

    XCTAssertEqual(cpu.registers.a, 0x00)
    XCTAssertEqual(cpu.registers.zeroFlag, true)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, false)
  }

  /// When A = FFh and (HL) = 8Ah,
  /// XOR 0x0F ; A←F0h,Z←0
  func test_xor_d8() {
    var cpu = Cpu()
    cpu.registers.a = 0xff
    cpu.registers.hl = 0xfefe
    cpu.memory.write(0xfefe, value: 0x8a)
    cpu.xor_d8(0x0f)

    XCTAssertEqual(cpu.registers.a, 0xf0)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, false)
  }

  /// When A = FFh and (HL) = 8Ah,
  /// XOR (HL) ; A←75h,Z←0
  func test_xor_pHL() {
    var cpu = Cpu()
    cpu.registers.a = 0xff
    cpu.registers.hl = 0xfefe
    cpu.memory.write(0xfefe, value: 0x8a)
    cpu.xor_pHL()

    XCTAssertEqual(cpu.registers.a, 0x75)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, false)
  }

  // MARK: - Old

  /// When A = FFh,
  /// INC A ; A←0,Z←1,H←1,N←0
  func test_inc_r() {
    var cpu = Cpu()
    cpu.registers.a = 0xff
    cpu.inc_r(.a)

    XCTAssertEqual(cpu.registers.a, 0)
    XCTAssertEqual(cpu.registers.zeroFlag, true)
    XCTAssertEqual(cpu.registers.halfCarryFlag, true)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
  }

  /// When L = 01h,
  /// DEC L ; L←0,Z←1,H←0,N←1
  func test_dec_r() {
    var cpu = Cpu()
    cpu.registers.l = 0x01
    cpu.dec_r(.l)

    XCTAssertEqual(cpu.registers.l, 0)
    XCTAssertEqual(cpu.registers.zeroFlag, true)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, true)
  }
}
