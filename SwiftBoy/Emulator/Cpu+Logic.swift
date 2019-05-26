// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

extension Cpu {

  // MARK: - And

  /// Takes the logical-AND for each bit of the contents of operand s and register A,
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  mutating func and_a_r(_ r: SingleRegister) {
    self.and_a(self.registers.get(r))
  }

  /// Takes the logical-AND for each bit of the contents of operand s and register A,
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  mutating func and_a_n(_ n: UInt8) {
    self.and_a(n)
  }

  /// Takes the logical-AND for each bit of the contents of operand s and register A,
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  mutating func and_a_pHL() {
    self.and_a(self.memory.read(self.registers.hl))
  }

  private mutating func and_a(_ n: UInt8) {
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
  mutating func or_a_r(_ r: SingleRegister) {
    self.or_a(self.registers.get(r))
  }

  /// Takes the logical-OR for each bit of the contents of operand s and register A
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  mutating func or_a_n(_ n: UInt8) {
    self.or_a(n)
  }

  /// Takes the logical-OR for each bit of the contents of operand s and register A
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  mutating func or_a_pHL() {
    self.or_a(self.memory.read(self.registers.hl))
  }

  private mutating func or_a(_ n: UInt8) {
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
  mutating func xor_a_r(_ r: SingleRegister) {
    self.xor_a(self.registers.get(r))
  }

  /// Takes the logical exclusive-OR for each bit of the contents of operand s and register A.
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  mutating func xor_a_n(_ n: UInt8) {
    self.xor_a(n)
  }

  /// Takes the logical exclusive-OR for each bit of the contents of operand s and register A.
  /// and stores the results in register A. r, n, and (HL) are used for operand s.
  mutating func xor_a_pHL() {
    self.xor_a(self.memory.read(self.registers.hl))
  }

  private mutating func xor_a(_ n: UInt8) {
    let a = self.registers.a
    let newValue = a ^ n

    self.registers.zeroFlag = newValue == 0
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = false
    self.registers.carryFlag = false

    self.registers.a = newValue
  }
}
