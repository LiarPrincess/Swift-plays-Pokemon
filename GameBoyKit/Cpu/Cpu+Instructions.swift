// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftlint:disable file_length

internal enum JumpCondition {
  case nz
  case z
  case nc
  case c
}

// This file is massive, but we need it this way so we can easier Cmd+F.
// Source: https://ia801906.us.archive.org/19/items/GameBoyProgManVer1.1/GameBoyProgManVer1.1.pdf
extension Cpu {

  // MARK: - 8-Bit Transfer and Input/Output Instructions

  /// Loads the contents of register r' into register r.
  internal func ld_r_r(_ r0: SingleRegister, _ r1: SingleRegister) -> Int {
    let value = self.registers.get(r1)
    self.registers.set(r0, to: value)

    self.pc += 1
    return 4
  }

  /// Loads 8-bit immediate data n into register r.
  internal func ld_r_d8(_ r: SingleRegister, _ n: UInt8) -> Int {
    self.registers.set(r, to: n)

    self.pc += 2
    return 8
  }

  /// Loads the contents of memory (8 bits) specified by register pair HL into register r.
  internal func ld_r_pHL(_ r: SingleRegister) -> Int {
    let n = self.read(self.registers.hl)
    self.registers.set(r, to: n)

    self.pc += 1
    return 8
  }

  /// Stores the contents of register r in memory specified by register pair HL.
  internal func ld_pHL_r(_ r: SingleRegister) -> Int {
    let n = self.registers.get(r)
    let hl = self.registers.hl
    self.write(hl, value: n)

    self.pc += 1
    return 8
  }

  /// Loads 8-bit immediate data n into memory specified by register pair HL.
  internal func ld_pHL_d8(_ n: UInt8) -> Int {
    let hl = self.registers.hl
    self.write(hl, value: n)

    self.pc += 2
    return 12
  }

  /// Loads the contents specified by the contents of register pair BC into register A.
  internal func ld_a_pBC() -> Int {
    let bc = self.registers.bc
    self.registers.a = self.read(bc)

    self.pc += 1
    return 8
  }

  /// Loads the contents specified by the contents of register pair DE into register A.
  internal func ld_a_pDE() -> Int {
    let de = self.registers.de
    self.registers.a = self.read(de)

    self.pc += 1
    return 8
  }

  /// Loads into register A the contents of the internal RAM, port register,
  /// or mode register at the address in the range FF00h-FFFFh specified by register C.
  internal func ld_a_ffC() -> Int {
    let address = UInt16(0xff00) + UInt16(self.registers.c)
    self.registers.a = self.read(address)

    self.pc += 1
    return 8
  }

  /// Loads the contents of register A in the internal RAM, port register,
  /// or mode register at the address in the range FF00h-FFFFh specified by register C.
  internal func ld_ffC_a() -> Int {
    let a = self.registers.a
    let address = UInt16(0xff00) + UInt16(self.registers.c)
    self.write(address, value: a)

    self.pc += 1
    return 8
  }

  /// Loads into register A the contents of the internal RAM, port register, or mode register
  /// at the address in the range FF00h-FFFFh specified by the 8-bit immediate operand n.
  internal func ld_a_pA8(_ n: UInt8) -> Int {
    let addr = 0xff00 | UInt16(n)
    self.registers.a = self.read(addr)

    self.pc += 2
    return 12
  }

  /// Loads the contents of register A to the internal RAM, port register, or mode register
  /// at the address in the range FF00h-FFFFh specified by the 8-bit immediate operand n.
  internal func ld_pA8_a(_ n: UInt8) -> Int {
    let addr = 0xff00 | UInt16(n)
    self.write(addr, value: self.registers.a)

    self.pc += 2
    return 12
  }

  internal func ld_a_pA16(_ nn: UInt16) -> Int {
    self.registers.a = self.read(nn)

    self.pc += 3
    return 16
  }

  internal func ld_pA16_a(_ nn: UInt16) -> Int {
    self.write(nn, value: self.registers.a)

    self.pc += 3
    return 16
  }

  /// Loads in register A the contents of memory specified by the contents of register pair HL
  /// and simultaneously increments the contents of HL.
  internal func ld_a_pHLI() -> Int {
    let hl = self.registers.hl
    self.registers.a = self.read(hl)

    let (newHL, _) = hl.addingReportingOverflow(1)
    self.registers.hl = newHL

    self.pc += 1
    return 8
  }

  /// Loads in register A the contents of memory specified by the contents of register pair HL
  /// and simultaneously decrements the contents of HL.
  internal func ld_a_pHLD() -> Int {
    let hl = self.registers.hl
    self.registers.a = self.read(hl)

    let (newHL, _) = hl.subtractingReportingOverflow(1)
    self.registers.hl = newHL

    self.pc += 1
    return 8
  }

  /// Stores the contents of register A in the memory specified by register pair BC.
  internal func ld_pBC_a() -> Int {
    let a = self.registers.a
    let bc = self.registers.bc
    self.write(bc, value: a)

    self.pc += 1
    return 8
  }

