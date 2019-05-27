// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

extension Cpu {
  // TODO: Remove remaining d8

  /// Loads the contents of register r' into register r.
  mutating func ld_r_r(_ dst: SingleRegister, _ src: SingleRegister) {
    let value = self.registers.get(src)
    self.registers.set(dst, to: value)
  }

  /// Loads 8-bit immediate data n into register r.
  mutating func ld_r_d8(_ r: SingleRegister, _ n: UInt8) {
    self.registers.set(r, to: n)
  }

  /// Loads the contents of memory (8 bits) specified by register pair HL into register r.
  mutating func ld_r_pHL(_ r: SingleRegister) {
    let n = self.memory.read(self.registers.hl)
    self.registers.set(r, to: n)
  }

  /// Stores the contents of register r in memory specified by register pair HL.
  mutating func ld_pHL_r(_ r: SingleRegister) {
    let n = self.registers.get(r)
    let hl = self.registers.hl
    self.memory.write(hl, value: n)
  }

  /// Loads 8-bit immediate data n into memory specified by register pair HL.
  mutating func ld_pHL_d8(_ n: UInt8) {
    let hl = self.registers.hl
    self.memory.write(hl, value: n)
  }

  /// Loads the contents specified by the contents of register pair BC into register A.
  mutating func ld_a_pBC() {
    let bc = self.registers.bc
    self.registers.a = self.memory.read(bc)
  }

  /// Loads the contents specified by the contents of register pair DE into register A.
  mutating func ld_a_pDE() {
    let de = self.registers.de
    self.registers.a = self.memory.read(de)
  }

  /// Loads into register A the contents of the internal RAM, port register,
  /// or mode register at the address in the range FF00h-FFFFh specified by register C.
  mutating func ld_a_ffC() {
    let address = UInt16(0xff00) + UInt16(self.registers.c)
    self.registers.a = self.memory.read(address)
  }

  /// Loads the contents of register A in the internal RAM, port register,
  /// or mode register at the address in the range FF00h-FFFFh specified by register C.
  mutating func ld_ffC_a() {
    let a = self.registers.a
    let address = UInt16(0xff00) + UInt16(self.registers.c)
    self.memory.write(address, value: a)
  }

  // TODO: Missing 4x opcodes from pages 97 and 98

  /// Loads in register A the contents of memory specified by the contents of register pair HL
  /// and simultaneously increments the contents of HL.
  mutating func ld_a_pHLI() {
    let hl = self.registers.hl
    self.registers.a = self.memory.read(hl)

    let (newHL, _) = hl.addingReportingOverflow(1)
    self.registers.hl = newHL
  }

  /// Loads in register A the contents of memory specified by the contents of register pair HL
  /// and simultaneously decrements the contents of HL.
  mutating func ld_a_pHLD() {
    let hl = self.registers.hl
    self.registers.a = self.memory.read(hl)

    let (newHL, _) = hl.subtractingReportingOverflow(1)
    self.registers.hl = newHL
  }

  /// Stores the contents of register A in the memory specified by register pair BC.
  mutating func ld_pBC_a() {
    let a = self.registers.a
    let bc = self.registers.bc
    self.memory.write(bc, value: a)
  }

  /// Stores the contents of register A in the memory specified by register pair DE.
  mutating func ld_pDE_a() {
    let a = self.registers.a
    let de = self.registers.de
    self.memory.write(de, value: a)
  }

  /// Stores the contents of register A in the memory specified by register pair HL
  /// and simultaneously increments the contents of HL.
  mutating func ld_pHLI_a() {
    let a = self.registers.a
    let hl = self.registers.hl
    self.memory.write(hl, value: a)

    let (newHL, _) = hl.addingReportingOverflow(1)
    self.registers.hl = newHL
  }

  /// Stores the contents of register A in the memory specified by register pair HL
  /// and simultaneously decrements the contents of HL.
  mutating func ld_pHLD_a() {
    let a = self.registers.a
    let hl = self.registers.hl
    self.memory.write(hl, value: a)

    let (newHL, _) = hl.subtractingReportingOverflow(1)
    self.registers.hl = newHL
  }

  // TODO: Missing '16-Bit Transfer Instructions' from page 100
}
