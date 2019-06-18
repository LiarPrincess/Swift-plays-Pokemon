// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length
// swiftlint:disable type_body_length

import XCTest
@testable import GameBoyKit

class CpuArithmeticTests: XCTestCase {

  // MARK: - Add

  /// When A = 0x3A and B = 0xC6,
  /// ADD A, B ; A←0,Z←1,H←1,N←0,CY←1
  func test_add_a_r() {
    let bus = FakeCpuBus()
    let cpu = Cpu(bus: bus)
    cpu.registers.a = 0x3a
    cpu.registers.b = 0xc6
    cpu.add_a_r(.b)

    XCTAssertEqual(cpu.registers.a, 0)
    XCTAssertEqual(cpu.registers.zeroFlag, true)
    XCTAssertEqual(cpu.registers.halfCarryFlag, true)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, true)
  }

  /// When A = 3Ch,
  /// ADDA.FFh ; A←3Bh,Z←0,H←1,N←0,CY←1
  func test_add_a_d8() {
    let bus = FakeCpuBus()
    let cpu = Cpu(bus: bus)
    cpu.registers.a = 0x3c
    cpu.add_a_d8(0xff)

    XCTAssertEqual(cpu.registers.a, 0x3b)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, true)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, true)
  }

  /// When A = 3Ch and (HL) = 12h,
  /// ADD A, (HL) ; A←4Eh,Z←0,H←0,N←0,CY←0
  func test_add_a_pHL() {
    let bus = FakeCpuBus()
    let cpu = Cpu(bus: bus)
    cpu.registers.a = 0x3c
    cpu.registers.hl = 0xfefe
    bus.write(0xfefe, value: 0x12)
    cpu.add_a_pHL()

    XCTAssertEqual(cpu.registers.a, 0x4e)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, false)
  }

  /// When HL = 8A23h, BC = 0605h,
  /// ADD HL,BC ; HL←9028h,H←1,N←0,CY←0
  func test_add_hl_r1() {
    let bus = FakeCpuBus()
    let cpu = Cpu(bus: bus)
    cpu.registers.hl = 0x8a23
    cpu.registers.bc = 0x0605
    cpu.add_hl_r(.bc)

    XCTAssertEqual(cpu.registers.hl, 0x9028)
    XCTAssertEqual(cpu.registers.halfCarryFlag, true)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, false)
  }

  /// When HL = 8A23h, BC = 0605h,
  /// ADD HL,HL ; HL←1446h,H←1,N←0,CY←1
  func test_add_hl_r2() {
    let bus = FakeCpuBus()
    let cpu = Cpu(bus: bus)
    cpu.registers.hl = 0x8a23
    cpu.registers.bc = 0x0605
    cpu.add_hl_r(.hl)

    XCTAssertEqual(cpu.registers.hl, 0x1446)
    XCTAssertEqual(cpu.registers.halfCarryFlag, true)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, true)
  }

  /// SP = FFF8h
  /// ADDSP,2 ; SP←0xFFFA,CY←0,H←0,N←0,Z←0
  func test_add_sp_r8() {
    let bus = FakeCpuBus()
    let cpu = Cpu(bus: bus)
    cpu.sp = 0xfff8
    cpu.add_sp_r8(0x2)

    XCTAssertEqual(cpu.sp, 0xfffa)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, false)
  }

  // MARK: - Adc

  /// WhenA=E1h,E=0Fh,(HL)=1Eh,andCY=1,
  /// ADC A, E ; A←F1h,Z←0,H←1,CY←0
  func test_adc_a_r() {
    let bus = FakeCpuBus()
    let cpu = Cpu(bus: bus)
    cpu.registers.a = 0xe1
    cpu.registers.e = 0x0f
    cpu.registers.hl = 0xfefe
    bus.write(0xfefe, value: 0x1e)
    cpu.registers.carryFlag = true
    cpu.adc_a_r(.e)

    XCTAssertEqual(cpu.registers.a, 0xf1)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, true)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, false)
  }

  /// WhenA=E1h,E=0Fh,(HL)=1Eh,andCY=1,
  /// ADC A, 3Bh ; A←1Dh,Z←0,H←0,CY←-1
  func test_adc_a_d8() {
    let bus = FakeCpuBus()
    let cpu = Cpu(bus: bus)
    cpu.registers.a = 0xe1
    cpu.registers.e = 0x0f
    cpu.registers.hl = 0xfefe
    bus.write(0xfefe, value: 0x1e)
    cpu.registers.carryFlag = true
    cpu.adc_a_d8(0x3b)

    XCTAssertEqual(cpu.registers.a, 0x1d)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, true)
  }

  /// WhenA=E1h,E=0Fh,(HL)=1Eh,andCY=1,
  /// ADC A, (HL) ; A←00h,Z←1,H←1,CY←1
  func test_adc_a_pHL() {
    let bus = FakeCpuBus()
    let cpu = Cpu(bus: bus)
    cpu.registers.a = 0xe1
    cpu.registers.e = 0x0f
    cpu.registers.hl = 0xfefe
    bus.write(0xfefe, value: 0x1e)
    cpu.registers.carryFlag = true
    cpu.adc_a_pHL()

    XCTAssertEqual(cpu.registers.a, 0x00)
    XCTAssertEqual(cpu.registers.zeroFlag, true)
    XCTAssertEqual(cpu.registers.halfCarryFlag, true)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, true)
  }

  // MARK: - Sub

  /// When A = 3Eh, E = 3Eh, and (HL) = 40h,
  /// SUB E ; A←00h,Z←1,H←0,N←1 CY←0
  func test_sub_a_r() {
    let bus = FakeCpuBus()
    let cpu = Cpu(bus: bus)
    cpu.registers.a = 0x3e
    cpu.registers.e = 0x3e
    cpu.registers.hl = 0xfefe
    bus.write(0xfefe, value: 0x40)
    cpu.sub_a_r(.e)

    XCTAssertEqual(cpu.registers.a, 0x00)
    XCTAssertEqual(cpu.registers.zeroFlag, true)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, true)
    XCTAssertEqual(cpu.registers.carryFlag, false)
  }

  /// When A = 3Eh, E = 3Eh, and (HL) = 40h,
  /// SUB 0Fh; A←2Fh,Z←0,H←1,N←1 CY←0
  func test_sub_a_d8() {
    let bus = FakeCpuBus()
    let cpu = Cpu(bus: bus)
    cpu.registers.a = 0x3e
    cpu.registers.e = 0x3e
    cpu.registers.hl = 0xfefe
    bus.write(0xfefe, value: 0x40)
    cpu.sub_a_d8(0x0f)

    XCTAssertEqual(cpu.registers.a, 0x2f)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, true)
    XCTAssertEqual(cpu.registers.subtractFlag, true)
    XCTAssertEqual(cpu.registers.carryFlag, false)
  }

  /// When A = 3Eh, E = 3Eh, and (HL) = 40h,
  /// SUB (HL) ; A←FEh,Z←0,H←0,N←1 CY←1
  func test_sub_a_pHL() {
    let bus = FakeCpuBus()
    let cpu = Cpu(bus: bus)
    cpu.registers.a = 0x3e
    cpu.registers.e = 0x3e
    cpu.registers.hl = 0xfefe
    bus.write(0xfefe, value: 0x40)
    cpu.sub_a_pHL()

    XCTAssertEqual(cpu.registers.a, 0xfe)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, true)
    XCTAssertEqual(cpu.registers.carryFlag, true)
  }

  // MARK: - Sbc

  /// WhenA=3Bh, (HL)=4Fh,H=2Ah,andCY=1,
  /// SBC A, H ; A←10h,Z←0,H←0,N←1 CY←0
  func test_sbc_a_r() {
    let bus = FakeCpuBus()
    let cpu = Cpu(bus: bus)
    cpu.registers.a = 0x3b
    cpu.registers.e = 0x2a // we are using .e instead of .h
    cpu.registers.hl = 0xfefe
    bus.write(0xfefe, value: 0x4f)
    cpu.registers.carryFlag = true
    cpu.sbc_a_r(.e)

    XCTAssertEqual(cpu.registers.a, 0x10)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, true)
    XCTAssertEqual(cpu.registers.carryFlag, false)
  }

  /// WhenA=3Bh, (HL)=4Fh,H=2Ah,andCY=1,
  /// SBC A, 3Ah; A←00h,Z←1,H←0,N←1 CY←0
  func test_sbc_a_d8() {
    let bus = FakeCpuBus()
    let cpu = Cpu(bus: bus)
    cpu.registers.a = 0x3b
    cpu.registers.e = 0x2a // we are using .e instead of .h
    cpu.registers.hl = 0xfefe
    bus.write(0xfefe, value: 0x4f)
    cpu.registers.carryFlag = true
    cpu.sbc_a_d8(0x3a)

    XCTAssertEqual(cpu.registers.a, 0x00)
    XCTAssertEqual(cpu.registers.zeroFlag, true)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, true)
    XCTAssertEqual(cpu.registers.carryFlag, false)
  }

  /// WhenA=3Bh, (HL)=4Fh,H=2Ah,andCY=1,
  /// SBC A, (HL) ; A←EBh,Z←0,H←1,N←1 CY←1
  func test_sbc_a_pHL() {
    let bus = FakeCpuBus()
    let cpu = Cpu(bus: bus)
    cpu.registers.a = 0x3b
    cpu.registers.e = 0x2a // we are using .e instead of .h
    cpu.registers.hl = 0xfefe
    bus.write(0xfefe, value: 0x4f)
    cpu.registers.carryFlag = true
    cpu.sbc_a_pHL()

    XCTAssertEqual(cpu.registers.a, 0xeb)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, true)
    XCTAssertEqual(cpu.registers.subtractFlag, true)
    XCTAssertEqual(cpu.registers.carryFlag, true)
  }

  // MARK: - Cp

  /// When A = 3Ch, B = 2Fh, and (HL) = 40h,
  /// CP B ; Z←0,H←1,N←1,CY←0
  func test_cp_a_r() {
    let bus = FakeCpuBus()
    let cpu = Cpu(bus: bus)
    cpu.registers.a = 0x3c
    cpu.registers.b = 0x2f
    cpu.registers.hl = 0xfefe
    bus.write(0xfefe, value: 0x40)
    cpu.cp_a_r(.b)

    XCTAssertEqual(cpu.registers.a, 0x3c) // not stored
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, true)
    XCTAssertEqual(cpu.registers.subtractFlag, true)
    XCTAssertEqual(cpu.registers.carryFlag, false)
  }

  /// When A = 3Ch, B = 2Fh, and (HL) = 40h,
  /// CP 3Ch ; Z←1,H←0,N←1,CY←0
  func test_cp_a_d8() {
    let bus = FakeCpuBus()
    let cpu = Cpu(bus: bus)
    cpu.registers.a = 0x3c
    cpu.registers.b = 0x2f
    cpu.registers.hl = 0xfefe
    bus.write(0xfefe, value: 0x40)
    cpu.cp_a_d8(0x3c)

    XCTAssertEqual(cpu.registers.a, 0x3c) // not stored
    XCTAssertEqual(cpu.registers.zeroFlag, true)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, true)
    XCTAssertEqual(cpu.registers.carryFlag, false)
  }

  /// When A = 3Ch, B = 2Fh, and (HL) = 40h,
  /// CP(HL) ; Z←0,H←0,N←1,CY←1
  func test_cp_a_pHL() {
    let bus = FakeCpuBus()
    let cpu = Cpu(bus: bus)
    cpu.registers.a = 0x3c
    cpu.registers.b = 0x2f
    cpu.registers.hl = 0xfefe
    bus.write(0xfefe, value: 0x40)
    cpu.cp_a_pHL()

    XCTAssertEqual(cpu.registers.a, 0x3c) // not stored
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, true)
    XCTAssertEqual(cpu.registers.carryFlag, true)
  }

  // MARK: - Inc

  /// When A = FFh,
  /// INC A ; A←0,Z←1,H←1,N←0
  func test_inc_r() {
    let bus = FakeCpuBus()
    let cpu = Cpu(bus: bus)
    cpu.registers.a = 0xff
    cpu.inc_r(.a)

    XCTAssertEqual(cpu.registers.a, 0)
    XCTAssertEqual(cpu.registers.zeroFlag, true)
    XCTAssertEqual(cpu.registers.halfCarryFlag, true)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
  }

  /// When DE = 235Fh,
  /// INC DE ; DE ← 2360h
  func test_inc_rr() {
    let bus = FakeCpuBus()
    let cpu = Cpu(bus: bus)
    cpu.registers.de = 0x235f
    cpu.inc_rr(.de)

    XCTAssertEqual(cpu.registers.de, 0x2360)
  }

  /// When (HL) = 0x50,
  /// INC (HL) ; (HL)←0x51,Z←0,H←0,N←0
  func test_inc_pHL() {
    let bus = FakeCpuBus()
    let cpu = Cpu(bus: bus)
    cpu.registers.hl = 0xfefe
    bus.write(0xfefe, value: 0x50)
    cpu.inc_pHL()

    XCTAssertEqual(bus.read(0xfefe), 0x51)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
  }

  // MARK: - Dec

  /// When L = 01h,
  /// DEC L ; L←0,Z←1,H←0,N←1
  func test_dec_r() {
    let bus = FakeCpuBus()
    let cpu = Cpu(bus: bus)
    cpu.registers.l = 0x01
    cpu.dec_r(.l)

    XCTAssertEqual(cpu.registers.l, 0)
    XCTAssertEqual(cpu.registers.zeroFlag, true)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, true)
  }

  /// When DE = 235Fh,
  /// DEC DE ; DE ← 235Eh
  func test_dec_rr() {
    let bus = FakeCpuBus()
    let cpu = Cpu(bus: bus)
    cpu.registers.de = 0x235f
    cpu.dec_rr(.de)

    XCTAssertEqual(cpu.registers.de, 0x235e)
  }

  /// When (HL) = 00h,
  /// DEC(HL) ; (HL)←FFh,Z←0,H←1,N←1
  func test_dec_pHL() {
    let bus = FakeCpuBus()
    let cpu = Cpu(bus: bus)
    cpu.registers.hl = 0xfefe
    bus.write(0xfefe, value: 0x00)
    cpu.dec_pHL()

    XCTAssertEqual(bus.read(0xfefe), 0xff)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, true)
    XCTAssertEqual(cpu.registers.subtractFlag, true)
  }
}
