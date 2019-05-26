func printExecutePrefix() throws {
  let opcodes = try openOpcodesFile()

  printHeader()
  print("extension Cpu {")
  printExecuteFunction(opcodes.cbprefixed)
  print("}")
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
  print("mutating func execute(_ opcode: PrefixOpcode) {")
  print("switch opcode.type {")

  for op in opcodes {
    let mnemonic = op.mnemonic.lowercased()
    switch mnemonic {
    case "rlc", "rrc", "rl", "rr", "sla", "sra", "srl", "swap":
      print_r_pLH(op)
    case "bit", "res", "set":
      print_bit(op)
    default:
      printUnimplementedOpcode(op)
    }
  }

  print("}")
  print("}")
}

private func print_r_pLH(_ opcode: Opcode) {
  let mnemonic = opcode.mnemonic.lowercased()
  let operand = opcode.operand1!.lowercased()

  if isRegister(operand) {
    print("case .\(opcode.enumCase): \(mnemonic)_r(.\(operand))")
  } else if ispHL(operand) {
    print("case .\(opcode.enumCase): \(mnemonic)_pHL()")
  }
  else { printUnimplementedOpcode(opcode) }
}

private func print_bit(_ opcode: Opcode) {
  let mnemonic = opcode.mnemonic.lowercased()
  let operand1 = opcode.operand1!.lowercased()
  let operand2 = opcode.operand2!.lowercased()

  if isRegister(operand2) {
    print("case .\(opcode.enumCase): \(mnemonic)_r(\(operand1), .\(operand2))")
  } else if ispHL(operand2) {
    print("case .\(opcode.enumCase): \(mnemonic)_pHL(\(operand1))")
  }
  else { printUnimplementedOpcode(opcode) }
}

private func printUnimplementedOpcode(_ opcode: Opcode) {
  print("//case .\(opcode.enumCase): break")
}

private func isRegister(_ operand: String) -> Bool {
  let op = operand.lowercased()
  return op == "a" || op == "b"
      || op == "c" || op == "d"
      || op == "e"
      || op == "h" || op == "l"
}

private func ispHL(_ operand: String) -> Bool {
  let op = operand.lowercased()
  return op == "(hl)"
}
