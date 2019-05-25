struct Cpu {

  private var pc: UInt16 = 0
  private var registers = Registers()
  private var memory = Memory()

  mutating func tick() {
//    let instructionIndex = self.memory.read(self.pc)
//    let instruction = instructions[instructionIndex]
//
//    self.pc = self.execute(instruction)
  }

  mutating func add(_ value: UInt8) -> UInt8 {
    let a = self.registers.a
    let (newValue, overflow) = a.addingReportingOverflow(value)

    self.registers.zeroFlag = newValue == 0
    self.registers.subtractFlag = false
    self.registers.halfCarryFlag = (a & 0xf) + (value & 0xf) > 0xf
    self.registers.carryFlag = overflow

    return newValue
  }
}
