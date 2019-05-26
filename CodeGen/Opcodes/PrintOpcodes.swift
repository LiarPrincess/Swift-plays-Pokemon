func printOpcodes() throws {
let opcodes = try openOpcodesFile()

  printHeader()
  printOpcodeTypeEnum(opcodes.unprefixed)
  printOpcodes(opcodes.unprefixed)
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

private func printOpcodeTypeEnum(_ opcodes: [Opcode]) {
  print("enum OpcodeType {")
  for op in opcodes {
    print("  case \(op.enumCase)")
  }
  print("}")
  print("")
}

private func printOpcodes(_ opcodes: [Opcode]) {
  print("let opcodes: [Opcode] = [")
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

    print("  Opcode(\(column1)\(column2)\(column3)),")
  }
  print("]")
  print("")
}

private func quote(_ s: String) -> String {
  return "\"" + s + "\""
}
