// swiftlint:disable file_length
// swiftlint:disable function_body_length
// swiftlint:disable cyclomatic_complexity

func printExecute(_ opcodes: Opcodes) {
  printHeader()
  printCpuExtension(opcodes.unprefixed)
}

private func printHeader() {
  print("// This file was auto-generated.")
  print("// DO NOT EDIT!")
  print("")

  print("// swiftlint:disable superfluous_disable_command")
  print("// swiftlint:disable file_length")
  print("// swiftlint:disable function_body_length")
  print("// swiftlint:disable cyclomatic_complexity")
  print("// swiftlint:disable switch_case_alignment")
  print("")
}

private func printCpuExtension(_ opcodes: [Opcode]) {
  print("extension Cpu {")
  print("  mutating func execute(_ opcode: Opcode) {")
  print("    switch opcode.type {")

  for op in opcodes {
    printOpcodeCase(op)
  }

  print("    default: print(\"Unknown opcode: \\(opcode)\")")
  print("    }")
  print("  }")
  print("}")
  print("// Implemented opcodes: \(opcodes.count - unimplementedOpcodes), remaining: \(unimplementedOpcodes)")
}

private func printOpcodeCase(_ opcode: Opcode) {
  let mnemonic = opcode.mnemonic.lowercased()
  let next8 = "self.next8"
  let next16 = "self.next16"

  // getFunctionCall(_ opcode: Opcode)
  print("/* \(opcode.addr) */ ", terminator: "")
  switch mnemonic {
  case "nop":
    print("case .\(opcode.enumCase): break")

  case "ld":
    let operand1 = opcode.operand1!.lowercased()
    let operand2 = opcode.operand2!.lowercased()

    if opcode.addr == "0xf2" {
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
    } else if opcode.addr == "0xfa" {
      print("case .\(opcode.enumCase): self.ld_a_pA16(\(next16))")
    } else if opcode.addr == "0xea" {
      print("case .\(opcode.enumCase): self.ld_pA16_a(\(next16))")
    } else if opcode.addr == "0xf8" {
      print("case .\(opcode.enumCase): self.ld_hl_sp_plus_e(\(next8))")
    } else if opcode.addr == "0x8" {
      print("case .\(opcode.enumCase): self.ld_pA16_sp(\(next16))")
    } else if opcode.addr == "0xf9" {
      print("case .\(opcode.enumCase): self.ld_sp_hl()")
    } else if opcode.addr == "0xa" {
      print("case .\(opcode.enumCase): self.ld_a_pBC()")
    } else if opcode.addr == "0x1a" {
      print("case .\(opcode.enumCase): self.ld_a_pDE()")
    } else if opcode.addr == "0x31" {
      print("case .\(opcode.enumCase): self.ld_sp_d16(\(next16))")
    } else if opcode.addr == "0x36" {
      print("case .\(opcode.enumCase): self.ld_pHL_d8(\(next8))")
    }
    else if isRegister(operand1) {
      if isRegister(operand2) {
        print("case .\(opcode.enumCase): self.ld_r_r(.\(operand1), .\(operand2))")
      } else if isd8(operand2) {
        print("case .\(opcode.enumCase): self.ld_r_d8(.\(operand1), \(next8))")
      } else if ispHL(operand2) {
        print("case .\(opcode.enumCase): self.ld_r_pHL(.\(operand1))")
      }
    }
    else if isCombinedRegister(operand1) && isd16(operand2) {
      print("case .\(opcode.enumCase): self.ld_rr_d16(.\(operand1), \(next16))")
    }
    else if ispHL(operand1) && isRegister(operand2) {
      print("case .\(opcode.enumCase): self.ld_pHL_r(.\(operand2))")
    }
    else { printUnimplementedOpcode(opcode) }

  // no idea why those are 'ldh' instead of 'ld' (as in official documentation)
  case "ldh":
    if opcode.addr == "0xf0" {
      print("case .\(opcode.enumCase): self.ld_a_pA8(\(next8))")
    } else if opcode.addr == "0xe0" {
      print("case .\(opcode.enumCase): self.ld_pA8_a(\(next8))")
    }
    else { printUnimplementedOpcode(opcode) }

  case "add":
    let operand1 = opcode.operand1!.lowercased()
    let operand2 = opcode.operand2!.lowercased()

    if opcode.addr == "0x39" {
      print("case .\(opcode.enumCase): self.add_hl_sp()")
    } else if opcode.addr == "0x86" {
      print("case .\(opcode.enumCase): self.add_a_pHL()")
    } else if opcode.addr == "0xc6" {
      print("case .\(opcode.enumCase): self.add_a_d8(\(next8))")
    } else if opcode.addr == "0xe8" {
      print("case .\(opcode.enumCase): self.add_sp_r8(\(next8))")
    }
    else if isA(operand1) && isRegister(operand2) {
      print("case .\(opcode.enumCase): self.add_a_r(.\(operand2))")
    } else if isHL(operand1) && isCombinedRegister(operand2) {
      print("case .\(opcode.enumCase): self.add_hl_r(.\(operand2))")
    }
    else { printUnimplementedOpcode(opcode) }

  case "adc":
    // opcode.operand1 is always 'A' (000)
    let operand = opcode.operand2!.lowercased()

    if opcode.addr == "0x8e" {
      print("case .\(opcode.enumCase): self.adc_a_pHL()")
    } else if opcode.addr == "0xce" {
      print("case .\(opcode.enumCase): self.adc_a_d8(\(next8))")
    }
    else if isRegister(operand) {
      print("case .\(opcode.enumCase): self.adc_a_r(.\(operand))")
    }
    else { printUnimplementedOpcode(opcode) }

  case "sub":
    let operand = opcode.operand1!.lowercased()

    if opcode.addr == "0x96" {
      print("case .\(opcode.enumCase): self.sub_a_pHL()")
    } else if opcode.addr == "0xd6" {
      print("case .\(opcode.enumCase): self.sub_a_d8(\(next8))")
    }
    else if isRegister(operand) {
      print("case .\(opcode.enumCase): self.sub_a_r(.\(operand))")
    }
    else { printUnimplementedOpcode(opcode) }

  case "sbc":
    // opcode.operand1 is always 'A' (000)
    let operand = opcode.operand2!.lowercased()

    if opcode.addr == "0x9e" {
      print("case .\(opcode.enumCase): self.sbc_a_pHL()")
    } else if opcode.addr == "0xde" {
      print("case .\(opcode.enumCase): self.sbc_a_d8(\(next8))")
    }
    else if isRegister(operand) {
      print("case .\(opcode.enumCase): self.sbc_a_r(.\(operand))")
    }
    else { printUnimplementedOpcode(opcode) }

  case "and":
    let operand = opcode.operand1!.lowercased()

    if opcode.addr == "0xa6" {
      print("case .\(opcode.enumCase): self.and_a_pHL()")
    } else if opcode.addr == "0xe6" {
      print("case .\(opcode.enumCase): self.and_a_d8(\(next8))")
    }
    else if isRegister(operand) {
      print("case .\(opcode.enumCase): self.and_a_r(.\(operand))")
    }
    else { printUnimplementedOpcode(opcode) }

  case "or":
    let operand = opcode.operand1!.lowercased()

    if opcode.addr == "0xb6" {
      print("case .\(opcode.enumCase): self.or_a_pHL()")
    } else if opcode.addr == "0xf6" {
      print("case .\(opcode.enumCase): self.or_a_d8(\(next8))")
    }
    else if isRegister(operand) {
      print("case .\(opcode.enumCase): self.or_a_r(.\(operand))")
    }
    else { printUnimplementedOpcode(opcode) }

  case "xor":
    let operand = opcode.operand1!.lowercased()

    if opcode.addr == "0xae" {
      print("case .\(opcode.enumCase): self.xor_a_pHL()")
    } else if opcode.addr == "0xee" {
      print("case .\(opcode.enumCase): self.xor_a_d8(\(next8))")
    }
    else if isRegister(operand) {
      print("case .\(opcode.enumCase): self.xor_a_r(.\(operand))")
    }
    else { printUnimplementedOpcode(opcode) }

  case "cp":
    let operand = opcode.operand1!.lowercased()

    if opcode.addr == "0xbe" {
      print("case .\(opcode.enumCase): self.cp_a_pHL()")
    } else if opcode.addr == "0xfe" {
      print("case .\(opcode.enumCase): self.cp_a_d8(\(next8))")
    }
    else if isRegister(operand) {
      print("case .\(opcode.enumCase): self.cp_a_r(.\(operand))")
    }
    else { printUnimplementedOpcode(opcode) }

  case "inc":
    let operand = opcode.operand1!.lowercased()

    if opcode.addr == "0x34" {
      print("case .\(opcode.enumCase): self.inc_pHL()")
    } else if opcode.addr == "0x33" {
      print("case .\(opcode.enumCase): self.inc_sp()")
    }
    else if isRegister(operand) {
      print("case .\(opcode.enumCase): self.inc_r(.\(operand))")
    } else if isCombinedRegister(operand) {
      print("case .\(opcode.enumCase): self.inc_rr(.\(operand))")
    }
    else { printUnimplementedOpcode(opcode) }

  case "dec":
    let operand = opcode.operand1!.lowercased()

    if opcode.addr == "0x35" {
      print("case .\(opcode.enumCase): self.dec_pHL()")
    } else if opcode.addr == "0x3b" {
      print("case .\(opcode.enumCase): self.dec_sp()")
    }
    else if isRegister(operand) {
      print("case .\(opcode.enumCase): self.dec_r(.\(operand))")
    } else if isCombinedRegister(operand) {
      print("case .\(opcode.enumCase): self.dec_rr(.\(operand))")
    }
    else { printUnimplementedOpcode(opcode) }

  case "rlca": print("case .\(opcode.enumCase): self.rlca()")
  case "rla":  print("case .\(opcode.enumCase): self.rla()")
  case "rrca": print("case .\(opcode.enumCase): self.rrca()")
  case "rra":  print("case .\(opcode.enumCase): self.rra()")

  case "jp":
    if opcode.addr == "0xe9" {
      print("case .\(opcode.enumCase): self.jp_pHL()")
    } else if opcode.addr == "0xc3" {
      print("case .\(opcode.enumCase): self.jp_nn(\(next16))")
    }
    else if isa16(opcode.operand2!) {
      let condition = opcode.operand1!.lowercased()
      print("case .\(opcode.enumCase): self.jp_cc_nn(.\(condition), \(next16))")
    }
    else { printUnimplementedOpcode(opcode) }

  case "jr":
    if opcode.addr == "0x18" {
      print("case .\(opcode.enumCase): self.jr_e(\(next8))")
    } else if isr8(opcode.operand2!) {
      let condition = opcode.operand1!.lowercased()
      print("case .\(opcode.enumCase): self.jr_cc_e(.\(condition), \(next8))")
    }
    else { printUnimplementedOpcode(opcode) }

  case "push":
    let operand = opcode.operand1!.lowercased()
    print("case .\(opcode.enumCase): self.push(.\(operand))")

  case "pop":
    let operand = opcode.operand1!.lowercased()
    print("case .\(opcode.enumCase): self.pop(.\(operand))")

//  case "stop":
//  case "daa":
//  case "cpl":
//  case "scf":
//  case "ccf":
//  case "halt":
//  case "ret":
//  case "call":
//  case "rst":
//  case "prefix":
//  case "reti":
//  case "di":
//  case "ei":

  default:
    printUnimplementedOpcode(opcode)
  }
}

