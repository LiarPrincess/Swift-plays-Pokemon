// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

extension Cpu {

  // MARK: - Bit

  /// Copies the complement of the contents of the specified bit
  /// in register r to the Z flag of the program status word (PSW).
  mutating func bit_r(_ b: UInt8, _ r: SingleRegister) {
    let n = self.registers.get(r)
    self.bit(b, n)
  }

  /// Copies the complement of the contents of the specified bit
  /// in memory specified by the contents of register pair HL
  /// to the Z flag of the program status word (PSW).
  mutating func bit_pHL(_ b: UInt8) {
    let n = self.memory.read(self.registers.hl)
    self.bit(b, n)
  }

  private mutating func bit(_ b: UInt8, _ n: UInt8) {
    let mask: UInt8 = 0x1 << b

    // Remember that this is complement!
    self.registers.zeroFlag = (n & mask) != mask
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = true
    // carryFlag - not affected
  }

  // MARK: - Set

  /// Sets to 1 the specified bit in specified register r.
  mutating func set_r(_ b: UInt8, _ r: SingleRegister) {
    let n = self.registers.get(r)
    self.registers.set(r, to: self.set(b, n))
  }

  /// Sets to 1 the specified bit in the memory contents specified by registers H and L.
  mutating func set_pHL(_ b: UInt8) {
    let hl = self.registers.hl
    let n = self.memory.read(hl)
    self.memory.write(hl, value: self.set(b, n))
  }

  private func set(_ b: UInt8, _ n: UInt8) -> UInt8 {
    return n | (0x1 << b)
  }

  // MARK: - Reset

  /// Resets to 0 the specified bit in the specified register r.
  mutating func res_r(_ b: UInt8, _ r: SingleRegister) {
    let n = self.registers.get(r)
    self.registers.set(r, to: self.res(b, n))
  }

  /// Resets to 0 the specified bit in the memory contents specified by registers H and L.
  mutating func res_pHL(_ b: UInt8) {
    let hl = self.registers.hl
    let n = self.memory.read(hl)
    self.memory.write(hl, value: self.res(b, n))
  }

  private func res(_ b: UInt8, _ n: UInt8) -> UInt8 {
    return n & ~(0x1 << b)
  }
}
