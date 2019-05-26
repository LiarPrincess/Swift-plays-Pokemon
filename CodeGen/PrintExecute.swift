// swiftlint:disable file_length
// swiftlint:disable function_body_length
// swiftlint:disable cyclomatic_complexity

func printExecute() throws {
  let opcodes = try openOpcodesFile()

  printHeader()
  print("extension Cpu {")
  printExecuteFunction(opcodes.unprefixed)
  print("}")
  print("// Implemented opcodes: \(opcodes.unprefixed.count - unimplementedOpcodes), remaining: \(unimplementedOpcodes)")
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

private func printExecuteFunction(_ opcodes: [Opcode]) {
  print("mutating func execute(_ opcode: Opcode) {")
  print("switch opcode.type {")

  for op in opcodes {
    printTick(op)
  }

  print("default: print(\"Unknown opcode: \\(opcode)\")")
  print("}")

  print("}")
}

private func printTick(_ opcode: Opcode) {
  let mnemonic = opcode.mnemonic.lowercased()
  let nextWord = "self.nextWord"
  let nextLong = "self.nextLong"

  switch mnemonic {
  case "nop":
    print("case .\(opcode.enumCase): break")

  case "ld":
    let operand1 = opcode.operand1!.lowercased()
    let operand2 = opcode.operand2!.lowercased()

    if isRegister(operand1) && isRegister(operand2) {
      print("case .\(opcode.enumCase): self.ld_r_r(.\(operand1), .\(operand2))")
    } else if isRegister(operand1) && isd8(operand2) {
      print("case .\(opcode.enumCase): self.ld_r_n(.\(operand1), \(nextWord))")
    } else if isRegister(operand1) && ispHL(operand2) {
      print("case .\(opcode.enumCase): self.ld_r_pHL(.\(operand1))")
    } else if ispHL(operand1) && isRegister(operand2) {
      print("case .\(opcode.enumCase): self.ld_pHL_r(.\(operand2))")
    } else if ispHL(operand1) && isd8(operand2) {
      print("case .\(opcode.enumCase): self.ld_pHL_n(\(nextWord))")
    } else if isA(operand1) && ispBC(operand2) {
      print("case .\(opcode.enumCase): self.ld_a_pBC()")
    } else if isA(operand1) && ispDE(operand2) {
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
    let operand1 = opcode.operand1!.lowercased()
    let operand2 = opcode.operand2!.lowercased()

    if isA(operand1) && isRegister(operand2) {
      print("case .\(opcode.enumCase): self.add_a_r(.\(operand2))")
    } else if isA(operand1) && isd8(operand2) {
      print("case .\(opcode.enumCase): self.add_a_n(\(nextWord))")
    } else if isA(operand1) && ispHL(operand2) {
      print("case .\(opcode.enumCase): self.add_a_pHL()")
    } else if isHL(operand1) && isCombinedRegister(operand2) {
      print("case .\(opcode.enumCase): self.add_hl_r(.\(operand2))")
    } else if opcode.addr == "0x39" {
      print("case .\(opcode.enumCase): self.add_hl_sp()")
    } else if opcode.addr == "0xe8" {
      print("case .\(opcode.enumCase): self.add_sp_n(\(nextWord))")
    }
    else { printUnimplementedOpcode(opcode) }

  case "adc":
    // opcode.operand1 is always 'A' (000)
    let operand = opcode.operand2!.lowercased()

    if isRegister(operand) {
      print("case .\(opcode.enumCase): self.adc_a_r(.\(operand))")
    } else if isd8(operand) {
      print("case .\(opcode.enumCase): self.adc_a_n(\(nextWord))")
    } else if ispHL(operand) {
      print("case .\(opcode.enumCase): self.adc_a_pHL()")
    }
    // add_hl_r
    else { printUnimplementedOpcode(opcode) }

  case "sub":
    let operand = opcode.operand1!.lowercased()

    if isRegister(operand) {
      print("case .\(opcode.enumCase): self.sub_a_r(.\(operand))")
    } else if isd8(operand) {
      print("case .\(opcode.enumCase): self.sub_a_n(\(nextWord))")
    } else if ispHL(operand) {
      print("case .\(opcode.enumCase): self.sub_a_pHL()")
    }
    else { printUnimplementedOpcode(opcode) }

  case "sbc":
    // opcode.operand1 is always 'A' (000)
    let operand = opcode.operand2!.lowercased()

    if isRegister(operand) {
      print("case .\(opcode.enumCase): self.sbc_a_r(.\(operand))")
    } else if isd8(operand) {
      print("case .\(opcode.enumCase): self.sbc_a_n(\(nextWord))")
    } else if ispHL(operand) {
      print("case .\(opcode.enumCase): self.sbc_a_pHL()")
    }
    else { printUnimplementedOpcode(opcode) }

  case "and":
    let operand = opcode.operand1!.lowercased()

    if isRegister(operand) {
      print("case .\(opcode.enumCase): self.and_a_r(.\(operand))")
    } else if isd8(operand) {
      print("case .\(opcode.enumCase): self.and_a_n(\(nextWord))")
    } else if ispHL(operand) {
      print("case .\(opcode.enumCase): self.and_a_pHL()")
    }
    else { printUnimplementedOpcode(opcode) }

  case "or":
    let operand = opcode.operand1!.lowercased()

    if isRegister(operand) {
      print("case .\(opcode.enumCase): self.or_a_r(.\(operand))")
    } else if isd8(operand) {
      print("case .\(opcode.enumCase): self.or_a_n(\(nextWord))")
    } else if ispHL(operand) {
      print("case .\(opcode.enumCase): self.or_a_pHL()")
    }
    else { printUnimplementedOpcode(opcode) }

  case "xor":
    let operand = opcode.operand1!.lowercased()

    if isRegister(operand) {
      print("case .\(opcode.enumCase): self.xor_a_r(.\(operand))")
    } else if isd8(operand) {
      print("case .\(opcode.enumCase): self.xor_a_n(\(nextWord))")
    } else if ispHL(operand) {
      print("case .\(opcode.enumCase): self.xor_a_pHL()")
    }
    else { printUnimplementedOpcode(opcode) }

  case "cp":
    let operand = opcode.operand1!.lowercased()

    if isRegister(operand) {
      print("case .\(opcode.enumCase): self.cp_a_r(.\(operand))")
    } else if isd8(operand) {
      print("case .\(opcode.enumCase): self.cp_a_n(\(nextWord))")
    } else if ispHL(operand) {
      print("case .\(opcode.enumCase): self.cp_a_pHL()")
    }
    else { printUnimplementedOpcode(opcode) }

  case "inc":
    let operand = opcode.operand1!.lowercased()

    if isRegister(operand) {
      print("case .\(opcode.enumCase): self.inc_r(.\(operand))")
    } else if ispHL(operand) {
      print("case .\(opcode.enumCase): self.inc_pHL()")
    } else if isCombinedRegister(operand) {
      print("case .\(opcode.enumCase): self.inc_r(.\(operand))")
    } else if opcode.addr == "0x33" {
      print("case .\(opcode.enumCase): self.inc_sp()")
    }
    else { printUnimplementedOpcode(opcode) }

  case "dec":
    let operand = opcode.operand1!.lowercased()

    if isRegister(operand) {
      print("case .\(opcode.enumCase): self.dec_r(.\(operand))")
    } else if ispHL(operand) {
      print("case .\(opcode.enumCase): self.dec_pHL()")
    } else if isCombinedRegister(operand) {
      print("case .\(opcode.enumCase): self.dec_r(.\(operand))")
    } else if opcode.addr == "0x3b" {
      print("case .\(opcode.enumCase): self.dec_sp()")
    }
    else { printUnimplementedOpcode(opcode) }

  case "rlca": print("case .\(opcode.enumCase): self.rlca()")
  case "rla":  print("case .\(opcode.enumCase): self.rla()")
  case "rrca": print("case .\(opcode.enumCase): self.rrca()")
  case "rra":  print("case .\(opcode.enumCase): self.rra()")

//  case "stop":
//    print("")
//  case "jr":
//    print("")
//  case "daa":
//    print("")
//  case "cpl":
//    print("")
//  case "scf":
//    print("")
//  case "ccf":
//    print("")
//  case "halt":
//    print("")
//  case "ret":
//    print("")
//  case "pop":
//    print("")
//  case "jp":
//    print("")
//  case "call":
//    print("")
//  case "push":
//    print("")
//  case "rst":
//    print("")
//  case "prefix":
//    print("")
//  case "reti":
//    print("")
//  case "ldh":
//    print("")
//  case "di":
//    print("")
//  case "ei":
//    print("")

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
  return op == "a" || op == "b"
      || op == "c" || op == "d"
      || op == "e"
      || op == "h" || op == "l"
}

private func isCombinedRegister(_ operand: String) -> Bool {
  let op = operand.lowercased()
  return op == "bc" || op == "de" || op == "hl"
}

private func isA(_ operand: String) -> Bool {
  let op = operand.lowercased()
  return op == "a"
}

private func isHL(_ operand: String) -> Bool {
  let op = operand.lowercased()
  return op == "hl"
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
