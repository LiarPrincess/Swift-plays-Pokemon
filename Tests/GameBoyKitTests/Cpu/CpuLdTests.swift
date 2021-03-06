// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftlint:disable file_length

import XCTest
@testable import GameBoyKit

class CpuLdTests: CpuTestCase {

  // MARK: - 8-Bit Transfer and Input/Output Instructions

  /// LD A,B ; A←B
  func test_ld_r_r() {
    let memory = self.createFakeMemory()
    let cpu = self.createCpu(memory: memory)
    cpu.registers.b = 0xfe
    _ = cpu.ld_r_r(.a, .b)

    XCTAssertEqual(cpu.registers.a, 0xfe)
    XCTAssertEqual(cpu.registers.b, 0xfe)
  }

  /// LD B,24h ; B← 24h
  func test_ld_r_d8() {
    let memory = self.createFakeMemory()
    let cpu = self.createCpu(memory: memory)
    _ = cpu.ld_r_d8(.b, 0x24)

    XCTAssertEqual(cpu.registers.b, 0x24)
  }

  /// When (HL) = 5Ch,
  /// LDH,(HL) ; H ←5Ch
  func test_ld_ld_r_pHL() {
    let memory = self.createFakeMemory()
    let cpu = self.createCpu(memory: memory)
    cpu.registers.hl = 0xfefe
    memory.write(0xfefe, value: 0x5c)
    _ = cpu.ld_r_pHL(.h)

    XCTAssertEqual(cpu.registers.h, 0x5c)
  }

  /// When A = 3Ch, HL = 8AC5h
  /// LD (HL), A ; (8AC5h) ← 3Ch
  func test_ld_ld_pHL_r() {
    let memory = self.createFakeMemory()
    let cpu = self.createCpu(memory: memory)
    cpu.registers.a = 0x3c
    cpu.registers.hl = 0x8ac5
    _ = cpu.ld_pHL_r(.a)

    XCTAssertEqual(memory.read(0x8ac5), 0x3c)
  }

  /// When HL = 8AC5h,
  /// LD (HL), 0;8AC5h←0
  func test_ld_pHL_d8() {
    let memory = self.createFakeMemory()
    let cpu = self.createCpu(memory: memory)
    cpu.registers.hl = 0x8ac5
    _ = cpu.ld_pHL_d8(0x3c) // memory starts with value 0

    XCTAssertEqual(memory.read(0x8ac5), 0x3c)
  }

  /// When (BC) = 2Fh,
  /// LD A, (BC) ; A←2Fh
  func test_ld_a_pBC() {
    let memory = self.createFakeMemory()
    let cpu = self.createCpu(memory: memory)
    cpu.registers.bc = 0x8ac5
    memory.write(0x8ac5, value: 0x2f)
    _ = cpu.ld_a_pBC()

    XCTAssertEqual(cpu.registers.a, 0x2f)
  }

  /// When (DE) = 5Fh,
  /// LD A, (DE) ; A ← 5Fh
  func test_ld_a_pDE() {
    let memory = self.createFakeMemory()
    let cpu = self.createCpu(memory: memory)
    cpu.registers.de = 0x8ac5
    memory.write(0x8ac5, value: 0x5f)
    _ = cpu.ld_a_pDE()

    XCTAssertEqual(cpu.registers.a, 0x5f)
  }

  /// When C = 95h,
  /// LD A, (C) ; A ← contents of (FF95h)
  func test_ld_a_ffC() {
    let memory = self.createFakeMemory()
    let cpu = self.createCpu(memory: memory)
    cpu.registers.c = 0x95
    memory.write(0xff95, value: 0x5f)
    _ = cpu.ld_a_ffC()

    XCTAssertEqual(cpu.registers.a, 0x5f)
  }