private var unimplementedOpcodes = 0

private func printUnimplementedOpcode(_ opcode: Opcode) {
  unimplementedOpcodes += 1
  print("//case .\(opcode.enumCase): break")
}

private let singleRegisters  = ["a", "b", "c", "d", "e", "h", "l"]
private let combinedRegisters = ["af", "bc", "de", "hl"]

private func isRegister(_ operand: String?) -> Bool {
  return singleRegisters.contains { isEqual(operand, $0) }
}

private func isCombinedRegister(_ operand: String?) -> Bool {
  return combinedRegisters.contains { isEqual(operand, $0) }
}

private func isA(_ operand: String?) -> Bool {
  return isEqual(operand, "a")
}

private func isHL(_ operand: String?) -> Bool {
  return isEqual(operand, "hl")
}

private func ispHL(_ operand: String?) -> Bool {
  return isEqual(operand, "(hl)")
}

private func ispBC(_ operand: String?) -> Bool {
  return isEqual(operand, "(bc)")
}

private func ispDE(_ operand: String?) -> Bool {
  return isEqual(operand, "(de)")
}

private func isd8(_ operand: String?) -> Bool {
  return isEqual(operand, "d8")
}

private func isd16(_ operand: String?) -> Bool {
  return isEqual(operand, "d16")
}

private func isa16(_ operand: String?) -> Bool {
  return isEqual(operand, "a16")
}

private func isr8(_ operand: String?) -> Bool {
  return isEqual(operand, "r8")
}

private func isSP(_ operand: String?) -> Bool {
  return isEqual(operand, "sp")
}

private func isEqual(_ operand: String?, _ value: String) -> Bool {
  return operand?.lowercased() == value
}
