// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

internal enum JumpCondition {
  case nz
  case z
  case nc
  case c
}

// This file is massive, but we need it this way so we can easier Cmd+F.
extension Cpu {

  // MARK: - 8-Bit Transfer and Input/Output Instructions

  /// Loads the contents of register r' into register r.
  internal func ld_r_r(_ dst: SingleRegister, _ src: SingleRegister) {
    let value = self.registers.get(src)
    self.registers.set(dst, to: value)
  }

  /// Loads 8-bit immediate data n into register r.
  internal func ld_r_d8(_ r: SingleRegister, _ n: UInt8) {
    self.registers.set(r, to: n)
  }

  /// Loads the contents of memory (8 bits) specified by register pair HL into register r.
  internal func ld_r_pHL(_ r: SingleRegister) {
    let n = self.memory.read(self.registers.hl)
    self.registers.set(r, to: n)
  }

  /// Stores the contents of register r in memory specified by register pair HL.
  internal func ld_pHL_r(_ r: SingleRegister) {
    let n = self.registers.get(r)
    let hl = self.registers.hl
    self.memory.write(hl, value: n)
  }

  /// Loads 8-bit immediate data n into memory specified by register pair HL.
  internal func ld_pHL_d8(_ n: UInt8) {
    let hl = self.registers.hl
    self.memory.write(hl, value: n)
  }

  /// Loads the contents specified by the contents of register pair BC into register A.
  internal func ld_a_pBC() {
    let bc = self.registers.bc
    self.registers.a = self.memory.read(bc)
  }

  /// Loads the contents specified by the contents of register pair DE into register A.
  internal func ld_a_pDE() {
    let de = self.registers.de
    self.registers.a = self.memory.read(de)
  }

  /// Loads into register A the contents of the internal RAM, port register,
  /// or mode register at the address in the range FF00h-FFFFh specified by register C.
  internal func ld_a_ffC() {
    let address = UInt16(0xff00) + UInt16(self.registers.c)
    self.registers.a = self.memory.read(address)
  }

  /// Loads the contents of register A in the internal RAM, port register,
  /// or mode register at the address in the range FF00h-FFFFh specified by register C.
  internal func ld_ffC_a() {
    let a = self.registers.a
    let address = UInt16(0xff00) + UInt16(self.registers.c)
    self.memory.write(address, value: a)
  }

  /// Loads into register A the contents of the internal RAM, port register, or mode register
  /// at the address in the range FF00h-FFFFh specified by the 8-bit immediate operand n.
  internal func ld_a_pA8(_ n: UInt8) {
    let addr = 0xff00 | UInt16(n)
    self.registers.a = self.memory.read(addr)
  }

  /// Loads the contents of register A to the internal RAM, port register, or mode register
  /// at the address in the range FF00h-FFFFh specified by the 8-bit immediate operand n.
  internal func ld_pA8_a(_ n: UInt8) {
    let addr = 0xff00 | UInt16(n)
    self.memory.write(addr, value: self.registers.a)
  }

  internal func ld_a_pA16(_ nn: UInt16) {
    self.registers.a = self.memory.read(nn)
  }

  internal func ld_pA16_a(_ nn: UInt16) {
    self.memory.write(nn, value: self.registers.a)
  }

  /// Loads in register A the contents of memory specified by the contents of register pair HL
  /// and simultaneously increments the contents of HL.
  internal func ld_a_pHLI() {
    let hl = self.registers.hl
    self.registers.a = self.memory.read(hl)

    let (newHL, _) = hl.addingReportingOverflow(1)
    self.registers.hl = newHL
  }

  /// Loads in register A the contents of memory specified by the contents of register pair HL
  /// and simultaneously decrements the contents of HL.
  internal func ld_a_pHLD() {
    let hl = self.registers.hl
    self.registers.a = self.memory.read(hl)

    let (newHL, _) = hl.subtractingReportingOverflow(1)
    self.registers.hl = newHL
  }

  /// Stores the contents of register A in the memory specified by register pair BC.
  internal func ld_pBC_a() {
    let a = self.registers.a
    let bc = self.registers.bc
    self.memory.write(bc, value: a)
  }

  /// Stores the contents of register A in the memory specified by register pair DE.
  internal func ld_pDE_a() {
    let a = self.registers.a
    let de = self.registers.de
    self.memory.write(de, value: a)
  }