  /// When C = 9Fh,
  /// LD (C), A ; (FF9Fh) ← A
  func test_ld_ffC_a() {
    let memory = self.createFakeMemory()
    let cpu = self.createCpu(memory: memory)
    cpu.registers.a = 0x5f
    cpu.registers.c = 0x9f
    _ = cpu.ld_ffC_a()

    XCTAssertEqual(memory.read(0xff9f), 0x5f)
  }

  /// To load data at FF34h into register A, type the following.
  /// LD A, (FF34)
  func test_ld_a_pA8() {
    let memory = self.createFakeMemory()
    let cpu = self.createCpu(memory: memory)
    memory.write(0xff34, value: 0xfe)
    _ = cpu.ld_a_pA8(0x34)

    XCTAssertEqual(cpu.registers.a, 0xfe)
  }

  /// To load the contents of register A in 0xFF34, type the following.
  /// LD (FF34), A
  func test_ld_pA8_a() {
    let memory = self.createFakeMemory()
    let cpu = self.createCpu(memory: memory)
    cpu.registers.a = 0xfe
    _ = cpu.ld_pA8_a(0x34)

    XCTAssertEqual(memory.read(0xff34), 0xfe)
  }

  /// LD A, (8000h) ; A ← (8000h)
  func test_ld_a_pA16() {
    let memory = self.createFakeMemory()
    let cpu = self.createCpu(memory: memory)
    memory.write(0xff34, value: 0xfe)
    _ = cpu.ld_a_pA16(0xff34)

    XCTAssertEqual(cpu.registers.a, 0xfe)
  }

  /// LD (8000h), A ; (8000h) ← A
  func test_ld_pA16_a() {
    let memory = self.createFakeMemory()
    let cpu = self.createCpu(memory: memory)
    cpu.registers.a = 0xfe
    _ = cpu.ld_pA16_a(0x8000)

    XCTAssertEqual(memory.read(0x8000), 0xfe)
  }

  /// When HL = 1FFh and (1FFh) = 56h,
  /// LD A, (HLI) ; A←56h,HL←200h
  func test_ld_a_pHLI() {
    let memory = self.createFakeMemory()
    let cpu = self.createCpu(memory: memory)
    cpu.registers.hl = 0x1ff
    memory.write(0x1ff, value: 0x56)
    _ = cpu.ld_a_pHLI()

    XCTAssertEqual(cpu.registers.a, 0x56)
    XCTAssertEqual(cpu.registers.hl, 0x200)
  }

  /// When HL = 8A5Ch and (8A5Ch) = 3Ch,
  /// LD A, (HLD) ; A←3Ch,HL←8A5Bh
  func test_ld_a_pHLD() {
    let memory = self.createFakeMemory()
    let cpu = self.createCpu(memory: memory)
    cpu.registers.hl = 0x8a5c
    memory.write(0x8a5c, value: 0x3c)
    _ = cpu.ld_a_pHLD()

    XCTAssertEqual(cpu.registers.a, 0x3c)
    XCTAssertEqual(cpu.registers.hl, 0x8a5b)
  }

  /// When BC = 205Fh and A = 3Fh,
  /// LD (BC) , A ; (205Fh) ← 3Fh
  func test_ld_pBC_a() {
    let memory = self.createFakeMemory()
    let cpu = self.createCpu(memory: memory)
    cpu.registers.a = 0x3c
    cpu.registers.bc = 0x205f
    _ = cpu.ld_pBC_a()

    XCTAssertEqual(memory.read(0x205f), 0x3c)
  }

  /// When DE = 205Ch and A = 00h,
  /// LD (DE) , A ; (205Ch) ← 00h
  func test_ld_pDE_a() {
    let memory = self.createFakeMemory()
    let cpu = self.createCpu(memory: memory)
    cpu.registers.a = 0x3c // memory starts with value 0
    cpu.registers.de = 0x205f
    _ = cpu.ld_pDE_a()

    XCTAssertEqual(memory.read(0x205f), 0x3c)
  }