  /// Stores the contents of register A in the memory specified by register pair DE.
  internal func ld_pDE_a() -> Int {
    let a = self.registers.a
    let de = self.registers.de
    self.write(de, value: a)

    self.pc += 1
    return 8
  }

  /// Stores the contents of register A in the memory specified by register pair HL
  /// and simultaneously increments the contents of HL.
  internal func ld_pHLI_a() -> Int {
    let a = self.registers.a
    let hl = self.registers.hl
    self.write(hl, value: a)

    let (newHL, _) = hl.addingReportingOverflow(1)
    self.registers.hl = newHL

    self.pc += 1
    return 8
  }

  /// Stores the contents of register A in the memory specified by register pair HL
  /// and simultaneously decrements the contents of HL.
  internal func ld_pHLD_a() -> Int {
    let a = self.registers.a
    let hl = self.registers.hl
    self.write(hl, value: a)

    let (newHL, _) = hl.subtractingReportingOverflow(1)
    self.registers.hl = newHL

    self.pc += 1
    return 8
  }

  // MARK: - 16-Bit Transfer Instructions

  /// Loads 2 bytes of immediate data to register pair dd.
  internal func ld_rr_d16(_ rr: CombinedRegister, _ nn: UInt16) -> Int {
    self.registers.set(rr, to: nn)

    self.pc += 3
    return 12
  }

  /// Loads 2 bytes of immediate data to register pair dd.
  internal func ld_sp_d16(_ nn: UInt16) -> Int {
    self.sp = nn

    self.pc += 3
    return 12
  }

  /// Loads the contents of register pair HL in stack pointer SP.
  internal func ld_sp_hl() -> Int {
    self.sp = self.registers.hl

    self.pc += 1
    return 8
  }

  /// Pushes the contents of register pair qq onto the memory stack.
  /// First 1 is substracted from SP and the contents of the higher portion of qq are placed on the stack.
  /// The contents of the lower portion of qq are then placed on the stack.
  /// The contents of SP are automatically decremented by 2.
  internal func push(_ rr: CombinedRegister) -> Int {
    let nn = self.registers.get(rr)
    self.push16(nn)

    self.pc += 1
    return 16
  }

  /// Pops contents from the memory stack and into register pair qq.
  /// First the contents of memory specified by the contents of SP are loaded in the lower portion of qq.
  /// Next, the contents of SP are incremented by 1 and the contents of the memory they specify are loaded in the upper portion of qq.
  /// The contents of SP are automatically incremented by 2.
  internal func pop(_ rr: CombinedRegister) -> Int {
    let nn = self.pop16()
    self.registers.set(rr, to: nn)

    self.pc += 1
    return 12
  }

  /// The 8-bit operand e is added to SP and the result is stored in HL.
  internal func ldhl_sp_plus_e(_ n: UInt8) -> Int {
    let sigN = Int(Int8(bitPattern: n))
    let sp = Int(self.sp)

    self.registers.zeroFlag = false
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = (sigN &  0xf) + (sp &  0xf) >  0xf
    self.registers.carryFlag     = (sigN & 0xff) + (sp & 0xff) > 0xff

    let newValue = sp + sigN
    self.registers.hl = UInt16(newValue & 0xffff)

    self.pc += 2
    return 12
  }

  /// Stores the lower byte of SP at address nn specified by the 16-bit
  /// immediate operand nn and the upper byte of SP at address nn + 1.
  internal func ld_pA16_sp(_ nn: UInt16) -> Int {
    let low = UInt8(self.sp & 0xff)
    self.write(nn, value: low)

    let high = UInt8(self.sp >> 8)
    self.write(nn + 1, value: high)

    self.pc += 3
    return 20
  }

  // MARK: - 8-Bit Arithmetic and Logical Operation Instructions

  // MARK: Add

  /// Adds the contents of register r to those of register A
  /// and stores the results in register A.
  internal func add_a_r(_ r: SingleRegister) -> Int {
    self.add_a(self.registers.get(r))

    self.pc += 1
    return 4
  }

  /// Adds 8-bit immediate operand n to the contents of register A
  /// and stores the results in register A.
  internal func add_a_d8(_ n: UInt8) -> Int {
    self.add_a(n)

    self.pc += 2
    return 8
  }

  /// Adds the contents of memory specified by the contents of register pair HL
  /// to the contents of register A and stores the results in register A
  internal func add_a_pHL() -> Int {
    let value = self.read(self.registers.hl)
    self.add_a(value)

    self.pc += 1
    return 8
  }

  private func add_a(_ n: UInt8) {
    let a = self.registers.a
    let (newValue, overflow) = a.addingReportingOverflow(n)

    self.registers.zeroFlag = newValue == 0
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = (a & 0xf) + (n & 0xf) > 0xf
    self.registers.carryFlag = overflow

    self.registers.a = newValue
  }

