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
  print("")
}

private func printCpuExtension(_ opcodes: [Opcode]) {
  print("extension Cpu {")
  print("  mutating func execute(_ opcode: PrefixOpcode) {")
  print("    switch opcode.type {")

  for op in opcodes {
    let mnemonic = op.mnemonic.lowercased()
    switch mnemonic {
    case "rlc", "rrc", "rl", "rr", "sla", "sra", "srl", "swap":
      let operand = op.operand1!.lowercased()

      if isRegister(operand) {
        print("    case .\(op.enumCase): \(mnemonic)_r(.\(operand))")
      } else if ispHL(operand) {
        print("    case .\(op.enumCase): \(mnemonic)_pHL()")
      }
      else { printUnimplementedOpcode(op) }

    case "bit", "res", "set":
      let operand1 = op.operand1!.lowercased()
      let operand2 = op.operand2!.lowercased()

      if isRegister(operand2) {
        print("    case .\(op.enumCase): \(mnemonic)_r(\(operand1), .\(operand2))")
      } else if ispHL(operand2) {
        print("    case .\(op.enumCase): \(mnemonic)_pHL(\(operand1))")
      }
      else { printUnimplementedOpcode(op) }

    default:
      printUnimplementedOpcode(op)
    }
  }

  print("    }")
  print("  }")
  print("}")
}

private func printUnimplementedOpcode(_ opcode: Opcode) {
  print("    //case .\(opcode.enumCase): break")
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
