func printOpcodes(_ opcodes: Opcodes) {
  printHeader()
  printOpcodeTypeEnum("OpcodeType", opcodes.unprefixed)
  printOpcodes("Opcode", "opcodes", opcodes.unprefixed)
}

func printPrefixOpcodes(_ opcodes: Opcodes) {
  printHeader()
  printOpcodeTypeEnum("PrefixOpcodeType", opcodes.cbprefixed)
  printOpcodes("PrefixOpcode", "prefixOpcodes", opcodes.cbprefixed)
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

    var addrColumn = "addr: \"\(op.addr)\", "
    addrColumn = pad(addrColumn, toLength: 17)

    var typeColumn = "type: .\(op.enumCase), "
    typeColumn = pad(typeColumn, toLength: 26)

    var debugColumn = "debug: \"\(op.debug)\", "
    debugColumn = pad(debugColumn, toLength: 25)

    var column3 = ""
    column3 += "length: \(op.length), "
    column3 += "cycles: \(op.cycles)"

    print("  \(className)(\(addrColumn)\(typeColumn)\(debugColumn)\(column3)),")
  }
  print("]")
  print("")
}

private func pad(_ s: String, toLength: Int) -> String {
  // String.padding ignores negative padding
  let diff = toLength - s.count
  assert(diff >= 0, "'\(s)' has length \(s.count) (vs \(toLength))")
  return s + String(repeating: " " , count: diff)
}

private func quote(_ s: String) -> String {
  return "\"" + s + "\""
}
