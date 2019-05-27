struct Cpu {

  /// Program counter: PC.
  /// A 16-bit register that holds the address data of the program to be executed next.
  var pc: UInt16 = 0

  /// Stack pointer: SP.
  /// A 16-bit register that holds the starting address of the stack area of memory.
  var sp: UInt16 = 0

  var registers = Registers()
  var memory = Memory()

  mutating func run() {
    let maxPc = 6

    while self.pc <= maxPc {
      let opcodeIndex = self.memory.read(self.pc)
      let opcode = opcodes[opcodeIndex]

      self.debugOpcode(opcode)
      self.debugRegisters(indent: "  ")
      // self.execute(opcode)

      self.pc += opcode.length
      print()
    }
  }

  var next8: UInt8 {
    return self.memory.read(self.pc + 1)
  }

  var next16: UInt16 {
    let low  = UInt16(self.memory.read(self.pc + 1))
    let high = UInt16(self.memory.read(self.pc + 2))
    return (high << 8) | low
  }

  mutating func push8(_ n: UInt8) {
    self.sp -= 1
    self.memory.write(self.sp, value: n)
  }

  mutating func push16(_ nn: UInt16) {
    self.push8(UInt8(nn >> 8))
    self.push8(UInt8(nn & 0xff))
  }

  mutating func pop8() -> UInt8 {
    let n = self.memory.read(self.sp)
    self.sp += 1
    return n
  }

  mutating func pop16() -> UInt16 {
    let low  = UInt16(self.pop8())
    let high = UInt16(self.pop8())
    return (high << 8) | low
  }

  mutating func enableInterrupts() {
    // TODO: Interrupts
  }
}

// MARK: - Debug

extension Cpu {
  private func debugOpcode(_ opcode: Opcode, indent: String = "") {
    let pc = self.formatHex(self.pc)
    let mnemonic = opcode.debug.padding(toLength: 11, withPad: " ", startingAt: 0)

    var operands = ""
    if opcode.length == 2 {
      operands += "0x\(String(self.next8, radix: 16, uppercase: false))"
    } else if opcode.length == 3 {
      operands += "0x\(String(self.next16, radix: 16, uppercase: false))"
    }
    operands = operands.padding(toLength: 8, withPad: " ", startingAt: 0)

    let additional = "(addr: \(opcode.addr), length: \(opcode.length), cycles: \(opcode.cycles))"
    print("\(indent)\(pc): \(mnemonic) \(operands) \(additional)")
  }

//  private func getMaxDebugLength() {
//    let a = opcodes.map { $0.debug }.max { $0.count < $1.count }
//    print(a?.count)
//  }

  private func debugRegisters(indent: String = "") {
    print("\(indent)pc: \(self.pc) (\(self.formatHex(self.pc)))")
    print("\(indent)sp: \(self.sp) (\(self.formatHex(self.sp)))")

    print("\(indent)single:")
    print("\(indent)  a: \(self.registers.a) (\(self.formatHex(self.registers.a)))")
    print("\(indent)  b: \(self.registers.b) (\(self.formatHex(self.registers.b)))")
    print("\(indent)  c: \(self.registers.c) (\(self.formatHex(self.registers.c)))")
    print("\(indent)  d: \(self.registers.d) (\(self.formatHex(self.registers.d)))")
    print("\(indent)  e: \(self.registers.e) (\(self.formatHex(self.registers.e)))")
    print("\(indent)  h: \(self.registers.h) (\(self.formatHex(self.registers.h)))")
    print("\(indent)  l: \(self.registers.l) (\(self.formatHex(self.registers.l)))")

    print("\(indent)combined:")
    print("\(indent)  bc: \(self.registers.bc) (\(self.formatHex(self.registers.bc)))")
    print("\(indent)  de: \(self.registers.de) (\(self.formatHex(self.registers.de)))")
    print("\(indent)  hl: \(self.registers.hl) (\(self.formatHex(self.registers.hl)))")

    print("\(indent)flags:")
    var flags = ""
    flags += "z:\(self.registers.zeroFlag      ? 1 : 0) "
    flags += "n:\(self.registers.subtractFlag  ? 1 : 0) "
    flags += "h:\(self.registers.halfCarryFlag ? 1 : 0) "
    flags += "c:\(self.registers.carryFlag     ? 1 : 0) "
    print("\(indent)  \(flags)")
  }

  private func formatHex(_ n: UInt8) -> String  {
    return self.formatHex(UInt16(n))
  }

  private func formatHex(_ n: UInt16) -> String  {
    let prefix = n < 10 ? "0" : ""
    let hex = String(n, radix: 16, uppercase: false)
    return "0x\(prefix)\(hex)"
  }
}
