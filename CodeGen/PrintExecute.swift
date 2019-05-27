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
    let call = getOpcodeCall(op)
    print("/* \(op.addr) */ case .\(op.enumCase): \(call)")
  }

  print("    }")
  print("  }")
  print("}")
}

private func getOpcodeCall(_ opcode: Opcode) -> String {
  let next8 = "self.next8"
  let next16 = "self.next16"

  let mnemonic = opcode.mnemonic.lowercased()
  switch mnemonic {
  case "nop":
    return "break"

  case "ld":
    switch opcode.addr {
    case "0x2": return "self.ld_pBC_a()"
    case "0x8": return "self.ld_pA16_sp(\(next16))"
    case "0xa": return "self.ld_a_pBC()"
    case "0x12": return "self.ld_pDE_a()"
    case "0x1a": return "self.ld_a_pDE()"
    case "0x2a": return "self.ld_a_pHLI()"
    case "0x22": return "self.ld_pHLI_a()"
    case "0x31": return "self.ld_sp_d16(\(next16))"
    case "0x32": return "self.ld_pHLD_a()"
    case "0x36": return "self.ld_pHL_d8(\(next8))"
    case "0x3a": return "self.ld_a_pHLD()"
    case "0xe2": return "self.ld_ffC_a()"
    case "0xea": return "self.ld_pA16_a(\(next16))"
    case "0xf2": return "self.ld_a_ffC()"
    case "0xf8": return "self.ld_hl_sp_plus_e(\(next8))"
    case "0xf9": return "self.ld_sp_hl()"
    case "0xfa": return "self.ld_a_pA16(\(next16))"
    default:
      let operand1 = opcode.operand1!.lowercased()
      let operand2 = opcode.operand2!.lowercased()

      if isRegister(operand1) && isRegister(operand2)    { return "self.ld_r_r(.\(operand1), .\(operand2))" }
      if isRegister(operand1) && isd8(operand2)          { return "self.ld_r_d8(.\(operand1), \(next8))" }
      if isRegister(operand1) && ispHL(operand2)         { return "self.ld_r_pHL(.\(operand1))" }
      if isCombinedRegister(operand1) && isd16(operand2) { return "self.ld_rr_d16(.\(operand1), \(next16))" }
      if ispHL(operand1) && isRegister(operand2)         { return "self.ld_pHL_r(.\(operand2))" }
    }

  // no idea why those are 'ldh' instead of 'ld' (as in official documentation)
  case "ldh":
    switch opcode.addr {
    case "0xf0": return "self.ld_a_pA8(\(next8))"
    case "0xe0": return "self.ld_pA8_a(\(next8))"
    default: return "break"
    }

  case "add":
    switch opcode.addr {
    case "0x39": return "self.add_hl_sp()"
    case "0x86": return "self.add_a_pHL()"
    case "0xc6": return "self.add_a_d8(\(next8))"
    case "0xe8": return "self.add_sp_r8(\(next8))"
    default:
      let operand1 = opcode.operand1!.lowercased()
      let operand2 = opcode.operand2!.lowercased()

      if  isA(operand1) && isRegister(operand2)         { return "self.add_a_r(.\(operand2))" }
      if isHL(operand1) && isCombinedRegister(operand2) { return "self.add_hl_r(.\(operand2))" }
    }

  case "adc":
    switch opcode.addr {
    case "0x8e": return "self.adc_a_pHL()"
    case "0xce": return "self.adc_a_d8(\(next8))"
    default:
      // opcode.operand1 is always 'A' (000)
      let operand = opcode.operand2!.lowercased()
      assert(isRegister(operand))
      return "self.adc_a_r(.\(operand))"
    }

  case "sub":
    switch opcode.addr {
    case "0x96": return "self.sub_a_pHL()"
    case "0xd6": return "self.sub_a_d8(\(next8))"
    default:
      let operand = opcode.operand1!.lowercased()
      assert(isRegister(operand))
      return "self.sub_a_r(.\(operand))"
    }

  case "sbc":
    switch opcode.addr {
    case "0x9e": return "self.sbc_a_pHL()"
    case "0xde": return "self.sbc_a_d8(\(next8))"
    default:
      // opcode.operand1 is always 'A' (000)
      let operand = opcode.operand2!.lowercased()
      assert(isRegister(operand))
      return "self.sbc_a_r(.\(operand))"
    }

  case "and":
    switch opcode.addr {
    case "0xa6": return "self.and_a_pHL()"
    case "0xe6": return "self.and_a_d8(\(next8))"
    default:
      let operand = opcode.operand1!.lowercased()
      assert(isRegister(operand))
      return "self.and_a_r(.\(operand))"
    }

  case "or":
    switch opcode.addr {
    case "0xb6": return "self.or_a_pHL()"
    case "0xf6": return "self.or_a_d8(\(next8))"
    default:
      let operand = opcode.operand1!.lowercased()
      assert(isRegister(operand))
      return "self.or_a_r(.\(operand))"
    }

  case "xor":
    switch opcode.addr {
    case "0xae": return "self.xor_a_pHL()"
    case "0xee": return "self.xor_a_d8(\(next8))"
    default:
      let operand = opcode.operand1!.lowercased()
      assert(isRegister(operand))
      return "self.xor_a_r(.\(operand))"
    }

  case "cp":
    switch opcode.addr {
    case "0xbe": return "self.cp_a_pHL()"
    case "0xfe": return "self.cp_a_d8(\(next8))"
    default:
      let operand = opcode.operand1!.lowercased()
      assert(isRegister(operand))
      return "self.cp_a_r(.\(operand))"
    }

  case "inc":
    switch opcode.addr {
    case "0x34": return "self.inc_pHL()"
    case "0x33": return "self.inc_sp()"
    default:
      let operand = opcode.operand1!.lowercased()
      if isRegister(operand) { return "self.inc_r(.\(operand))" }
      if isCombinedRegister(operand) { return "self.inc_rr(.\(operand))"
      }
    }

  case "dec":
    switch opcode.addr {
    case "0x35": return "self.dec_pHL()"
    case "0x3b": return "self.dec_sp()"
    default:
      let operand = opcode.operand1!.lowercased()
      if isRegister(operand) { return "self.dec_r(.\(operand))" }
      if isCombinedRegister(operand) { return "self.dec_rr(.\(operand))" }
    }

  case "rlca": return "self.rlca()"
  case "rla":  return "self.rla()"
  case "rrca": return "self.rrca()"
  case "rra":  return "self.rra()"

  case "jp":
    switch opcode.addr {
    case "0xe9": return "self.jp_pHL()"
    case "0xc3": return "self.jp_nn(\(next16))"
    default:
      let condition = opcode.operand1!.lowercased()
      assert(isJumpCondition(condition))
      return "self.jp_cc_nn(.\(condition), \(next16))"
    }

  case "jr":
    switch opcode.addr {
    case "0x18": return "self.jr_e(\(next8))"
    default:
      assert(isr8(opcode.operand2!))
      let condition = opcode.operand1!.lowercased()
      return "self.jr_cc_e(.\(condition), \(next8))"
    }

  case "push":
    let operand = opcode.operand1!.lowercased()
    return "self.push(.\(operand))"

  case "pop":
    let operand = opcode.operand1!.lowercased()
    return "self.pop(.\(operand))"

  case "call":
    switch opcode.addr {
    case "0xcd": return "self.call_a16(\(next16))"
    default:
      let condition = opcode.operand1!.lowercased()
      assert(isJumpCondition(condition))
      return "self.call_cc_a16(.\(condition), \(next16))"
    }

  case "ret":
    switch opcode.addr {
    case "0xc9": return "self.ret()"
    default:
      let condition = opcode.operand1!.lowercased()
      assert(isJumpCondition(condition))
      return "self.ret_cc(.\(condition))"
    }

  case "reti":
    return "self.reti()"

  case "rst":
    let operand = opcode.operand1!.lowercased()
    let argument = "0x" + operand.dropLast()
    return "self.rst(\(argument))"

  case "stop":   return "break // <--"
  case "daa":    return "break // <--"
  case "cpl":    return "break // <--"
  case "scf":    return "break // <--"
  case "ccf":    return "break // <--"
  case "halt":   return "break // <--"
  case "prefix": return "break // <--"
  case "di":     return "break // <--"
  case "ei":     return "break // <--"

  default: break
  }
  return ""
}

private let singleRegisters  = ["a", "b", "c", "d", "e", "h", "l"]
private let combinedRegisters = ["af", "bc", "de", "hl"]
private let jumpConditions = ["nz", "z", "nc", "c"]

private func isRegister(_ operand: String?) -> Bool {
  return singleRegisters.contains { isEqual(operand, $0) }
}

private func isCombinedRegister(_ operand: String?) -> Bool {
  return combinedRegisters.contains { isEqual(operand, $0) }
}

private func isJumpCondition(_ operand: String?) -> Bool {
  return jumpConditions.contains { isEqual(operand, $0) }
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

private func isd8(_ operand: String?) -> Bool {
  return isEqual(operand, "d8")
}

private func isd16(_ operand: String?) -> Bool {
  return isEqual(operand, "d16")
}

private func isr8(_ operand: String?) -> Bool {
  return isEqual(operand, "r8")
}

private func isEqual(_ operand: String?, _ value: String) -> Bool {
  return operand?.lowercased() == value
}