  /// Adds the contents of register pair ss to the contents of register pair HL
  /// and stores the results in HL.
  internal func add_hl_r(_ r: CombinedRegister) -> Int {
    self.add_hl(self.registers.get(r))

    self.pc += 1
    return 8
  }

  /// Adds the contents of register pair ss to the contents of register pair HL
  /// and stores the results in HL.
  internal func add_hl_sp() -> Int {
    self.add_hl(self.sp)

    self.pc += 1
    return 8
  }

  private func add_hl(_ n: UInt16) {
    let hl = self.registers.hl
    let (newValue, overflow) = hl.addingReportingOverflow(n)

    // zeroFlag - not affected
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = (hl & 0xfff) + (n & 0xfff) > 0xfff
    self.registers.carryFlag = overflow

    self.registers.hl = newValue
  }

  /// Adds the contents of the 8-bit immediate operand e and SP and stores the results in SP.
  internal func add_sp_r8(_ n: UInt8) -> Int {
    let sp = Int(self.sp)
    let nn = Int(Int8(bitPattern: n))

    self.registers.zeroFlag = false
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = (sp &  0xf) + (nn &  0xf) >  0xf
    self.registers.carryFlag     = (sp & 0xff) + (nn & 0xff) > 0xff

    let newValue = sp + nn
    self.sp = UInt16(newValue & 0xffff)

    self.pc += 2
    return 16
  }

  // MARK: Adc

  /// Adds the contents of operand s and CY to the contents of register A
  /// and stores the results in register A.. r, n, and (HL) are used for operand s.
  internal func adc_a_r(_ r: SingleRegister) -> Int {
    self.adc_a(self.registers.get(r))

    self.pc += 1
    return 4
  }

  /// Adds the contents of operand s and CY to the contents of register A
  /// and stores the results in register A.. r, n, and (HL) are used for operand s.
  internal func adc_a_d8(_ n: UInt8) -> Int {
    self.adc_a(n)

    self.pc += 2
    return 8
  }

  /// Adds the contents of operand s and CY to the contents of register A
  /// and stores the results in register A.. r, n, and (HL) are used for operand s.
  internal func adc_a_pHL() -> Int {
    self.adc_a(self.read(self.registers.hl))

    self.pc += 1
    return 8
  }

  private func adc_a(_ n: UInt8) {
    let a = self.registers.a
    let cy: UInt8 = self.registers.carryFlag ? 1 : 0

    let (newValue1, overflow1) = a.addingReportingOverflow(n)
    let (newValue2, overflow2) = newValue1.addingReportingOverflow(cy)

    self.registers.zeroFlag = newValue2 == 0
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = (a & 0xf) + (n & 0xf) + (cy & 0xf) > 0xf
    self.registers.carryFlag = overflow1 || overflow2

    self.registers.a = newValue2
  }

  // MARK: Sub

  /// Subtracts the contents of operand s from the contents of register A
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  internal func sub_a_r(_ r: SingleRegister) -> Int {
    self.sub_a(self.registers.get(r))

    self.pc += 1
    return 4
  }

  /// Subtracts the contents of operand s from the contents of register A
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  internal func sub_a_d8(_ n: UInt8) -> Int {
    self.sub_a(n)

    self.pc += 2
    return 8
  }

  /// Subtracts the contents of operand s from the contents of register A
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  internal func sub_a_pHL() -> Int {
    self.sub_a(self.read(self.registers.hl))

    self.pc += 1
    return 8
  }

  private func sub_a(_ n: UInt8) {
    let a = self.registers.a

    let (newValue, overflow) = a.subtractingReportingOverflow(n)
    let (_, halfCarry) = (a & 0xf).subtractingReportingOverflow(n & 0xf)

    self.registers.zeroFlag = newValue == 0
    self.registers.subtractFlag = true
    self.registers.halfCarryFlag = halfCarry
    self.registers.carryFlag = overflow

    self.registers.a = newValue
  }

  // MARK: Sbc

  /// Subtracts the contents of operand s and CY from the contents of register A
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  internal func sbc_a_r(_ r: SingleRegister) -> Int {
    self.sbc_a(self.registers.get(r))

    self.pc += 1
    return 4
  }

  /// Subtracts the contents of operand s and CY from the contents of register A
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  internal func sbc_a_d8(_ n: UInt8) -> Int {
    self.sbc_a(n)

    self.pc += 2
    return 8
  }

  /// Subtracts the contents of operand s and CY from the contents of register A
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  internal func sbc_a_pHL() -> Int {
    self.sbc_a(self.read(self.registers.hl))

    self.pc += 1
    return 8
  }

