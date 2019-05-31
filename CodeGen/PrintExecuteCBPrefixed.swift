// swiftlint:disable force_unwrapping

func printExecutePrefix(_ opcodes: Opcodes) {
  printHeader()
  printCpuExtension(opcodes.cbprefixed)
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
  print("  internal func execute(_ opcode: CBPrefixedOpcode) {")
  print("    switch opcode.value {")

  for op in opcodes {
    let call = getOpcodeCall(op)
    print("/* \(op.addr) */ case .\(op.enumCase): self.\(call)")
  }

  print("    }")
  print("  }")
  print("}")
}

private func getOpcodeCall(_ opcode: Opcode) -> String {
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

private func isRegister(_ operand: String?) -> Bool {
  return singleRegisters.contains { isEqual(operand, $0) }
}

private func ispHL(_ operand: String?) -> Bool {
  return isEqual(operand, "(hl)")
}

private func isEqual(_ operand: String?, _ value: String) -> Bool {
  return operand?.lowercased() == value
}
