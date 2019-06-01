// swiftlint:disable file_length
// swiftlint:disable function_body_length
// swiftlint:disable cyclomatic_complexity
// swiftlint:disable force_unwrapping

// MARK: - getEnumCase

func getEnumCase(_ opcode: Opcode) -> String {
  var result = opcode.mnemonic.lowercased()
  if result == "prefix" { return result }
  if result == "stop"   { return result }

  if let operand1 = opcode.operand1 {
    result += "_"
    result += getOperandValue(operand1)
  }

  if let operand2 = opcode.operand2 {
    result += "_"
    result += getOperandValue(operand2)
  }

  return result
}

private func getOperandValue(_ value: String) -> String {
  switch value {
  case "A": return "a"
  case "B": return "b"
  case "C": return "c"
  case "D": return "d"
  case "E": return "e"
  case "H": return "h"
  case "L": return "l"

  case "AF": return "af"
  case "BC": return "bc"
  case "CB": return "cb"
  case "DE": return "de"
  case "HL": return "hl"

  case "0": return "0"
  case "1": return "1"
  case "2": return "2"
  case "3": return "3"
  case "4": return "4"
  case "5": return "5"
  case "6": return "6"
  case "7": return "7"

  case "00H": return "00"
  case "08H": return "08"
  case "10H": return "10"
  case "18H": return "18"
  case "20H": return "20"
  case "28H": return "28"
  case "30H": return "30"
  case "38H": return "38"

  case "SP":    return "sp"
  case "SP+r8": return "spR8"

  case "d8":  return "d8"
  case "d16": return "d16"
  case "r8":  return "r8"
  case "a16": return "a16"
  case "NC":  return "nc"
  case "NZ":  return "nz"
  case "Z":   return "z"

  case "(BC)":  return "pBC"
  case "(C)":   return "pC"
  case "(DE)":  return "pDE"
  case "(HL)":  return "pHL"
  case "(HL+)": return "pHLI"
  case "(HL-)": return "pHLD"
  case "(a8)":  return "pA8"
  case "(a16)": return "pA16"

  default: return "Unknown value: " + value.lowercased()
  }
}

// MARK: - getOpcodeCall

