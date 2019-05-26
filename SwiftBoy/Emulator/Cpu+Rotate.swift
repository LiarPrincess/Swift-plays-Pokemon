// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

extension Cpu {

  // MARK: - Rotate left

  /// Rotates the contents of register A to the left.
  mutating func rlca() {
    let a = self.registers.a

    let carry = a >> 7
    let newValue = (a << 1) // TODO: possibly: | carry

    self.registers.zeroFlag = false
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = false
    self.registers.carryFlag = carry == 0x1

    self.registers.a = newValue
  }

  /// Rotates the contents of register A to the left.
  mutating func rla() {
    let a = self.registers.a

    let carry = a >> 7
    let newValue = (a << 1) | (self.registers.carryFlag ? 0x1 : 0x0)

    self.registers.zeroFlag = false
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = false
    self.registers.carryFlag = carry == 0x1

    self.registers.a = newValue
  }

  // MARK: - Rotate right

  /// Rotates the contents of register A to the right.
  mutating func rrca() {
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
  mutating func rra() {
    let a = self.registers.a

    let carry = a & 0x1
    let newValue = (a >> 1) | (self.registers.carryFlag ? 0x8 : 0x0)

    self.registers.zeroFlag = false
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = false
    self.registers.carryFlag = carry == 0x1

    self.registers.a = newValue
  }

  // MARK: - Prefix rotate left

  /// Rotates the contents of operand m to the left. r and (HL) are used for operand m.
  mutating func rlc_r(_ r: SingleRegister) {
    let n = self.registers.get(r)
    self.registers.set(r, to: self.rlc(n))
  }

  /// Rotates the contents of operand m to the left. r and (HL) are used for operand m.
  mutating func rlc_pHL() {
    let hl = self.registers.hl
    let n = self.memory.read(hl)
    self.memory.write(hl, value: self.rlc(n))
  }

  private mutating func rlc(_ n: UInt8) -> UInt8 {
    let carry = n >> 7
    let newValue = (n << 1) | carry

    self.registers.zeroFlag = newValue == 0
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = false
    self.registers.carryFlag = carry == 0x1

    return newValue
  }

  /// Rotates the contents of operand m to the left. r and (HL) are used for operand m.
  mutating func rl_r(_ r: SingleRegister) {
    let n = self.registers.get(r)
    self.registers.set(r, to: self.rl(n))
  }

  /// Rotates the contents of operand m to the left. r and (HL) are used for operand m.
  mutating func rl_pHL() {
    let hl = self.registers.hl
    let n = self.memory.read(hl)
    self.memory.write(hl, value: self.rl(n))
  }

  private mutating func rl(_ n: UInt8) -> UInt8 {
    let carry = n >> 7
    let newValue = (n << 1) | (self.registers.carryFlag ? 0x8 : 0x0)

    self.registers.zeroFlag = newValue == 0
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = false
    self.registers.carryFlag = carry == 0x1

    return newValue
  }

  // MARK: - Prefix rotate right

  /// Rotates the contents of operand m to the right. r and (HL) are used for operand m.
  mutating func rrc_r(_ r: SingleRegister) {
    let n = self.registers.get(r)
    self.registers.set(r, to: self.rrc(n))
  }

  /// Rotates the contents of operand m to the right. r and (HL) are used for operand m.
  mutating func rrc_pHL() {
    let hl = self.registers.hl
    let n = self.memory.read(hl)
    self.memory.write(hl, value: self.rrc(n))
  }

  private mutating func rrc(_ n: UInt8) -> UInt8 {
    let carry = n & 0x01
    let newValue = (n >> 1) | (carry << 7)

    self.registers.zeroFlag = newValue == 0
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = false
    self.registers.carryFlag = carry == 0x1

    return newValue
  }

  /// Rotates the contents of operand m to the right. r and (HL) are used for operand m.
  mutating func rr_r(_ r: SingleRegister) {
    let n = self.registers.get(r)
    self.registers.set(r, to: self.rr(n))
  }

  /// Rotates the contents of operand m to the right. r and (HL) are used for operand m.
  mutating func rr_pHL() {
    let hl = self.registers.hl
    let n = self.memory.read(hl)
    self.memory.write(hl, value: self.rr(n))
  }

  private mutating func rr(_ n: UInt8) -> UInt8 {
    let carry = n & 0x01
    let newValue = (n >> 1) | (self.registers.carryFlag ? 0x8 : 0x0)

    self.registers.zeroFlag = newValue == 0
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = false
    self.registers.carryFlag = carry == 0x1

    return newValue
  }
}
