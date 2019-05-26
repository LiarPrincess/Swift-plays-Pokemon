// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

extension Cpu {

  // MARK: - Add

  /// Adds the contents of register r to those of register A
  /// and stores the results in register A.
  mutating func add_a_r(_ r: SingleRegister) {
    self.add_a(self.registers.get(r))
  }

  /// Adds 8-bit immediate operand n to the contents of register A
  /// and stores the results in register A.
  mutating func add_a_n(_ n: UInt8) {
    self.add_a(n)
  }

  /// Adds the contents of memory specified by the contents of register pair HL
  /// to the contents of register A and stores the results in register A
  mutating func add_a_pHL() {
    self.add_a(self.memory.read(self.registers.hl))
  }

  private mutating func add_a(_ n: UInt8) {
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
  mutating func add_hl_r(_ r: CombinedRegister) {
    self.add_hl(self.registers.get(r))
  }

  /// Adds the contents of register pair ss to the contents of register pair HL
  /// and stores the results in HL.
  mutating func add_hl_sp() {
    self.add_hl(self.sp)
  }

  /// Adds the contents of register pair ss to the contents of register pair HL
  /// and stores the results in HL.
  mutating func add_hl(_ n: UInt16) {
    let hl = self.registers.hl
    let (newValue, overflow) = hl.addingReportingOverflow(n)

    // zeroFlag - not affected
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = (hl & 0xfff) + (n & 0xfff) > 0xfff
    self.registers.carryFlag = overflow

    self.registers.hl = newValue
  }

  /// Adds the contents of the 8-bit immediate operand e and SP and stores the results in SP.
  mutating func add_sp_n(_ n: UInt8) {
    let sp = self.sp
    let nn = UInt16(n)
    let (newValue, overflow) = sp.addingReportingOverflow(nn)

    self.registers.zeroFlag = false
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = (sp & 0xf) + (nn & 0xf) > 0xf
    self.registers.carryFlag = overflow

    self.sp = newValue
  }

  // MARK: - Adc

  /// Adds the contents of operand s and CY to the contents of register A
  /// and stores the results in register A.. r, n, and (HL) are used for operand s.
  mutating func adc_a_r(_ r: SingleRegister) {
    self.adc_a(self.registers.get(r))
  }

  /// Adds the contents of operand s and CY to the contents of register A
  /// and stores the results in register A.. r, n, and (HL) are used for operand s.
  mutating func adc_a_n(_ n: UInt8) {
    self.adc_a(n)
  }

  /// Adds the contents of operand s and CY to the contents of register A
  /// and stores the results in register A.. r, n, and (HL) are used for operand s.
  mutating func adc_a_pHL() {
    self.adc_a(self.memory.read(self.registers.hl))
  }

  private mutating func adc_a(_ n: UInt8) {
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

  // MARK: - Sub

  /// Subtracts the contents of operand s from the contents of register A
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  mutating func sub_a_r(_ r: SingleRegister) {
    self.sub_a(self.registers.get(r))
  }

  /// Subtracts the contents of operand s from the contents of register A
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  mutating func sub_a_n(_ n: UInt8) {
    self.sub_a(n)
  }

  /// Subtracts the contents of operand s from the contents of register A
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  mutating func sub_a_pHL() {
    self.sub_a(self.memory.read(self.registers.hl))
  }

  private mutating func sub_a(_ n: UInt8) {
    let a = self.registers.a

    let (newValue, overflow) = a.subtractingReportingOverflow(n)
    let (_, halfCarry) = (a & 0xf).subtractingReportingOverflow(n & 0xf)

    self.registers.zeroFlag = newValue == 0
    self.registers.subtractFlag = true
    self.registers.halfCarryFlag = halfCarry
    self.registers.carryFlag = overflow

    self.registers.a = newValue
  }

  // MARK: - Sbc

  /// Subtracts the contents of operand s and CY from the contents of register A
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  mutating func sbc_a_r(_ r: SingleRegister) {
    self.sbc_a(self.registers.get(r))
  }

  /// Subtracts the contents of operand s and CY from the contents of register A
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  mutating func sbc_a_n(_ n: UInt8) {
    self.sbc_a(n)
  }

  /// Subtracts the contents of operand s and CY from the contents of register A
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  mutating func sbc_a_pHL() {
    self.sbc_a(self.memory.read(self.registers.hl))
  }

  mutating func sbc_a(_ n: UInt8) {
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

  // MARK: - Cp

  /// Compares the contents of operand s and register A
  /// and sets the flag if they are equal. r, n, and (HL) are used for operand s.
  mutating func cp_a_r(_ r: SingleRegister) {
    self.cp_a(self.registers.get(r))
  }

  /// Compares the contents of operand s and register A
  /// and sets the flag if they are equal. r, n, and (HL) are used for operand s.
  mutating func cp_a_n(_ n: UInt8) {
    self.cp_a(n)
  }

  /// Compares the contents of operand s and register A
  /// and sets the flag if they are equal. r, n, and (HL) are used for operand s.
  mutating func cp_a_pHL() {
    self.cp_a(self.memory.read(self.registers.hl))
  }

  /// Basically sub, but without storing result
  private mutating func cp_a(_ n: UInt8) {
    let a = self.registers.a

    let (newValue, overflow) = a.subtractingReportingOverflow(n)
    let (_, halfCarry) = (a & 0xf).subtractingReportingOverflow(n & 0xf)

    self.registers.zeroFlag = newValue == 0
    self.registers.subtractFlag = true
    self.registers.halfCarryFlag = halfCarry
    self.registers.carryFlag = overflow
  }

  // MARK: - Inc

  /// Increments the contents of register r by 1.
  mutating func inc_r(_ r: SingleRegister) {
    let n = self.registers.get(r)
    let (newValue, _) = n.addingReportingOverflow(1)

    self.registers.zeroFlag = newValue == 0
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = (n & 0xf) + 0x1 > 0xf
    // carryFlag - not affected

    self.registers.set(r, to: newValue)
  }

  /// Increments the contents of register pair ss by 1.
  mutating func inc_r(_ r: CombinedRegister) {
    let n = self.registers.get(r)
    let (newValue, _) = n.addingReportingOverflow(1)
    // flags affected: none
    self.registers.set(r, to: newValue)
  }

  /// Increments by 1 the contents of memory specified by register pair HL.
  mutating func inc_pHL() {
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
  mutating func inc_sp() {
    let (newValue, _) = self.sp.addingReportingOverflow(1)
    // flags affected: none
    self.sp = newValue
  }

  // MARK: - Dec

  /// Subtract 1 from the contents of register r by 1.
  mutating func dec_r(_ r: SingleRegister) {
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
  mutating func dec_r(_ r: CombinedRegister) {
    let n = self.registers.get(r)
    let (newValue, _) = n.subtractingReportingOverflow(1)
    // flags affected: none
    self.registers.set(r, to: newValue)
  }

  /// Decrements by 1 the contents of memory specified by register pair HL.
  mutating func dec_pHL() {
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
  mutating func dec_sp() {
    let (newValue, _) = self.sp.subtractingReportingOverflow(1)
    // flags affected: none
    self.sp = newValue
  }
}