func getUnprefixedOpcodeCall(_ opcode: Opcode) -> String {
  let next8 = "self.next8"
  let next16 = "self.next16"

  let mnemonic = opcode.mnemonic.lowercased()
  switch mnemonic {
  case "nop":
    return "nop()"

  case "ld":
    switch opcode.addr {
    case "0x2": return "ld_pBC_a()"
    case "0x8": return "ld_pA16_sp(\(next16))"
    case "0xa": return "ld_a_pBC()"
    case "0x12": return "ld_pDE_a()"
    case "0x1a": return "ld_a_pDE()"
    case "0x2a": return "ld_a_pHLI()"
    case "0x22": return "ld_pHLI_a()"
    case "0x31": return "ld_sp_d16(\(next16))"
    case "0x32": return "ld_pHLD_a()"
    case "0x36": return "ld_pHL_d8(\(next8))"
    case "0x3a": return "ld_a_pHLD()"
    case "0xe2": return "ld_ffC_a()"
    case "0xea": return "ld_pA16_a(\(next16))"
    case "0xf2": return "ld_a_ffC()"
    case "0xf8": return "ld_hl_sp_plus_e(\(next8))"
    case "0xf9": return "ld_sp_hl()"
    case "0xfa": return "ld_a_pA16(\(next16))"
    default:
      let operand1 = opcode.operand1!.lowercased()
      let operand2 = opcode.operand2!.lowercased()

      if isRegister(operand1) && isRegister(operand2)    { return "ld_r_r(.\(operand1), .\(operand2))" }
      if isRegister(operand1) && isd8(operand2)          { return "ld_r_d8(.\(operand1), \(next8))" }
      if isRegister(operand1) && ispHL(operand2)         { return "ld_r_pHL(.\(operand1))" }
      if isCombinedRegister(operand1) && isd16(operand2) { return "ld_rr_d16(.\(operand1), \(next16))" }
      if ispHL(operand1) && isRegister(operand2)         { return "ld_pHL_r(.\(operand2))" }
    }

  // no idea why those are 'ldh' instead of 'ld' (as in official documentation)
  case "ldh":
    switch opcode.addr {
    case "0xf0": return "ld_a_pA8(\(next8))"
    case "0xe0": return "ld_pA8_a(\(next8))"
    default: return "nop()"
    }

  case "add":
    switch opcode.addr {
    case "0x39": return "add_hl_sp()"
    case "0x86": return "add_a_pHL()"
    case "0xc6": return "add_a_d8(\(next8))"
    case "0xe8": return "add_sp_r8(\(next8))"
    default:
      let operand1 = opcode.operand1!.lowercased()
      let operand2 = opcode.operand2!.lowercased()

      if  isA(operand1) && isRegister(operand2)         { return "add_a_r(.\(operand2))" }
      if isHL(operand1) && isCombinedRegister(operand2) { return "add_hl_r(.\(operand2))" }
    }

  case "adc":
    switch opcode.addr {
    case "0x8e": return "adc_a_pHL()"
    case "0xce": return "adc_a_d8(\(next8))"
    default:
      // opcode.operand1 is always 'A' (000)
      let operand = opcode.operand2!.lowercased()
      assert(isRegister(operand))
      return "adc_a_r(.\(operand))"
    }

  case "sub":
    switch opcode.addr {
    case "0x96": return "sub_a_pHL()"
    case "0xd6": return "sub_a_d8(\(next8))"
    default:
      let operand = opcode.operand1!.lowercased()
      assert(isRegister(operand))
      return "sub_a_r(.\(operand))"
    }

  case "sbc":
    switch opcode.addr {
    case "0x9e": return "sbc_a_pHL()"
    case "0xde": return "sbc_a_d8(\(next8))"
    default:
      // opcode.operand1 is always 'A' (000)
      let operand = opcode.operand2!.lowercased()
      assert(isRegister(operand))
      return "sbc_a_r(.\(operand))"
    }

  case "and":
    switch opcode.addr {
    case "0xa6": return "and_a_pHL()"
    case "0xe6": return "and_a_d8(\(next8))"
    default:
      let operand = opcode.operand1!.lowercased()
      assert(isRegister(operand))
      return "and_a_r(.\(operand))"
    }

  case "or":
    switch opcode.addr {
    case "0xb6": return "or_a_pHL()"
    case "0xf6": return "or_a_d8(\(next8))"
    default:
      let operand = opcode.operand1!.lowercased()
      assert(isRegister(operand))
      return "or_a_r(.\(operand))"
    }

  case "xor":
    switch opcode.addr {
    case "0xae": return "xor_a_pHL()"
    case "0xee": return "xor_a_d8(\(next8))"
    default:
      let operand = opcode.operand1!.lowercased()
      assert(isRegister(operand))
      return "xor_a_r(.\(operand))"
    }

  case "cp":
    switch opcode.addr {
    case "0xbe": return "cp_a_pHL()"
    case "0xfe": return "cp_a_d8(\(next8))"
    default:
      let operand = opcode.operand1!.lowercased()
      assert(isRegister(operand))
      return "cp_a_r(.\(operand))"
    }

  case "inc":
    switch opcode.addr {
    case "0x34": return "inc_pHL()"
    case "0x33": return "inc_sp()"
    default:
      let operand = opcode.operand1!.lowercased()
      if isRegister(operand) { return "inc_r(.\(operand))" }
      if isCombinedRegister(operand) { return "inc_rr(.\(operand))"
      }
    }

  case "dec":
    switch opcode.addr {
    case "0x35": return "dec_pHL()"
    case "0x3b": return "dec_sp()"
    default:
      let operand = opcode.operand1!.lowercased()
      if isRegister(operand) { return "dec_r(.\(operand))" }
      if isCombinedRegister(operand) { return "dec_rr(.\(operand))" }
    }

  case "rlca": return "rlca()"
  case "rla":  return "rla()"
  case "rrca": return "rrca()"
  case "rra":  return "rra()"

  case "jp":
    switch opcode.addr {
    case "0xe9": return "jp_pHL()"
    case "0xc3": return "jp_nn(\(next16))"
    default:
      let condition = opcode.operand1!.lowercased()
      assert(isJumpCondition(condition))
      return "jp_cc_nn(.\(condition), \(next16))"
    }

  case "jr":
    switch opcode.addr {
    case "0x18": return "jr_e(\(next8))"
    default:
      assert(isr8(opcode.operand2!))
      let condition = opcode.operand1!.lowercased()
      return "jr_cc_e(.\(condition), \(next8))"
    }

  case "push":
    let operand = opcode.operand1!.lowercased()
    return "push(.\(operand))"

  case "pop":
    let operand = opcode.operand1!.lowercased()
    return "pop(.\(operand))"

  case "call":
    switch opcode.addr {
    case "0xcd": return "call_a16(\(next16))"
    default:
      let condition = opcode.operand1!.lowercased()
      assert(isJumpCondition(condition))
      return "call_cc_a16(.\(condition), \(next16))"
    }

  case "ret":
    switch opcode.addr {
    case "0xc9": return "ret()"
    default:
      let condition = opcode.operand1!.lowercased()
      assert(isJumpCondition(condition))
      return "ret_cc(.\(condition))"
    }

  case "reti":
    return "reti()"

  case "rst":
    let operand = opcode.operand1!.lowercased()
    let argument = "0x" + operand.dropLast()
    return "rst(\(argument))"

  case "stop":   return "stop()"
  case "daa":    return "daa()"
  case "cpl":    return "cpl()"
  case "scf":    return "scf()"
  case "ccf":    return "ccf()"
  case "halt":   return "halt()"
  case "prefix": return "prefix(\(next8))"
  case "di":     return "di()"
  case "ei":     return "ei()"

  default: break
  }
  return ""
}

func getCBPrefixedOpcodeCall(_ opcode: Opcode) -> String {
  let mnemonic = opcode.mnemonic.lowercased()
  switch mnemonic {
  case "rlc", "rrc", "rl", "rr", "sla", "sra", "srl", "swap":
    let operand = opcode.operand1!.lowercased()

    if isRegister(operand) { return "\(mnemonic)_r(.\(operand))" }
    if ispHL(operand) { return "\(mnemonic)_pHL()" }

  case "bit", "res", "set":
    let operand1 = opcode.operand1!.lowercased()
    let operand2 = opcode.operand2!.lowercased()

    if isRegister(operand2) { return "\(mnemonic)_r(\(operand1), .\(operand2))" }
    if ispHL(operand2) { return "\(mnemonic)_pHL(\(operand1))" }

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