  private func sbc_a(_ n: UInt8) {
    let a = self.registers.a
    let cy: UInt8 = self.registers.carryFlag ? 1 : 0

    let (newValue1, overflow1) = a.subtractingReportingOverflow(n)
    let (newValue2, overflow2) = newValue1.subtractingReportingOverflow(cy)

    let (halfValue, halfCarry1) = (a & 0xf).subtractingReportingOverflow(n & 0xf)
    let (_, halfCarry2) = halfValue.subtractingReportingOverflow(cy & 0xf)

    self.registers.zeroFlag = newValue2 == 0
    self.registers.subtractFlag = true
    self.registers.halfCarryFlag = halfCarry1 || halfCarry2
    self.registers.carryFlag = overflow1 || overflow2

    self.registers.a = newValue2
  }

  // MARK: Cp

  /// Compares the contents of operand s and register A
  /// and sets the flag if they are equal. r, n, and (HL) are used for operand s.
  internal func cp_a_r(_ r: SingleRegister) -> Int {
    self.cp_a(self.registers.get(r))

    self.pc += 1
    return 4
  }

  /// Compares the contents of operand s and register A
  /// and sets the flag if they are equal. r, n, and (HL) are used for operand s.
  internal func cp_a_d8(_ n: UInt8) -> Int {
    self.cp_a(n)

    self.pc += 2
    return 8
  }

  /// Compares the contents of operand s and register A
  /// and sets the flag if they are equal. r, n, and (HL) are used for operand s.
  internal func cp_a_pHL() -> Int {
    self.cp_a(self.read(self.registers.hl))

    self.pc += 1
    return 8
  }

  /// Basically sub, but without storing result
  private func cp_a(_ n: UInt8) {
    let a = self.registers.a

    let (newValue, overflow) = a.subtractingReportingOverflow(n)
    let (_, halfCarry) = (a & 0xf).subtractingReportingOverflow(n & 0xf)

    self.registers.zeroFlag = newValue == 0
    self.registers.subtractFlag = true
    self.registers.halfCarryFlag = halfCarry
    self.registers.carryFlag = overflow
  }

  // MARK: Inc

  /// Increments the contents of register r by 1.
  internal func inc_r(_ r: SingleRegister) -> Int {
    let n = self.registers.get(r)
    let (newValue, _) = n.addingReportingOverflow(1)

    self.registers.zeroFlag = newValue == 0
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = (n & 0xf) + 0x1 > 0xf
    // carryFlag - not affected

    self.registers.set(r, to: newValue)

    self.pc += 1
    return 4
  }

  /// Increments the contents of register pair ss by 1.
  internal func inc_rr(_ r: CombinedRegister) -> Int {
    let n = self.registers.get(r)
    let (newValue, _) = n.addingReportingOverflow(1)
    // flags affected: none
    self.registers.set(r, to: newValue)

    self.pc += 1
    return 8
  }

  /// Increments by 1 the contents of memory specified by register pair HL.
  internal func inc_pHL() -> Int {
    let hl = self.registers.hl
    let n = self.read(hl)

    let (newValue, _) = n.addingReportingOverflow(1)

    self.registers.zeroFlag = newValue == 0
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = (n & 0xf) + 0x1 > 0xf
    // carryFlag - not affected

    self.write(hl, value: newValue)

    self.pc += 1
    return 12
  }

  /// Increments the contents of register pair ss by 1.
  internal func inc_sp() -> Int {
    let (newValue, _) = self.sp.addingReportingOverflow(1)
    // flags affected: none
    self.sp = newValue

    self.pc += 1
    return 8
  }

  // MARK: Dec

  /// Subtract 1 from the contents of register r by 1.
  internal func dec_r(_ r: SingleRegister) -> Int {
    let n = self.registers.get(r)

    let (newValue, _) = n.subtractingReportingOverflow(1)
    let (_, halfCarry) = (n & 0xf).subtractingReportingOverflow(1)

    self.registers.zeroFlag = newValue == 0
    self.registers.subtractFlag = true
    self.registers.halfCarryFlag = halfCarry
    // carryFlag - not affected

    self.registers.set(r, to: newValue)

    self.pc += 1
    return 4
  }

  /// Decrements the contents of register pair ss by 1.
  internal func dec_rr(_ r: CombinedRegister) -> Int {
    let n = self.registers.get(r)
    let (newValue, _) = n.subtractingReportingOverflow(1)
    // flags affected: none
    self.registers.set(r, to: newValue)

    self.pc += 1
    return 8
  }

  /// Decrements by 1 the contents of memory specified by register pair HL.
  internal func dec_pHL() -> Int {
    let hl = self.registers.hl
    let n = self.read(hl)

    let (newValue, _) = n.subtractingReportingOverflow(1)
    let (_, halfCarry) = (n & 0xf).subtractingReportingOverflow(1)

    self.registers.zeroFlag = newValue == 0
    self.registers.subtractFlag = true
    self.registers.halfCarryFlag = halfCarry
    // carryFlag - not affected

    self.write(hl, value: newValue)

    self.pc += 1
    return 12
  }

  /// Decrements the contents of register pair ss by 1.
  internal func dec_sp() -> Int {
    let (newValue, _) = self.sp.subtractingReportingOverflow(1)
    // flags affected: none
    self.sp = newValue

    self.pc += 1
    return 8
  }

