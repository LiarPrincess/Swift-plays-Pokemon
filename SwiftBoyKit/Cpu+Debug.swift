public extension Cpu {

  func debugOpcode<Type>(_ cpu: Cpu, opcode: OpcodeBase<Type>, indent: String = "") {
    let pc = cpu.pc.hex
    let mnemonic = opcode.debug.padding(toLength: 11, withPad: " ", startingAt: 0)

    var operands = ""
    if opcode.length == 2 {
      operands += "0x\(String(cpu.next8, radix: 16, uppercase: false))"
    } else if opcode.length == 3 {
      operands += "0x\(String(cpu.next16, radix: 16, uppercase: false))"
    }
    operands = operands.padding(toLength: 8, withPad: " ", startingAt: 0)

    let additional = "(addr: \(opcode.addr), length: \(opcode.length), cycles: \(opcode.cycles))"
    print("\(indent)\(pc): \(mnemonic) \(operands) \(additional)")
  }

  // swiftlint:disable:next function_body_length
  func debugRegisters(_ cpu: Cpu, indent: String = "") {
    print("\(indent)pc: \(cpu.pc) (\(cpu.pc.hex))")
    print("\(indent)sp: \(cpu.sp) (\(cpu.sp.hex))")

    print("\(indent)values:")

    var lineA = "\(indent)  "
    lineA += "\(getSingleRegisterInfo("a", cpu.registers.a))"
    print(lineA)

    var lineBC = "\(indent)  "
    lineBC += getSingleRegisterInfo("b", cpu.registers.b) + " | "
    lineBC += getSingleRegisterInfo("c", cpu.registers.c) + " | "
    lineBC += getCombinedRegisterInfo("bc", cpu.registers.bc)
    print(lineBC)

    var lineDE = "\(indent)  "
    lineDE += getSingleRegisterInfo("d", cpu.registers.d) + " | "
    lineDE += getSingleRegisterInfo("e", cpu.registers.e) + " | "
    lineDE += getCombinedRegisterInfo("de", cpu.registers.de)
    print(lineDE)

    var lineHL = "\(indent)  "
    lineHL += getSingleRegisterInfo("h", cpu.registers.h) + " | "
    lineHL += getSingleRegisterInfo("l", cpu.registers.l) + " | "
    lineHL += getCombinedRegisterInfo("hl", cpu.registers.hl)
    print(lineHL)

    print("\(indent)flags:")
    var flags = ""
    flags += "z:\(cpu.registers.zeroFlag      ? 1 : 0) "
    flags += "n:\(cpu.registers.subtractFlag  ? 1 : 0) "
    flags += "h:\(cpu.registers.halfCarryFlag ? 1 : 0) "
    flags += "c:\(cpu.registers.carryFlag     ? 1 : 0) "
    print("\(indent)  \(flags)")
  }

  private func getSingleRegisterInfo(_ name: String, _ value: UInt8) -> String {
    return "\(name) \(value.dec) (\(value.hex))"
  }

  private func getCombinedRegisterInfo(_ name: String, _ value: UInt16) -> String {
    return "\(name) \(value.hex) (\(value.hex))"
  }
}