  /// When HL = FFFFh and A = 56h,
  /// LD (HLI), A ; (0xFFFF) ← 56h, HL = 0000h
  func test_ld_pHLI_a() {
    let memory = self.createFakeMemory()
    let cpu = self.createCpu(memory: memory)
    cpu.registers.hl = 0xffff
    cpu.registers.a = 0x56
    _ = cpu.ld_pHLI_a()

    XCTAssertEqual(memory.read(0xffff), 0x56)
    XCTAssertEqual(cpu.registers.hl, 0x0000)
  }

  /// HL = 4000h and A = 5h,
  /// LD (HLD), A ; (4000h) ← 5h, HL = 3FFFh
  func test_ld_pHLD_a() {
    let memory = self.createFakeMemory()
    let cpu = self.createCpu(memory: memory)
    cpu.registers.hl = 0x4000
    cpu.registers.a = 0x5
    _ = cpu.ld_pHLD_a()

    XCTAssertEqual(memory.read(0x4000), 0x5)
    XCTAssertEqual(cpu.registers.hl, 0x3fff)
  }

  // MARK: - 16-Bit Transfer Instructions

  /// LD HL,3A5Bh ; H ←3Ah,L←5Bh
  func test_ld_rr_d16() {
    let memory = self.createFakeMemory()
    let cpu = self.createCpu(memory: memory)
    _ = cpu.ld_rr_d16(.hl, 0x3a5b)

    XCTAssertEqual(cpu.registers.hl, 0x3a5b)
  }

  /// When HL = FFFFh
  /// LD SP,HL ; SP ←FFFFh
  func test_ld_sp_hl() {
    let memory = self.createFakeMemory()
    let cpu = self.createCpu(memory: memory)
    cpu.registers.hl = 0xffff
    _ = cpu.ld_sp_hl()

    XCTAssertEqual(cpu.sp, 0xffff)
  }

  /// When SP = FFFEh,
  /// PUSH BC ; (FFFCh), (FFFCh) ← B, SP ← FFFCh
  func test_push() {
    let memory = self.createFakeMemory()
    let cpu = self.createCpu(memory: memory)
    cpu.sp = 0xfffe
    cpu.registers.bc = 0xabcd
    _ = cpu.push(.bc)

    XCTAssertEqual(cpu.sp, 0xfffc)
    XCTAssertEqual(memory.read(0xfffd), 0xab)
    XCTAssertEqual(memory.read(0xfffc), 0xcd)
  }

  /// When SP = FFFCh, (FFFCh) = 5Fh, and (FFFDh) = 3Ch,
  /// POP BC ; B ← 3Ch, C ← 5Fh, SP ← FFFEh
  func test_pop() {
    let memory = self.createFakeMemory()
    let cpu = self.createCpu(memory: memory)
    cpu.sp = 0xfffc
    memory.write(0xfffc, value: 0x5f)
    memory.write(0xfffd, value: 0x3c)
    _ = cpu.pop(.bc)

    XCTAssertEqual(cpu.registers.b, 0x3c)
    XCTAssertEqual(cpu.registers.c, 0x5f)
    XCTAssertEqual(cpu.sp, 0xfffe)
  }

  /// When SP = 0xFFF8,
  /// LDHL SP, 2 ; HL←0xFFFA,CY←0,H←0,N←0,Z←0
  func test_ldhl_sp_plus_e() {
    let memory = self.createFakeMemory()
    let cpu = self.createCpu(memory: memory)
    cpu.sp = 0xfff8
    _ = cpu.ldhl_sp_plus_e(2)

    XCTAssertEqual(cpu.registers.hl, 0xfffa)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, false)
  }

  /// When SP = FFF8h,
  /// LD (C100h) , SP ; C100h ← F8h C101h← FFh
  func test_ld_pA16_sp() {
    let memory = self.createFakeMemory()
    let cpu = self.createCpu(memory: memory)
    cpu.sp = 0xfff8
    _ = cpu.ld_pA16_sp(0xc100)

    XCTAssertEqual(memory.read(0xc100), 0xf8)
    XCTAssertEqual(memory.read(0xc101), 0xff)
  }
}