  // MARK: And

  /// Takes the logical-AND for each bit of the contents of operand s and register A,
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  internal func and_a_r(_ r: SingleRegister) -> Int {
    self.and_a(self.registers.get(r))

    self.pc += 1
    return 4
  }

  /// Takes the logical-AND for each bit of the contents of operand s and register A,
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  internal func and_a_d8(_ n: UInt8) -> Int {
    self.and_a(n)

    self.pc += 2
    return 8
  }

  /// Takes the logical-AND for each bit of the contents of operand s and register A,
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  internal func and_a_pHL() -> Int {
    self.and_a(self.read(self.registers.hl))

    self.pc += 1
    return 8
  }

  private func and_a(_ n: UInt8) {
    let a = self.registers.a
    let newValue = a & n

    self.registers.zeroFlag = newValue == 0
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = true
    self.registers.carryFlag = false

    self.registers.a = newValue
  }

  // MARK: Or

  /// Takes the logical-OR for each bit of the contents of operand s and register A
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  internal func or_a_r(_ r: SingleRegister) -> Int {
    self.or_a(self.registers.get(r))

    self.pc += 1
    return 4
  }

  /// Takes the logical-OR for each bit of the contents of operand s and register A
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  internal func or_a_d8(_ n: UInt8) -> Int {
    self.or_a(n)

    self.pc += 2
    return 8
  }

  /// Takes the logical-OR for each bit of the contents of operand s and register A
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  internal func or_a_pHL() -> Int {
    self.or_a(self.read(self.registers.hl))

    self.pc += 1
    return 8
  }

  private func or_a(_ n: UInt8) {
    let a = self.registers.a
    let newValue = a | n

    self.registers.zeroFlag = newValue == 0
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = false
    self.registers.carryFlag = false

    self.registers.a = newValue
  }

  // MARK: Xor

  /// Takes the logical exclusive-OR for each bit of the contents of operand s and register A.
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  internal func xor_a_r(_ r: SingleRegister) -> Int {
    self.xor_a(self.registers.get(r))

    self.pc += 1
    return 4
  }

  /// Takes the logical exclusive-OR for each bit of the contents of operand s and register A.
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  internal func xor_a_d8(_ n: UInt8) -> Int {
    self.xor_a(n)

    self.pc += 2
    return 8
  }

  /// Takes the logical exclusive-OR for each bit of the contents of operand s and register A.
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  internal func xor_a_pHL() -> Int {
    self.xor_a(self.read(self.registers.hl))

    self.pc += 1
    return 8
  }

  private func xor_a(_ n: UInt8) {
    let a = self.registers.a
    let newValue = a ^ n

    self.registers.zeroFlag = newValue == 0
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = false
    self.registers.carryFlag = false

    self.registers.a = newValue
  }

  // MARK: - Rotate Shift Instructions

  // MARK: Rotate left

  /// Rotates the contents of register A to the left.
  internal func rlca() -> Int {
    let a = self.registers.a

    let carry = a >> 7
    let newValue = (a << 1) | carry

    self.registers.zeroFlag = false
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = false
    self.registers.carryFlag = carry == 0x1

    self.registers.a = newValue

    self.pc += 1
    return 4
  }

  /// Rotates the contents of register A to the left.
  internal func rla() -> Int {
    let a = self.registers.a

    let carry = a >> 7
    let newValue = (a << 1) | (self.registers.carryFlag ? 0x1 : 0x0)

    self.registers.zeroFlag = false
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = false
    self.registers.carryFlag = carry == 0x1

    self.registers.a = newValue

    self.pc += 1
    return 4
  }

  // MARK: Rotate right

  /// Rotates the contents of register A to the right.
  internal func rrca() -> Int {
    let a = self.registers.a

    let carry = a & 0x1
    let newValue = (a >> 1) | (carry << 7)

    self.registers.zeroFlag = false
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = false
    self.registers.carryFlag = carry == 0x1

    self.registers.a = newValue

    self.pc += 1
    return 4
  }

  /// Rotates the contents of register A to the right.
  internal func rra() -> Int {
    let a = self.registers.a

    let carry = a & 0x1
    let newValue = (a >> 1) | (self.registers.carryFlag ? 0b10000000 : 0x0)

    self.registers.zeroFlag = false
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = false
    self.registers.carryFlag = carry == 0x1

    self.registers.a = newValue

    self.pc += 1
    return 4
  }

  // MARK: Prefix rotate left

  /// Rotates the contents of operand m to the left. r and (HL) are used for operand m.
  internal func rlc_r(_ r: SingleRegister) -> Int {
    let n = self.registers.get(r)
    self.registers.set(r, to: self.rlc(n))

    self.pc += 2
    return 8
  }

  /// Rotates the contents of operand m to the left. r and (HL) are used for operand m.
  internal func rlc_pHL() -> Int {
    let hl = self.registers.hl
    let n = self.read(hl)
    self.write(hl, value: self.rlc(n))

    self.pc += 2
    return 16
  }