  /// Stores the contents of register A in the memory specified by register pair HL
  /// and simultaneously increments the contents of HL.
  internal func ld_pHLI_a() {
    let a = self.registers.a
    let hl = self.registers.hl
    self.memory.write(hl, value: a)

    let (newHL, _) = hl.addingReportingOverflow(1)
    self.registers.hl = newHL
  }

  /// Stores the contents of register A in the memory specified by register pair HL
  /// and simultaneously decrements the contents of HL.
  internal func ld_pHLD_a() {
    let a = self.registers.a
    let hl = self.registers.hl
    self.memory.write(hl, value: a)

    let (newHL, _) = hl.subtractingReportingOverflow(1)
    self.registers.hl = newHL
  }

  // MARK: - 16-Bit Transfer Instructions

  /// Loads 2 bytes of immediate data to register pair dd.
  internal func ld_rr_d16(_ rr: CombinedRegister, _ nn: UInt16) {
    self.registers.set(rr, to: nn)
  }

  /// Loads 2 bytes of immediate data to register pair dd.
  internal func ld_sp_d16(_ nn: UInt16) {
    self.sp = nn
  }

  /// Loads the contents of register pair HL in stack pointer SP.
  internal func ld_sp_hl() {
    self.sp = self.registers.hl
  }

  /// Pushes the contents of register pair qq onto the memory stack.
  /// First 1 is substracted from SP and the contents of the higher portion of qq are placed on the stack.
  /// The contents of the lower portion of qq are then placed on the stack.
  /// The contents of SP are automatically decremented by 2.
  internal func push(_ rr: CombinedRegister) {
    let nn = self.registers.get(rr)
    self.push16(nn)
  }

  /// Pops contents from the memory stack and into register pair qq.
  /// First the contents of memory specified by the contents of SP are loaded in the lower portion of qq.
  /// Next, the contents of SP are incremented by 1 and the contents of the memory they specify are loaded in the upper portion of qq.
  /// The contents of SP are automatically incremented by 2.
  internal func pop(_ rr: CombinedRegister) {
    let nn = self.pop16()
    self.registers.set(rr, to: nn)
  }

  /// The 8-bit operand e is added to SP and the result is stored in HL.
  internal func ld_hl_sp_plus_e(_ n: UInt8) {
    // look at how it was solver in jr
    let e = Int8(n)
    let value = Int(self.sp) + Int(e)

    fatalError("implement half carry for 'ld_hl_sp_plus_e' + enable test")
    self.registers.zeroFlag = false
    self.registers.halfCarryFlag = false
    self.registers.subtractFlag = false
    self.registers.carryFlag = value > 0xffff

    self.registers.hl = UInt16(value & 0xffff)
  }

  /// Stores the lower byte of SP at address nn specified by the 16-bit
  /// immediate operand nn and the upper byte of SP at address nn + 1.
  internal func ld_pA16_sp(_ nn: UInt16) {
    let low = UInt8(self.sp & 0xff)
    self.memory.write(nn, value: low)

    let high = UInt8(self.sp >> 8)
    self.memory.write(nn + 1, value: high)
  }

  // MARK: - 8-Bit Arithmetic and Logical Operation Instructions

  // MARK: Add

  /// Adds the contents of register r to those of register A
  /// and stores the results in register A.
  internal func add_a_r(_ r: SingleRegister) {
    self.add_a(self.registers.get(r))
  }

  /// Adds 8-bit immediate operand n to the contents of register A
  /// and stores the results in register A.
  internal func add_a_d8(_ n: UInt8) {
    self.add_a(n)
  }

