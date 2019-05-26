// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

import XCTest
@testable import SwiftBoy

class CpuLdTests: XCTestCase {

  /// LD A,B ; A←B
  func test_ld_r_r() {
    var cpu = Cpu()
    cpu.registers.b = 0xfe
    cpu.ld_r_r(.a, .b)

    XCTAssertEqual(cpu.registers.a, 0xfe)
    XCTAssertEqual(cpu.registers.b, 0xfe)
  }

  /// LD B,24h ; B← 24h
  func test_ld_r_n() {
    var cpu = Cpu()
    cpu.ld_r_n(.b, 0x24)

    XCTAssertEqual(cpu.registers.b, 0x24)
  }

  /// When (HL) = 5Ch,
  /// LDH,(HL) ; H ←5Ch
  func test_ld_ld_r_pHL() {
    var cpu = Cpu()
    cpu.registers.hl = 0xfefe
    cpu.memory.write(0xfefe, value: 0x5c)
    cpu.ld_r_pHL(.h)

    XCTAssertEqual(cpu.registers.h, 0x5c)
  }

  /// When A = 3Ch, HL = 8AC5h
  /// LD (HL), A ; (8AC5h) ← 3Ch
  func test_ld_ld_pHL_r() {
    var cpu = Cpu()
    cpu.registers.a = 0x3c
    cpu.registers.hl = 0x8ac5
    cpu.ld_pHL_r(.a)

    XCTAssertEqual(cpu.memory.read(0x8ac5), 0x3c)
  }

  /// When HL = 8AC5h,
  /// LD (HL), 0;8AC5h←0
  func test_ld_pHL_n() {
    var cpu = Cpu()
    cpu.registers.hl = 0x8ac5
    cpu.ld_pHL_n(0x3c) // memory starts with value 0

    XCTAssertEqual(cpu.memory.read(0x8ac5), 0x3c)
  }

  /// When (BC) = 2Fh,
  /// LD A, (BC) ; A←2Fh
  func test_ld_a_pBC() {
    var cpu = Cpu()
    cpu.registers.bc = 0x8ac5
    cpu.memory.write(0x8ac5, value: 0x2f)
    cpu.ld_a_pBC()

    XCTAssertEqual(cpu.registers.a, 0x2f)
  }

  /// When (DE) = 5Fh,
  /// LD A, (DE) ; A ← 5Fh
  func test_ld_a_pDE() {
    var cpu = Cpu()
    cpu.registers.de = 0x8ac5
    cpu.memory.write(0x8ac5, value: 0x5f)
    cpu.ld_a_pDE()

    XCTAssertEqual(cpu.registers.a, 0x5f)
  }

  /// When C = 95h,
  /// LD A, (C) ; A ← contents of (FF95h)
  func test_ld_a_ffC() {
    var cpu = Cpu()
    cpu.registers.c = 0x95
    cpu.memory.write(0xff95, value: 0x5f)
    cpu.ld_a_ffC()

    XCTAssertEqual(cpu.registers.a, 0x5f)
  }

  /// When C = 9Fh,
  /// LD (C), A ; (FF9Fh) ← A
  func test_ld_ffC_a() {
    var cpu = Cpu()
    cpu.registers.a = 0x5f
    cpu.registers.c = 0x9f
    cpu.ld_ffC_a()

    XCTAssertEqual(cpu.memory.read(0xff9f), 0x5f)
  }

  /// When HL = 1FFh and (1FFh) = 56h,
  /// LD A, (HLI) ; A←56h,HL←200h
  func test_ld_a_pHLI() {
    var cpu = Cpu()
    cpu.registers.hl = 0x1ff
    cpu.memory.write(0x1ff, value: 0x56)
    cpu.ld_a_pHLI()

    XCTAssertEqual(cpu.registers.a, 0x56)
    XCTAssertEqual(cpu.registers.hl, 0x200)
  }

  /// When HL = 8A5Ch and (8A5Ch) = 3Ch,
  /// LD A, (HLD) ; A←3Ch,HL←8A5Bh
  func test_ld_a_pHLD() {
    var cpu = Cpu()
    cpu.registers.hl = 0x8a5c
    cpu.memory.write(0x8a5c, value: 0x3c)
    cpu.ld_a_pHLD()

    XCTAssertEqual(cpu.registers.a, 0x3c)
    XCTAssertEqual(cpu.registers.hl, 0x8a5b)
  }

  /// When BC = 205Fh and A = 3Fh,
  /// LD (BC) , A ; (205Fh) ← 3Fh
  func test_ld_pBC_a() {
    var cpu = Cpu()
    cpu.registers.a = 0x3c
    cpu.registers.bc = 0x205f
    cpu.ld_pBC_a()

    XCTAssertEqual(cpu.memory.read(0x205f), 0x3c)
  }

  /// When DE = 205Ch and A = 00h,
  /// LD (DE) , A ; (205Ch) ← 00h
  func test_ld_pDE_a() {
    var cpu = Cpu()
    cpu.registers.a = 0x3c // memory starts with value 0
    cpu.registers.de = 0x205f
    cpu.ld_pDE_a()

    XCTAssertEqual(cpu.memory.read(0x205f), 0x3c)
  }

  /// When HL = FFFFh and A = 56h,
  /// LD (HLI), A ; (0xFFFF) ← 56h, HL = 0000h
  func test_ld_pHLI_a() {
    var cpu = Cpu()
    cpu.registers.hl = 0xffff
    cpu.registers.a = 0x56
    cpu.ld_pHLI_a()

    XCTAssertEqual(cpu.memory.read(0xffff), 0x56)
    XCTAssertEqual(cpu.registers.hl, 0x0000)
  }

  /// HL = 4000h and A = 5h,
  /// LD (HLD), A ; (4000h) ← 5h, HL = 3FFFh
  func test_ld_pHLD_a() {
    var cpu = Cpu()
    cpu.registers.hl = 0x4000
    cpu.registers.a = 0x5
    cpu.ld_pHLD_a()

    XCTAssertEqual(cpu.memory.read(0x4000), 0x5)
    XCTAssertEqual(cpu.registers.hl, 0x3fff)
  }
}
