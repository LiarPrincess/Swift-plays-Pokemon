// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

extension Cpu {

  // MARK: - Shift

  /// Shifts the contents of operand m to the left.
  mutating func sla_r(_ r: SingleRegister) {
    let n = self.registers.get(r)
    self.registers.set(r, to: self.sla(n))
  }

  /// Shifts the contents of operand m to the left.
  mutating func sla_pHL() {
    let hl = self.registers.hl
    let n = self.memory.read(hl)
    self.memory.write(hl, value: self.sla(n))
  }

  private mutating func sla(_ n: UInt8) -> UInt8 {
    let carry = n >> 7
    let newValue = (n << 1)

    self.registers.zeroFlag = newValue == 0
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = false
    self.registers.carryFlag = carry == 0x1

    return newValue
  }

  /// Shifts the contents of operand m to the right.
  mutating func sra_r(_ r: SingleRegister) {
    let n = self.registers.get(r)
    self.registers.set(r, to: self.sra(n))
  }

  /// Shifts the contents of operand m to the right.
  mutating func sra_pHL() {
    let hl = self.registers.hl
    let n = self.memory.read(hl)
    self.memory.write(hl, value: self.sra(n))
  }

  private mutating func sra(_ n: UInt8) -> UInt8 {
    let carry = n & 0x01
    let newValue = (n >> 1) | (n & 0x80)

    self.registers.zeroFlag = newValue == 0
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = false
    self.registers.carryFlag = carry == 0x1

    return newValue
  }

  /// Shifts the contents of operand m to the right.
  mutating func srl_r(_ r: SingleRegister) {
    let n = self.registers.get(r)
    self.registers.set(r, to: self.srl(n))
  }

  /// Shifts the contents of operand m to the right.
  mutating func srl_pHL() {
    let hl = self.registers.hl
    let n = self.memory.read(hl)
    self.memory.write(hl, value: self.srl(n))
  }

  private mutating func srl(_ n: UInt8) -> UInt8 {
    let carry = n & 0x01
    let newValue = (n >> 1)

    self.registers.zeroFlag = newValue == 0
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = false
    self.registers.carryFlag = carry == 0x1

    return newValue
  }

  // MARK: - Swap

  /// Shifts the contents of operand m to the right.
  mutating func swap_r(_ r: SingleRegister) {
    let n = self.registers.get(r)
    self.registers.set(r, to: self.swap(n))
  }

  /// Shifts the contents of operand m to the right.
  mutating func swap_pHL() {
    let hl = self.registers.hl
    let n = self.memory.read(hl)
    self.memory.write(hl, value: self.swap(n))
  }

  private mutating func swap(_ n: UInt8) -> UInt8 {
    let newValue = (n << 4) | (n >> 4)

    self.registers.zeroFlag = newValue == 0
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = false
    self.registers.carryFlag = false

    return newValue
  }
}
