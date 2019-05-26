import XCTest
@testable import SwiftBoy

// 8-Bit Arithmetic and Logical Operation Instructions
// https://ia801906.us.archive.org/19/items/GameBoyProgManVer1.1/GameBoyProgManVer1.1.pdf
class CpuTests: XCTestCase {

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