  private func rlc(_ n: UInt8) -> UInt8 {
    let carry = n >> 7
    let newValue = (n << 1) | carry

    self.registers.zeroFlag = newValue == 0
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = false
    self.registers.carryFlag = carry == 0x1

    return newValue
  }

  /// Rotates the contents of operand m to the left. r and (HL) are used for operand m.
  internal func rl_r(_ r: SingleRegister) -> Int {
    let n = self.registers.get(r)
    self.registers.set(r, to: self.rl(n))

    self.pc += 2
    return 8
  }

  /// Rotates the contents of operand m to the left. r and (HL) are used for operand m.
  internal func rl_pHL() -> Int {
    let hl = self.registers.hl
    let n = self.read(hl)
    self.write(hl, value: self.rl(n))

    self.pc += 2
    return 16
  }

  private func rl(_ n: UInt8) -> UInt8 {
    let newCarry = n >> 7
    let newValue = (n << 1) | (self.registers.carryFlag ? 0x1 : 0x0)

    self.registers.zeroFlag = newValue == 0
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = false
    self.registers.carryFlag = newCarry == 0x1

    return newValue
  }

  // MARK: Prefix rotate right

  /// Rotates the contents of operand m to the right. r and (HL) are used for operand m.
  internal func rrc_r(_ r: SingleRegister) -> Int {
    let n = self.registers.get(r)
    self.registers.set(r, to: self.rrc(n))

    self.pc += 2
    return 8
  }

  /// Rotates the contents of operand m to the right. r and (HL) are used for operand m.
  internal func rrc_pHL() -> Int {
    let hl = self.registers.hl
    let n = self.read(hl)
    self.write(hl, value: self.rrc(n))

    self.pc += 2
    return 16
  }

  private func rrc(_ n: UInt8) -> UInt8 {
    let carry = n & 0x01
    let newValue = (n >> 1) | (carry << 7)

    self.registers.zeroFlag = newValue == 0
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = false
    self.registers.carryFlag = carry == 0x1

    return newValue
  }

  /// Rotates the contents of operand m to the right. r and (HL) are used for operand m.
  internal func rr_r(_ r: SingleRegister) -> Int {
    let n = self.registers.get(r)
    self.registers.set(r, to: self.rr(n))

    self.pc += 2
    return 8
  }

  /// Rotates the contents of operand m to the right. r and (HL) are used for operand m.
  internal func rr_pHL() -> Int {
    let hl = self.registers.hl
    let n = self.read(hl)
    self.write(hl, value: self.rr(n))

    self.pc += 2
    return 16
  }

  private func rr(_ n: UInt8) -> UInt8 {
    let newCarry = n & 0x1
    let newValue = (n >> 1) | (self.registers.carryFlag ? (1 << 7) : 0x0)

    self.registers.zeroFlag = newValue == 0
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = false
    self.registers.carryFlag = newCarry == 0x1

    return newValue
  }

  // MARK: Shift

  /// Shifts the contents of operand m to the left.
  internal func sla_r(_ r: SingleRegister) -> Int {
    let n = self.registers.get(r)
    self.registers.set(r, to: self.sla(n))

    self.pc += 2
    return 8
  }

  /// Shifts the contents of operand m to the left.
  internal func sla_pHL() -> Int {
    let hl = self.registers.hl
    let n = self.read(hl)
    self.write(hl, value: self.sla(n))

    self.pc += 2
    return 16
  }

  private func sla(_ n: UInt8) -> UInt8 {
    let carry = n >> 7
    let newValue = (n << 1)

    self.registers.zeroFlag = newValue == 0
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = false
    self.registers.carryFlag = carry == 0x1

    return newValue
  }

  /// Shifts the contents of operand m to the right.
  internal func sra_r(_ r: SingleRegister) -> Int {
    let n = self.registers.get(r)
    self.registers.set(r, to: self.sra(n))

    self.pc += 2
    return 8
  }

  /// Shifts the contents of operand m to the right.
  internal func sra_pHL() -> Int {
    let hl = self.registers.hl
    let n = self.read(hl)
    self.write(hl, value: self.sra(n))

    self.pc += 2
    return 16
  }

  private func sra(_ n: UInt8) -> UInt8 {
    let carry = n & 0x01
    let newValue = (n >> 1) | (n & 0x80)

    self.registers.zeroFlag = newValue == 0
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = false
    self.registers.carryFlag = carry == 0x1

    return newValue
  }

  /// Shifts the contents of operand m to the right.
  internal func srl_r(_ r: SingleRegister) -> Int {
    let n = self.registers.get(r)
    self.registers.set(r, to: self.srl(n))

    self.pc += 2
    return 8
  }

  /// Shifts the contents of operand m to the right.
  internal func srl_pHL() -> Int {
    let hl = self.registers.hl
    let n = self.read(hl)
    self.write(hl, value: self.srl(n))

    self.pc += 2
    return 16
  }

