// swiftlint:disable file_length

// 8-Bit Arithmetic and Logical Operation Instructions

extension Cpu {

  // MARK: - Add

  /// Adds the contents of register r to those of register A
  /// and stores the results in register A.
  mutating func add_r(_ r: SingleRegister) {
    self.add(self.registers.get(r))
  }

  /// Adds 8-bit immediate operand n to the contents of register A
  /// and stores the results in register A.
  mutating func add_d8(_ n: UInt8) {
    self.add(n)
  }

  /// Adds the contents of memory specified by the contents of register pair HL to the contents of register A and stores the results in register A
  mutating func add_pHL() {
    self.add(self.memory.read(self.registers.hl))
  }

  private mutating func add(_ n: UInt8) {
    let a = self.registers.a
    let (newValue, overflow) = a.addingReportingOverflow(n)

    self.registers.zeroFlag = newValue == 0
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = (a & 0xf) + (n & 0xf) > 0xf
    self.registers.carryFlag = overflow

    self.registers.a = newValue
  }

  // MARK: - Adc

  /// Adds the contents of operand s and CY to the contents of register A
  /// and stores the results in register A.. r, n, and (HL) are used for operand s.
  mutating func adc_r(_ r: SingleRegister) {
    self.adc(self.registers.get(r))
  }

  /// Adds the contents of operand s and CY to the contents of register A
  /// and stores the results in register A.. r, n, and (HL) are used for operand s.
  mutating func adc_d8(_ n: UInt8) {
    self.adc(n)
  }

  /// Adds the contents of operand s and CY to the contents of register A
  /// and stores the results in register A.. r, n, and (HL) are used for operand s.
  mutating func adc_pHL() {
    self.adc(self.memory.read(self.registers.hl))
  }

  mutating func adc(_ n: UInt8) {
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
  mutating func sub_r(_ r: SingleRegister) {
    self.sub(self.registers.get(r))
  }

  /// Subtracts the contents of operand s from the contents of register A
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  mutating func sub_d8(_ n: UInt8) {
    self.sub(n)
  }

  /// Subtracts the contents of operand s from the contents of register A
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  mutating func sub_pHL() {
    self.sub(self.memory.read(self.registers.hl))
  }

  private mutating func sub(_ n: UInt8) {
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
  mutating func sbc_r(_ r: SingleRegister) {
    self.sbc(self.registers.get(r))
  }

  /// Subtracts the contents of operand s and CY from the contents of register A
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  mutating func sbc_d8(_ n: UInt8) {
    self.sbc(n)
  }

  /// Subtracts the contents of operand s and CY from the contents of register A
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  mutating func sbc_pHL() {
    self.sbc(self.memory.read(self.registers.hl))
  }

  mutating func sbc(_ n: UInt8) {
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

  // MARK: - And

  /// Takes the logical-AND for each bit of the contents of operand s and register A,
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  mutating func and_r(_ r: SingleRegister) {
    self.and(self.registers.get(r))
  }

  /// Takes the logical-AND for each bit of the contents of operand s and register A,
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  mutating func and_d8(_ n: UInt8) {
    self.and(n)
  }

  /// Takes the logical-AND for each bit of the contents of operand s and register A,
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  mutating func and_pHL() {
    self.and(self.memory.read(self.registers.hl))
  }

  private mutating func and(_ n: UInt8) {
    let a = self.registers.a
    let newValue = a & n

    self.registers.zeroFlag = newValue == 0
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = true
    self.registers.carryFlag = false

    self.registers.a = newValue
  }

  // MARK: - Or

  /// Takes the logical-OR for each bit of the contents of operand s and register A
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  mutating func or_r(_ r: SingleRegister) {
    self.or(self.registers.get(r))
  }

  /// Takes the logical-OR for each bit of the contents of operand s and register A
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  mutating func or_d8(_ n: UInt8) {
    self.or(n)
  }

  /// Takes the logical-OR for each bit of the contents of operand s and register A
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  mutating func or_pHL() {
    self.or(self.memory.read(self.registers.hl))
  }

  private mutating func or(_ n: UInt8) {
    let a = self.registers.a
    let newValue = a | n

    self.registers.zeroFlag = newValue == 0
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = false
    self.registers.carryFlag = false

    self.registers.a = newValue
  }

  // MARK: - Xor

  /// Takes the logical exclusive-OR for each bit of the contents of operand s and register A.
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  mutating func xor_r(_ r: SingleRegister) {
    self.xor(self.registers.get(r))
  }

  /// Takes the logical exclusive-OR for each bit of the contents of operand s and register A.
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  mutating func xor_d8(_ n: UInt8) {
    self.xor(n)
  }

  /// Takes the logical exclusive-OR for each bit of the contents of operand s and register A.
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  mutating func xor_pHL() {
    self.xor(self.memory.read(self.registers.hl))
  }

  private mutating func xor(_ n: UInt8) {
    let a = self.registers.a
    let newValue = a ^ n

    self.registers.zeroFlag = newValue == 0
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = false
    self.registers.carryFlag = false

    self.registers.a = newValue
  }

  // MARK: - Old

  /// Increment register r
  mutating func inc_r(_ r: SingleRegister) {
    let value = self.registers.get(r)
    let (newValue, _) = value.addingReportingOverflow(1)
    self.registers.set(r, to: newValue)

    self.registers.zeroFlag = newValue == 0
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = newValue % 16 == 0
    // carryFlag - not affected
  }

  /// Decrement register r
  mutating func dec_r(_ r: SingleRegister) {
    let value = self.registers.get(r)
    let (newValue, _) = value.subtractingReportingOverflow(1)
    self.registers.set(r, to: newValue)

    self.registers.zeroFlag = newValue == 0
    self.registers.subtractFlag = true
    self.registers.halfCarryFlag = newValue % 16 == 15
    // carryFlag - not affected
  }
}