  /// Adds the contents of memory specified by the contents of register pair HL
  /// to the contents of register A and stores the results in register A
  internal func add_a_pHL() {
    self.add_a(self.memory.read(self.registers.hl))
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
  internal func add_hl_r(_ r: CombinedRegister) {
    self.add_hl(self.registers.get(r))
  }

  /// Adds the contents of register pair ss to the contents of register pair HL
  /// and stores the results in HL.
  internal func add_hl_sp() {
    self.add_hl(self.sp)
  }

  /// Adds the contents of register pair ss to the contents of register pair HL
  /// and stores the results in HL.
  internal func add_hl(_ n: UInt16) {
    let hl = self.registers.hl
    let (newValue, overflow) = hl.addingReportingOverflow(n)

    // zeroFlag - not affected
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = (hl & 0xfff) + (n & 0xfff) > 0xfff
    self.registers.carryFlag = overflow

    self.registers.hl = newValue
  }

  /// Adds the contents of the 8-bit immediate operand e and SP and stores the results in SP.
  internal func add_sp_r8(_ n: UInt8) {
    let sp = self.sp
    let nn = UInt16(n)
    let (newValue, overflow) = sp.addingReportingOverflow(nn)

    self.registers.zeroFlag = false
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = (sp & 0xf) + (nn & 0xf) > 0xf
    self.registers.carryFlag = overflow

    self.sp = newValue
  }

  // MARK: Adc

  /// Adds the contents of operand s and CY to the contents of register A
  /// and stores the results in register A.. r, n, and (HL) are used for operand s.
  internal func adc_a_r(_ r: SingleRegister) {
    self.adc_a(self.registers.get(r))
  }

  /// Adds the contents of operand s and CY to the contents of register A
  /// and stores the results in register A.. r, n, and (HL) are used for operand s.
  internal func adc_a_d8(_ n: UInt8) {
    self.adc_a(n)
  }

  /// Adds the contents of operand s and CY to the contents of register A
  /// and stores the results in register A.. r, n, and (HL) are used for operand s.
  internal func adc_a_pHL() {
    self.adc_a(self.memory.read(self.registers.hl))
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
  internal func sub_a_r(_ r: SingleRegister) {
    self.sub_a(self.registers.get(r))
  }

  /// Subtracts the contents of operand s from the contents of register A
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  internal func sub_a_d8(_ n: UInt8) {
    self.sub_a(n)
  }

  /// Subtracts the contents of operand s from the contents of register A
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  internal func sub_a_pHL() {
    self.sub_a(self.memory.read(self.registers.hl))
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
  internal func sbc_a_r(_ r: SingleRegister) {
    self.sbc_a(self.registers.get(r))
  }

  /// Subtracts the contents of operand s and CY from the contents of register A
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  internal func sbc_a_d8(_ n: UInt8) {
    self.sbc_a(n)
  }

  /// Subtracts the contents of operand s and CY from the contents of register A
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  internal func sbc_a_pHL() {
    self.sbc_a(self.memory.read(self.registers.hl))
  }

  internal func sbc_a(_ n: UInt8) {
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
  internal func cp_a_r(_ r: SingleRegister) {
    self.cp_a(self.registers.get(r))
  }

  /// Compares the contents of operand s and register A
  /// and sets the flag if they are equal. r, n, and (HL) are used for operand s.
  internal func cp_a_d8(_ n: UInt8) {
    self.cp_a(n)
  }

  /// Compares the contents of operand s and register A
  /// and sets the flag if they are equal. r, n, and (HL) are used for operand s.
  internal func cp_a_pHL() {
    self.cp_a(self.memory.read(self.registers.hl))
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
  internal func inc_r(_ r: SingleRegister) {
    let n = self.registers.get(r)
    let (newValue, _) = n.addingReportingOverflow(1)

    self.registers.zeroFlag = newValue == 0
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = (n & 0xf) + 0x1 > 0xf
    // carryFlag - not affected

    self.registers.set(r, to: newValue)
  }

  /// Increments the contents of register pair ss by 1.
  internal func inc_rr(_ r: CombinedRegister) {
    let n = self.registers.get(r)
    let (newValue, _) = n.addingReportingOverflow(1)
    // flags affected: none
    self.registers.set(r, to: newValue)
  }

  /// Increments by 1 the contents of memory specified by register pair HL.
  internal func inc_pHL() {
    let hl = self.registers.hl
    let n = self.memory.read(hl)

    let (newValue, _) = n.addingReportingOverflow(1)

    self.registers.zeroFlag = newValue == 0
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = (n & 0xf) + 0x1 > 0xf
    // carryFlag - not affected

    self.memory.write(hl, value: newValue)
  }

  /// Increments the contents of register pair ss by 1.
  internal func inc_sp() {
    let (newValue, _) = self.sp.addingReportingOverflow(1)
    // flags affected: none
    self.sp = newValue
  }

  // MARK: Dec

  /// Subtract 1 from the contents of register r by 1.
  internal func dec_r(_ r: SingleRegister) {
    let n = self.registers.get(r)

    let (newValue, _) = n.subtractingReportingOverflow(1)
    let (_, halfCarry) = (n & 0xf).subtractingReportingOverflow(1)

    self.registers.zeroFlag = newValue == 0
    self.registers.subtractFlag = true
    self.registers.halfCarryFlag = halfCarry
    // carryFlag - not affected

    self.registers.set(r, to: newValue)
  }

  /// Decrements the contents of register pair ss by 1.
  internal func dec_rr(_ r: CombinedRegister) {
    let n = self.registers.get(r)
    let (newValue, _) = n.subtractingReportingOverflow(1)
    // flags affected: none
    self.registers.set(r, to: newValue)
  }

  /// Decrements by 1 the contents of memory specified by register pair HL.
  internal func dec_pHL() {
    let hl = self.registers.hl
    let n = self.memory.read(hl)

    let (newValue, _) = n.subtractingReportingOverflow(1)
    let (_, halfCarry) = (n & 0xf).subtractingReportingOverflow(1)

    self.registers.zeroFlag = newValue == 0
    self.registers.subtractFlag = true
    self.registers.halfCarryFlag = halfCarry
    // carryFlag - not affected

    self.memory.write(hl, value: newValue)
  }

  /// Decrements the contents of register pair ss by 1.
  internal func dec_sp() {
    let (newValue, _) = self.sp.subtractingReportingOverflow(1)
    // flags affected: none
    self.sp = newValue
  }

  // MARK: And

  /// Takes the logical-AND for each bit of the contents of operand s and register A,
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  internal func and_a_r(_ r: SingleRegister) {
    self.and_a(self.registers.get(r))
  }

  /// Takes the logical-AND for each bit of the contents of operand s and register A,
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  internal func and_a_d8(_ n: UInt8) {
    self.and_a(n)
  }

  /// Takes the logical-AND for each bit of the contents of operand s and register A,
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  internal func and_a_pHL() {
    self.and_a(self.memory.read(self.registers.hl))
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
  internal func or_a_r(_ r: SingleRegister) {
    self.or_a(self.registers.get(r))
  }

  /// Takes the logical-OR for each bit of the contents of operand s and register A
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  internal func or_a_d8(_ n: UInt8) {
    self.or_a(n)
  }

  /// Takes the logical-OR for each bit of the contents of operand s and register A
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  internal func or_a_pHL() {
    self.or_a(self.memory.read(self.registers.hl))
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
  internal func xor_a_r(_ r: SingleRegister) {
    self.xor_a(self.registers.get(r))
  }

  /// Takes the logical exclusive-OR for each bit of the contents of operand s and register A.
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  internal func xor_a_d8(_ n: UInt8) {
    self.xor_a(n)
  }

  /// Takes the logical exclusive-OR for each bit of the contents of operand s and register A.
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  internal func xor_a_pHL() {
    self.xor_a(self.memory.read(self.registers.hl))
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
  internal func rlca() {
    let a = self.registers.a

    let carry = a >> 7
    let newValue = (a << 1)

    fatalError("possibly: | carry + enable test")

    self.registers.zeroFlag = false
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = false
    self.registers.carryFlag = carry == 0x1

    self.registers.a = newValue
  }

  /// Rotates the contents of register A to the left.
  internal func rla() {
    let a = self.registers.a

    let carry = a >> 7
    let newValue = (a << 1) | (self.registers.carryFlag ? 0x1 : 0x0)

    self.registers.zeroFlag = false
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = false
    self.registers.carryFlag = carry == 0x1

    self.registers.a = newValue
  }

  // MARK: Rotate right

  /// Rotates the contents of register A to the right.
  internal func rrca() {
    let a = self.registers.a

    let carry = a & 0x1
    let newValue = (a >> 1) | (carry << 7)

    self.registers.zeroFlag = false
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = false
    self.registers.carryFlag = carry == 0x1

    self.registers.a = newValue
  }

  /// Rotates the contents of register A to the right.
  internal func rra() {
    let a = self.registers.a

    let carry = a & 0x1
    let newValue = (a >> 1) | (self.registers.carryFlag ? 0x8 : 0x0)

    self.registers.zeroFlag = false
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = false
    self.registers.carryFlag = carry == 0x1

    self.registers.a = newValue
  }

  // MARK: Prefix rotate left

  /// Rotates the contents of operand m to the left. r and (HL) are used for operand m.
  internal func rlc_r(_ r: SingleRegister) {
    let n = self.registers.get(r)
    self.registers.set(r, to: self.rlc(n))
  }

  /// Rotates the contents of operand m to the left. r and (HL) are used for operand m.
  internal func rlc_pHL() {
    let hl = self.registers.hl
    let n = self.memory.read(hl)
    self.memory.write(hl, value: self.rlc(n))
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
  internal func rl_r(_ r: SingleRegister) {
    let n = self.registers.get(r)
    self.registers.set(r, to: self.rl(n))
  }

  /// Rotates the contents of operand m to the left. r and (HL) are used for operand m.
  internal func rl_pHL() {
    let hl = self.registers.hl
    let n = self.memory.read(hl)
    self.memory.write(hl, value: self.rl(n))
  }

  private func rl(_ n: UInt8) -> UInt8 {
    let carry = n >> 7
    let newValue = (n << 1) | (self.registers.carryFlag ? 0x8 : 0x0)

    self.registers.zeroFlag = newValue == 0
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = false
    self.registers.carryFlag = carry == 0x1

    return newValue
  }

  // MARK: Prefix rotate right

  /// Rotates the contents of operand m to the right. r and (HL) are used for operand m.
  internal func rrc_r(_ r: SingleRegister) {
    let n = self.registers.get(r)
    self.registers.set(r, to: self.rrc(n))
  }

  /// Rotates the contents of operand m to the right. r and (HL) are used for operand m.
  internal func rrc_pHL() {
    let hl = self.registers.hl
    let n = self.memory.read(hl)
    self.memory.write(hl, value: self.rrc(n))
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
  internal func rr_r(_ r: SingleRegister) {
    let n = self.registers.get(r)
    self.registers.set(r, to: self.rr(n))
  }

  /// Rotates the contents of operand m to the right. r and (HL) are used for operand m.
  internal func rr_pHL() {
    let hl = self.registers.hl
    let n = self.memory.read(hl)
    self.memory.write(hl, value: self.rr(n))
  }

  private func rr(_ n: UInt8) -> UInt8 {
    let carry = n & 0x01
    let newValue = (n >> 1) | (self.registers.carryFlag ? 0x8 : 0x0)

    self.registers.zeroFlag = newValue == 0
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = false
    self.registers.carryFlag = carry == 0x1

    return newValue
  }

  // MARK: Shift

  /// Shifts the contents of operand m to the left.
  internal func sla_r(_ r: SingleRegister) {
    let n = self.registers.get(r)
    self.registers.set(r, to: self.sla(n))
  }

  /// Shifts the contents of operand m to the left.
  internal func sla_pHL() {
    let hl = self.registers.hl
    let n = self.memory.read(hl)
    self.memory.write(hl, value: self.sla(n))
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
  internal func sra_r(_ r: SingleRegister) {
    let n = self.registers.get(r)
    self.registers.set(r, to: self.sra(n))
  }

  /// Shifts the contents of operand m to the right.
  internal func sra_pHL() {
    let hl = self.registers.hl
    let n = self.memory.read(hl)
    self.memory.write(hl, value: self.sra(n))
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
  internal func srl_r(_ r: SingleRegister) {
    let n = self.registers.get(r)
    self.registers.set(r, to: self.srl(n))
  }

  /// Shifts the contents of operand m to the right.
  internal func srl_pHL() {
    let hl = self.registers.hl
    let n = self.memory.read(hl)
    self.memory.write(hl, value: self.srl(n))
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
  internal func swap_r(_ r: SingleRegister) {
    let n = self.registers.get(r)
    self.registers.set(r, to: self.swap(n))
  }

  /// Shifts the contents of operand m to the right.
  internal func swap_pHL() {
    let hl = self.registers.hl
    let n = self.memory.read(hl)
    self.memory.write(hl, value: self.swap(n))
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
  internal func bit_r(_ b: UInt8, _ r: SingleRegister) {
    let n = self.registers.get(r)
    self.bit(b, n)
  }

  /// Copies the complement of the contents of the specified bit
  /// in memory specified by the contents of register pair HL
  /// to the Z flag of the program status word (PSW).
  internal func bit_pHL(_ b: UInt8) {
    let n = self.memory.read(self.registers.hl)
    self.bit(b, n)
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
  internal func set_r(_ b: UInt8, _ r: SingleRegister) {
    let n = self.registers.get(r)
    self.registers.set(r, to: self.set(b, n))
  }

  /// Sets to 1 the specified bit in the memory contents specified by registers H and L.
  internal func set_pHL(_ b: UInt8) {
    let hl = self.registers.hl
    let n = self.memory.read(hl)
    self.memory.write(hl, value: self.set(b, n))
  }

  private func set(_ b: UInt8, _ n: UInt8) -> UInt8 {
    return n | (0x1 << b)
  }

  // MARK: Reset

  /// Resets to 0 the specified bit in the specified register r.
  internal func res_r(_ b: UInt8, _ r: SingleRegister) {
    let n = self.registers.get(r)
    self.registers.set(r, to: self.res(b, n))
  }

  /// Resets to 0 the specified bit in the memory contents specified by registers H and L.
  internal func res_pHL(_ b: UInt8) {
    let hl = self.registers.hl
    let n = self.memory.read(hl)
    self.memory.write(hl, value: self.res(b, n))
  }

  private func res(_ b: UInt8, _ n: UInt8) -> UInt8 {
    return n & ~(0x1 << b)
  }

  // MARK: - Jump Instructions

  // MARK: JP

  /// Loads the operand nn to the program counter (PC).
  /// nn specifies the address of the subsequently executed instruction.
  internal func jp_nn(_ nn: UInt16) {
    self.pc = nn
  }

  /// Loads operand nn in the PC if condition cc and the flag status match.
  internal func jp_cc_nn(_ condition: JumpCondition, _ nn: UInt16) {
    if self.canJump(condition) {
      self.pc = nn
    }
  }

  /// Loads the contents of register pair HL in program counter PC.
  internal func jp_pHL() {
    self.pc = self.registers.hl
  }

  // MARK: JR

  /// Jumps -127 to +129 steps from the current address.
  internal func jr_e(_ e: UInt8) {
    self.jr(e)
  }

  /// If condition cc and the flag status match, jumps -127 to +129 steps from the current address.
  internal func jr_cc_e(_ condition: JumpCondition, _ e: UInt8) {
    if self.canJump(condition) {
      self.jr(e)
    }
  }

  private func jr(_ e: UInt8) {
    let offset = Int8(bitPattern: e)

    // Current address here would be the address for the instruction following JR.
    let length = UInt16(2)
    let currentAddress = self.pc + length

    let pc = Int(currentAddress) + Int(offset)
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
  internal func call_a16(_ nn: UInt16) {
    self.call(nn)
  }

  /// If condition cc matches the flag, the PC value corresponding to the instruction following the
  /// CALL instruction in memory is pushed to the 2 bytes following the memory byte specified by the SP.
  /// Operand nn is then loaded in the PC.
  internal func call_cc_a16(_ condition: JumpCondition, _ nn: UInt16) {
    if self.canJump(condition) {
      self.call(nn)
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
  internal func ret() {
    self.pc = self.pop16()
  }

  /// The address for the return from the interrupt is loaded in program counter PC.
  /// The master interrupt enable flag is returned to its pre-interrupt status.
  internal func reti() {
    self.ret()
    self.enableInterrupts()
  }

  /// If condition cc and the flag match, control is returned
  /// to the source program by popping from the memory stack
  /// the PC value pushed to the stack when the subroutine was called.
  internal func ret_cc(_ condition: JumpCondition) {
    if canJump(condition) {
      self.ret()
    }
  }

  // MARK: Rst

  /// Pushes the current value of the PC to the memory stack and loads to the PC
  /// the page 0 memory addresses provided by operand t.
  /// Then next instruction is fetched from the address specified by the new content of PC.
  internal func rst(_ t: UInt8) {
    let length = UInt16(1) // the same for both 'rst'
    let returnAddr = self.pc + length
    self.push16(returnAddr)

    self.pc = UInt16(t)
  }

  // MARK: - General-Purpose Arithmetic Operations and CPU Control Instructions

  internal func nop() { }

  internal func prefix(_ n: UInt8) {
    let opcode = cbPrefixedOpcodes[n]

    self.delegate?.cpuWillExecute(self, opcode: opcode)
    self.execute(opcode)
    self.delegate?.cpuDidExecute(self, opcode: opcode)

    // there are no jumps, calls etc. in prefix instructions
    self.pc += UInt16(opcode.length)
  }

  internal func unimplemented() {
    fatalError("Unimplemented!")
  }
}
