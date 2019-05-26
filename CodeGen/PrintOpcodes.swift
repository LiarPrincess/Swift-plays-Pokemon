func printOpcodes() throws {
  let data = try openOpcodesFile()
  let opcodes = data.unprefixed

  printHeader()
  printOpcodeTypeEnum("OpcodeType", opcodes)
  printOpcodes("Opcode", "opcodes", opcodes)
}

func printPrefixOpcodes() throws {
  let data = try openOpcodesFile()
  let opcodes = data.cbprefixed

  printHeader()
  printOpcodeTypeEnum("PrefixOpcodeType", opcodes)
  printOpcodes("PrefixOpcode", "prefixOpcodes", opcodes)
}

// MARK: - Printing

private func printHeader() {
  print("// This file was auto-generated.")
  print("// DO NOT EDIT!")
  print("")

  print("// swiftlint:disable superfluous_disable_command")
  print("// swiftlint:disable trailing_comma")
  print("// swiftlint:disable file_length")
  print("")
}

private func printOpcodeTypeEnum(_ name: String, _ opcodes: [Opcode]) {
  print("enum \(name) {")
  for op in opcodes {
    print("  case \(op.enumCase)")
  }
  print("}")
  print("")
}

private func printOpcodes(_ className: String, _ variable: String, _ opcodes: [Opcode]) {
  print("let \(variable): [\(className)] = [")
  for op in opcodes {

    var column1 = ""
    column1 += quote(op.addr) + ", "
    column1 += quote(op.mnemonic.lowercased()) + ","
    column1 = column1.padding(toLength: 20, withPad: " ", startingAt: 0)

    var column2 = ""
    column2 += "type: .\(op.enumCase), "
    column2 = column2.padding(toLength: 30, withPad: " ", startingAt: 0)

    var column3 = ""
    column3 += "length: \(op.length), "
    column3 += "cycles: \(op.cycles)"

    print("  \(className)(\(column1)\(column2)\(column3)),")
  }
  print("]")
  print("")
}

private func quote(_ s: String) -> String {
  return "\"" + s + "\""
}