  private func srl(_ n: UInt8) -> UInt8 {
    let carry = n & 0x01
    let newValue = (n >> 1)

    self.registers.zeroFlag = newValue == 0
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = false
    self.registers.carryFlag = carry == 0x1

    return newValue
  }

  // MARK: Swap

  /// Shifts the contents of operand m to the right.
  internal func swap_r(_ r: SingleRegister) -> Int {
    let n = self.registers.get(r)
    self.registers.set(r, to: self.swap(n))

    self.pc += 2
    return 8
  }

  /// Shifts the contents of operand m to the right.
  internal func swap_pHL() -> Int {
    let hl = self.registers.hl
    let n = self.read(hl)
    self.write(hl, value: self.swap(n))

    self.pc += 2
    return 16
  }

  private func swap(_ n: UInt8) -> UInt8 {
    let newValue = (n << 4) | (n >> 4)

    self.registers.zeroFlag = newValue == 0
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = false
    self.registers.carryFlag = false

    return newValue
  }

  // MARK: - Bit Operations

  // MARK: Bit

  /// Copies the complement of the contents of the specified bit
  /// in register r to the Z flag of the program status word (PSW).
  internal func bit_r(_ b: UInt8, _ r: SingleRegister) -> Int {
    let n = self.registers.get(r)
    self.bit(b, n)

    self.pc += 2
    return 8
  }

  /// Copies the complement of the contents of the specified bit
  /// in memory specified by the contents of register pair HL
  /// to the Z flag of the program status word (PSW).
  internal func bit_pHL(_ b: UInt8) -> Int {
    let n = self.read(self.registers.hl)
    self.bit(b, n)

    self.pc += 2
    return 12
  }

  private func bit(_ b: UInt8, _ n: UInt8) {
    let mask: UInt8 = 0x1 << b

    // Remember that this is complement!
    self.registers.zeroFlag = (n & mask) != mask
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = true
    // carryFlag - not affected
  }

  // MARK: Set

  /// Sets to 1 the specified bit in specified register r.
  internal func set_r(_ b: UInt8, _ r: SingleRegister) -> Int {
    let n = self.registers.get(r)
    self.registers.set(r, to: self.set(b, n))

    self.pc += 2
    return 8
  }

  /// Sets to 1 the specified bit in the memory contents specified by registers H and L.
  internal func set_pHL(_ b: UInt8) -> Int {
    let hl = self.registers.hl
    let n = self.read(hl)
    self.write(hl, value: self.set(b, n))

    self.pc += 2
    return 16
  }

  private func set(_ b: UInt8, _ n: UInt8) -> UInt8 {
    return n | (0x1 << b)
  }

  // MARK: Reset

  /// Resets to 0 the specified bit in the specified register r.
  internal func res_r(_ b: UInt8, _ r: SingleRegister) -> Int {
    let n = self.registers.get(r)
    self.registers.set(r, to: self.res(b, n))

    self.pc += 2
    return 8
  }

  /// Resets to 0 the specified bit in the memory contents specified by registers H and L.
  internal func res_pHL(_ b: UInt8) -> Int {
    let hl = self.registers.hl
    let n = self.read(hl)
    self.write(hl, value: self.res(b, n))

    self.pc += 2
    return 16
  }

  private func res(_ b: UInt8, _ n: UInt8) -> UInt8 {
    return n & ~(0x1 << b)
  }

  // MARK: - Jump Instructions

  // MARK: JP

  /// Loads the operand nn to the program counter (PC).
  /// nn specifies the address of the subsequently executed instruction.
  internal func jp_nn(_ nn: UInt16) -> Int {
    self.pc = nn
    return 16
  }

  /// Loads operand nn in the PC if condition cc and the flag status match.
  internal func jp_cc_nn(_ condition: JumpCondition, _ nn: UInt16) -> Int {
    if self.canJump(condition) {
      self.pc = nn
      return 16
    } else {
      self.pc += 3
      return 12
    }
  }

  /// Loads the contents of register pair HL in program counter PC.
  internal func jp_pHL() -> Int {
    self.pc = self.registers.hl
    return 4
  }

  // MARK: JR

  /// Jumps -127 to +129 steps from the current address.
  internal func jr_e(_ e: UInt8) -> Int {
    self.jr(e)
    return 12
  }

  /// If condition cc and the flag status match, jumps -127 to +129 steps from the current address.
  internal func jr_cc_e(_ condition: JumpCondition, _ e: UInt8) -> Int {
    if self.canJump(condition) {
      self.jr(e)
      return 12
    } else {
      self.pc += 2
      return 8
    }
  }

  private func jr(_ e: UInt8) {
    let offset = Int8(bitPattern: e)

    // Current address is the address for the instruction after jr
    let length = Int(2)
    let pc = Int(self.pc) + length + Int(offset)
    self.pc = UInt16(pc)
  }

