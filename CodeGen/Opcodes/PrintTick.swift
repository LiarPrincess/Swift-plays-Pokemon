func printTick() throws {
  let opcodes = try openOpcodesFile()

  printHeader()
  print("extension Cpu {")
  print("")
  printTickFunction(opcodes)
  print("}")
  print("// Implemented opcodes: \(255 - unimplementedOpcodes), remaining: \(unimplementedOpcodes)")
}

private func printHeader() {
  print("// This file was auto-generated.")
  print("// DO NOT EDIT!")
  print("")

  print("// swiftlint:disable superfluous_disable_command")
  print("// swiftlint:disable file_length")
  print("// swiftlint:disable function_body_length")
  print("// swiftlint:disable cyclomatic_complexity")
  print("")
}

private func printTickFunction(_ opcodes: Opcodes) {
  print("mutating func tick() {")
  print("let opcodeIndex = self.memory.read(self.pc)")
  print("let opcode = opcodes[opcodeIndex]")
  print("")

  print("// Swift compiler generates better code if we switch on 'opcode.type' and not on 'opcode'")
  print("switch opcode.type {")


  for op in opcodes.unprefixed { // .prefix(10)
    printTick(op)
  }

  print("default: print(\"Unknown opcode: \\(opcode)\")")
  print("}")

  print("}")
  print("")
}

// swiftlint:disable:next function_body_length cyclomatic_complexity
private func printTick(_ opcode: Opcode) {
  let mnemonic = opcode.mnemonic.lowercased()
  let d8 = "self.memory.read(self.pc + 1)"

  switch mnemonic {
  case "nop":
    print("case .\(opcode.enumCase): break")

  case "ld":
    let operand1 = opcode.operand1!.lowercased()
    let operand2 = opcode.operand2!.lowercased()

    if isRegister(operand1) && isRegister(operand2) {
      print("case .\(opcode.enumCase): self.ld_r_r(.\(operand1), .\(operand2))")
    } else if isRegister(operand1) && isd8(operand2) {
      print("case .\(opcode.enumCase): self.ld_r_d8(.\(operand1), \(d8))")
    } else if isRegister(operand1) && ispHL(operand2) {
      print("case .\(opcode.enumCase): self.ld_r_pHL(.\(operand1))")
    } else if ispHL(operand1) && isRegister(operand2) {
      print("case .\(opcode.enumCase): self.ld_pHL_r(.\(operand2))")
    } else if ispHL(operand1) && isd8(operand2) {
      print("case .\(opcode.enumCase): self.ld_pHL_d8(\(d8))")
    } else if isRegisterA(operand1) && ispBC(operand2) {
      print("case .\(opcode.enumCase): self.ld_a_pBC()")
    } else if isRegisterA(operand1) && ispDE(operand2) {
      print("case .\(opcode.enumCase): self.ld_a_pDE()")
    } else if opcode.addr == "0xf2" {
      print("case .\(opcode.enumCase): self.ld_a_ffC()")
    } else if opcode.addr == "0xe2" {
      print("case .\(opcode.enumCase): self.ld_ffC_a()")
    } else if opcode.addr == "0x2a" {
      print("case .\(opcode.enumCase): self.ld_a_pHLI()")
    } else if opcode.addr == "0x3a" {
      print("case .\(opcode.enumCase): self.ld_a_pHLD()")
    } else if opcode.addr == "0x2" {
      print("case .\(opcode.enumCase): self.ld_pBC_a()")
    } else if opcode.addr == "0x12" {
      print("case .\(opcode.enumCase): self.ld_pDE_a()")
    } else if opcode.addr == "0x22" {
      print("case .\(opcode.enumCase): self.ld_pHLI_a()")
    } else if opcode.addr == "0x32" {
      print("case .\(opcode.enumCase): self.ld_pHLD_a()")
    }
    else { printUnimplementedOpcode(opcode) }

  case "add":
    // opcode.operand1 is always 'A' (000)
    let operand = opcode.operand2!.lowercased()

    if isRegister(operand) {
      print("case .\(opcode.enumCase): self.add_r(.\(operand))")
    } else if isd8(operand) {
      print("case .\(opcode.enumCase): self.add_d8(\(d8))")
    } else if ispHL(operand) {
      print("case .\(opcode.enumCase): self.add_pHL()")
    }
    else { printUnimplementedOpcode(opcode) }

//    case "adc":
//      print("")

  case "inc":
    let operand = opcode.operand1!.lowercased()

    if isRegister(operand) {
      print("case .\(opcode.enumCase): self.inc_r(.\(operand))")
    }
    else { printUnimplementedOpcode(opcode) }

  case "dec":
    let operand = opcode.operand1!.lowercased()

    if isRegister(operand) {
      print("case .\(opcode.enumCase): self.dec_r(.\(operand))")
    }
    else { printUnimplementedOpcode(opcode) }

    //    case "rlca":
    //      print("")
    //    case "rrca":
    //      print("")
    //    case "stop":
    //      print("")
    //    case "rla":
    //      print("")
    //    case "jr":
    //      print("")
    //    case "rra":
    //      print("")
    //    case "daa":
    //      print("")
    //    case "cpl":
    //      print("")
    //    case "scf":
    //      print("")
    //    case "ccf":
    //      print("")
    //    case "halt":
    //      print("")

    //    case "sub":
    //      print("")
    //    case "sbc":
    //      print("")
    //    case "and":
    //      print("")
    //    case "xor":
    //      print("")
    //    case "or":
    //      print("")
    //    case "cp":
    //      print("")
    //    case "ret":
    //      print("")
    //    case "pop":
    //      print("")
    //    case "jp":
    //      print("")
    //    case "call":
    //      print("")
    //    case "push":
    //      print("")
    //    case "rst":
    //      print("")
    //    case "prefix":
    //      print("")
    //    case "reti":
    //      print("")
    //    case "ldh":
    //      print("")
    //    case "di":
    //      print("")
    //    case "ei":
  //      print("")
  default:
    printUnimplementedOpcode(opcode)
  }
}

private var unimplementedOpcodes = 0

private func printUnimplementedOpcode(_ opcode: Opcode) {
  unimplementedOpcodes += 1
  print("//case .\(opcode.enumCase): break")
}

private func isRegister(_ operand: String) -> Bool {
  let op = operand.lowercased()
  return op == "a"
      || op == "b"
      || op == "c"
      || op == "d"
      || op == "e"
      || op == "f"
      || op == "h"
      || op == "l"
}
private func isRegisterA(_ operand: String) -> Bool {
  let op = operand.lowercased()
  return op == "a"
}

private func ispHL(_ operand: String) -> Bool {
  let op = operand.lowercased()
  return op == "(hl)"
}

private func ispBC(_ operand: String) -> Bool {
  let op = operand.lowercased()
  return op == "(bc)"
}

private func ispDE(_ operand: String) -> Bool {
  let op = operand.lowercased()
  return op == "(de)"
}

private func isd8(_ operand: String) -> Bool {
  let op = operand.lowercased()
  return op == "d8"
}
