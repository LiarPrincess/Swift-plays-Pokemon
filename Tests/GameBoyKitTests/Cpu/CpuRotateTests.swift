// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import GameBoyKit

class CpuRotateTests: CpuTestCase {

  // MARK: - Rotate left

  /// When A = 85h and CY = 0,
  /// RLCA ; A←0Ah,CY←1,Z←0,H←0,N←0
  func test_rlca() {
    let memory = self.createFakeMemory()
    let cpu = self.createCpu(memory: memory)
    cpu.registers.a = 0x85
    cpu.registers.carryFlag = false
    _ = cpu.rlca()

    // test is incorrect: lowest bit should be taken from carry, which is 1,
    // so instead of 0b00001010 we have 0b00001011
    print(UInt8(0x0a).bin)
    XCTAssertEqual(cpu.registers.a, 0x0b)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, true)
  }

  /// When A = 95h and CY = 1,
  /// RLA ; A ←2Bh,C←1,Z←0,H←0,N←0
  func test_rla() {
    let memory = self.createFakeMemory()
    let cpu = self.createCpu(memory: memory)
    cpu.registers.a = 0x95
    cpu.registers.carryFlag = true
    _ = cpu.rla()

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
    let memory = self.createFakeMemory()
    let cpu = self.createCpu(memory: memory)
    cpu.registers.a = 0x3b
    cpu.registers.carryFlag = false
    _ = cpu.rrca()

    XCTAssertEqual(cpu.registers.a, 0x9d)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, true)
  }

  /// When A = 81h and CY = 0,
  /// RRA ; A←40h,CY←1,Z←0,H←0,N←0
  func test_rra() {
    let memory = self.createFakeMemory()
    let cpu = self.createCpu(memory: memory)
    cpu.registers.a = 0x81
    cpu.registers.carryFlag = false
    _ = cpu.rra()

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
    let memory = self.createFakeMemory()
    let cpu = self.createCpu(memory: memory)
    cpu.registers.b = 0x85
    cpu.registers.hl = 0xfefe
    memory.write(0xfefe, value: 0)
    cpu.registers.carryFlag = false
    _ = cpu.rlc_r(.b)

    XCTAssertEqual(cpu.registers.b, 0x0b)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, true)
  }

  /// When B = 85h, (HL) = 0, and CY = 0,
  /// RLC (HL) ; (HL)←00h,CY←0,Z←1,H←0,N←0
  func test_rlc_pHL() {
    let memory = self.createFakeMemory()
    let cpu = self.createCpu(memory: memory)
    cpu.registers.b = 0x85
    cpu.registers.hl = 0xfefe
    memory.write(0xfefe, value: 0)
    cpu.registers.carryFlag = false
    _ = cpu.rlc_pHL()

    XCTAssertEqual(memory.read(0xfefe), 0x00)
    XCTAssertEqual(cpu.registers.zeroFlag, true)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, false)
  }

  /// When L = 80h, (HL) = 11h, and CY = 0,
  /// RL L ; L←00h,CY←1,Z←1,H←0,N←0
  func test_rl_r() {
    let memory = self.createFakeMemory()
    let cpu = self.createCpu(memory: memory)
    cpu.registers.b = 0x80 // we use 'b' instead of 'l'
    cpu.registers.hl = 0xfefe
    memory.write(0xfefe, value: 0x11)
    cpu.registers.carryFlag = false
    _ = cpu.rl_r(.b)

    XCTAssertEqual(cpu.registers.b, 0x00)
    XCTAssertEqual(cpu.registers.zeroFlag, true)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, true)
  }

  func test_rl_r_bootrom_0x009d() {
    let memory = self.createFakeMemory()
    let cpu = self.createCpu(memory: memory)
    cpu.registers.c = 0xce // after 0x9c
    cpu.registers.zeroFlag = false
    cpu.registers.subtractFlag = false
    cpu.registers.halfCarryFlag = false
    cpu.registers.carryFlag = true
    _ = cpu.rl_r(.c)

    XCTAssertEqual(cpu.registers.c, 0x9d)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, true)
  }

  /// When L = 80h, (HL) = 11h, and CY = 0,
  /// RL (HL) ; (HL)←22h,CY←0,Z←0,H←0,N←0
  func test_rl_pHL() {
    let memory = self.createFakeMemory()
    let cpu = self.createCpu(memory: memory)
    cpu.registers.b = 0x80 // we use 'b' instead of 'l'
    cpu.registers.hl = 0xfefe
    memory.write(0xfefe, value: 0x11)
    cpu.registers.carryFlag = false
    _ = cpu.rl_pHL()

    XCTAssertEqual(memory.read(0xfefe), 0x22)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, false)
  }

  // MARK: - Prefix rotate right

  /// When C = 1h, (HL) = 0h, CY = 0,
  /// RRC C ; C←80h,CY←1,Z←0,H←0,N←0
  func test_rrc_r() {
    let memory = self.createFakeMemory()
    let cpu = self.createCpu(memory: memory)
    cpu.registers.c = 0x01
    cpu.registers.hl = 0xfefe
    memory.write(0xfefe, value: 0)
    cpu.registers.carryFlag = false
    _ = cpu.rrc_r(.c)

    XCTAssertEqual(cpu.registers.c, 0x80)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, true)
  }

  /// When C = 1h, (HL) = 0h, CY = 0,
  /// RRC (HL) ; (HL)←00h,CY←0,Z←1,H←0,N←0
  func test_rrc_pHL() {
    let memory = self.createFakeMemory()
    let cpu = self.createCpu(memory: memory)
    cpu.registers.c = 0x01
    cpu.registers.hl = 0xfefe
    memory.write(0xfefe, value: 0)
    cpu.registers.carryFlag = false
    _ = cpu.rrc_pHL()

    XCTAssertEqual(memory.read(0xfefe), 0x00)
    XCTAssertEqual(cpu.registers.zeroFlag, true)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, false)
  }

  /// When A = 1h, (HL) = 8Ah, CY = 0,
  /// RR A ; A←00h,CY←1,Z←1,H←0,N←0
  func test_rr_r() {
    let memory = self.createFakeMemory()
    let cpu = self.createCpu(memory: memory)
    cpu.registers.a = 0x01
    cpu.registers.hl = 0xfefe
    memory.write(0xfefe, value: 0x8a)
    cpu.registers.carryFlag = false
    _ = cpu.rr_r(.a)

    XCTAssertEqual(cpu.registers.a, 0x00)
    XCTAssertEqual(cpu.registers.zeroFlag, true)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, true)
  }

  /// When A = 1h, (HL) = 8Ah, CY = 0,
  /// RR (HL) ; (HL)←45h,CY←0,Z←0,H←0,N←0
  func test_rr_pHL() {
    let memory = self.createFakeMemory()
    let cpu = self.createCpu(memory: memory)
    cpu.registers.a = 0x01
    cpu.registers.hl = 0xfefe
    memory.write(0xfefe, value: 0x8a)
    cpu.registers.carryFlag = false
    _ = cpu.rr_pHL()

    XCTAssertEqual(memory.read(0xfefe), 0x45)
    XCTAssertEqual(cpu.registers.zeroFlag, false)
    XCTAssertEqual(cpu.registers.halfCarryFlag, false)
    XCTAssertEqual(cpu.registers.subtractFlag, false)
    XCTAssertEqual(cpu.registers.carryFlag, false)
  }
}
