// 8-Bit Arithmetic and Logical Operation Instructions

extension Cpu {

  /// Adds the contents of register r to those of register A
  /// and stores the results in register A.
  mutating func add_r(_ r: SingleRegister) {
    let a = self.registers.a
    let n = self.registers.get(r)

    let (newValue, overflow) = a.addingReportingOverflow(n)
    self.registers.a = newValue

    self.registers.zeroFlag = newValue == 0
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = (a & 0xf) + (n & 0xf) > 0xf
    self.registers.carryFlag = overflow
  }

  /// Adds 8-bit immediate operand n to the contents of register A
  /// and stores the results in register A.
  mutating func add_d8(_ n: UInt8) {
    let a = self.registers.a

    let (newValue, overflow) = a.addingReportingOverflow(n)
    self.registers.a = newValue

    self.registers.zeroFlag = newValue == 0
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = (a & 0xf) + (n & 0xf) > 0xf
    self.registers.carryFlag = overflow
  }

  /// Adds the contents of memory specified by the contents of register pair HL to the contents of register A and stores the results in register A
  mutating func add_pHL() {
    let a = self.registers.a
    let hl = self.registers.hl
    let n = self.memory.read(hl)

    let (newValue, overflow) = a.addingReportingOverflow(n)
    self.registers.a = newValue

    self.registers.zeroFlag = newValue == 0
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = (a & 0xf) + (n & 0xf) > 0xf
    self.registers.carryFlag = overflow
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