  private func canJump(_ condition: JumpCondition) -> Bool {
    switch condition {
    case .nz: return !self.registers.zeroFlag
    case .z:  return  self.registers.zeroFlag
    case .nc: return !self.registers.carryFlag
    case .c:  return  self.registers.carryFlag
    }
  }

  // MARK: - Call and Return Instructions

  // MARK: Call

  /// Pushes the PC value corresponding to the instruction at the address following that of the
  /// CALL instruction to the 2 bytes following the byte specified by the current SP.
  /// Operand nn is then loaded in the PC.
  internal func call_a16(_ nn: UInt16) -> Int {
    self.call(nn)
    return 24
  }

  /// If condition cc matches the flag, the PC value corresponding to the instruction following the
  /// CALL instruction in memory is pushed to the 2 bytes following the memory byte specified by the SP.
  /// Operand nn is then loaded in the PC.
  internal func call_cc_a16(_ condition: JumpCondition, _ nn: UInt16) -> Int {
    if self.canJump(condition) {
      self.call(nn)
      return 24
    } else {
      self.pc += 3
      return 12
    }
  }

  private func call(_ nn: UInt16) {
    let length = UInt16(3) // the same for both 'call'
    let returnAddr = self.pc + length
    self.push16(returnAddr)

    self.pc = nn
  }

  // MARK: Ret

  /// Pops from the memory stack the PC value pushed when the
  /// subroutine was called, returning control to the source program.
  internal func ret() -> Int {
    self.retShared()
    return 16
  }

  /// If condition cc and the flag match, control is returned
  /// to the source program by popping from the memory stack
  /// the PC value pushed to the stack when the subroutine was called.
  internal func ret_cc(_ condition: JumpCondition) -> Int {
    if self.canJump(condition) {
      self.retShared()
      return 20
    } else {
      self.pc += 1
      return 8
    }
  }

  private func retShared() {
    self.pc = self.pop16()
  }

  /// The address for the return from the interrupt is loaded in program counter PC.
  /// The master interrupt enable flag is returned to its pre-interrupt status.
  internal func reti() -> Int {
    self.pc = self.pop16()
    self.enableInterrupts()
    return 16
  }

  // MARK: Rst

  /// Pushes the current value of the PC to the memory stack and loads to the PC
  /// the page 0 memory addresses provided by operand t.
  /// Then next instruction is fetched from the address specified by the new content of PC.
  internal func rst(_ t: UInt8) -> Int {
    let length = UInt16(1)
    let returnAddr = self.pc + length
    self.push16(returnAddr)

    self.pc = UInt16(t)
    return 16
  }

  // MARK: - General-Purpose Arithmetic Operations and CPU Control Instructions

  /// Only advances the program counter by 1;
  /// performs no other operations that have an effect.
  internal func nop() -> Int {
    self.pc += 1
    return 4
  }

  /// Stop, blank the screen and wait for button press
  internal func stop() -> Int {
    fatalError("Stop is not implemented!")

    //    self.pc += 1 // or maybe 2 as in docs?
    //    return 4
  }

  /// The program counter is halted at the step after the HALT instruction.
  /// If both the interrupt request flag and the corresponding interrupt enable flag are set,
  /// HALT mode is exited, even if the interrupt master enable flag is not set.
  internal func halt() -> Int {
    self.isHalted = true
    self.pc += 1
    return 0
  }

  internal func daa() -> Int {
    var a = self.registers.a

    var adjust: UInt8 = 0
    adjust |= self.registers.carryFlag     ? 0x60 : 0x00
    adjust |= self.registers.halfCarryFlag ? 0x06 : 0x00

    if self.registers.subtractFlag {
      a &-= adjust
    } else {
      if  a         > 0x99 { adjust |= 0x60 }
      if (a & 0x0f) > 0x09 { adjust |= 0x06 }

      a &+= adjust
    }

    self.registers.zeroFlag = a == 0
    self.registers.halfCarryFlag = false
    self.registers.carryFlag = adjust >= 0x60

    self.registers.a = a

    self.pc += 1
    return 4
  }

  /// Takes the one’s complement of the contents of register A.
  internal func cpl() -> Int {
    self.registers.a = ~self.registers.a

    self.registers.subtractFlag = true
    self.registers.halfCarryFlag = true

    self.pc += 1
    return 4
  }

  /// Sets the carry flag CY.
  internal func scf() -> Int {
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = false
    self.registers.carryFlag = true

    self.pc += 1
    return 4
  }

  /// Flips the carry flag CY.
  internal func ccf() -> Int {
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = false
    self.registers.carryFlag.toggle()

    self.pc += 1
    return 4
  }

  /// Resets the interrupt master enable flag and prohibits maskable interrupts.
  internal func di() -> Int {
    self.disableInterrupts()
    self.pc += 1
    return 4
  }

  /// Sets the interrupt master enable flag and enables maskable interrupts.
  /// This instruction can be used in an interrupt routine to enable higher-order interrupts.
  internal func ei() -> Int {
    self.enableInterrupts()
    self.pc += 1
    return 4
  }
}
