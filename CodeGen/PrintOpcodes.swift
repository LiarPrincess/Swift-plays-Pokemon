func printOpcodes(_ opcodes: Opcodes) {
  let className = "UnprefixedOpcode"

  printHeader()
  printOpcodeTypeEnum(className, opcodes.unprefixed)
  printOpcodes(className, "unprefixedOpcodes", opcodes.unprefixed, hasGaps: true)
}

func printPrefixOpcodes(_ opcodes: Opcodes) {
  let className = "CBPrefixedOpcode"

  printHeader()
  printOpcodeTypeEnum(className, opcodes.cbprefixed)
  printOpcodes(className, "cbPrefixedOpcodes", opcodes.cbprefixed, hasGaps: false)
}

// MARK: - Printing

private func printHeader() {
  print("// This file was auto-generated.")
  print("// DO NOT EDIT!")
  print("")

  print("// swiftlint:disable superfluous_disable_command")
  print("// swiftlint:disable file_length")
  print("// swiftlint:disable type_body_length")
  print("// swiftlint:disable trailing_newline")
  print("// swiftlint:disable trailing_comma")
  print("")
}

private func printOpcodeTypeEnum(_ className: String, _ opcodes: [Opcode]) {
  print("public enum \(className)Type {")
  for op in opcodes {
    print("/** \(op.addr) */ case \(op.enumCase)")
  }
  print("}")
  print("")
}

private func printOpcodes(_ className: String, _ variable: String, _ opcodes: [Opcode], hasGaps: Bool) {
  let optional = hasGaps ? "?" : ""
  print("public let \(variable): [\(className)\(optional)] = [")

  // Some adresses are missing
  let opcodeByAddress = byAddress(opcodes)

  for i in 0...0xff {
    let address = "0x" + String(i, radix: 16, uppercase: false)
    let addressString = "/* \(address) */"

    guard let opcode = opcodeByAddress[address] else {
      print("\(addressString) nil,")
      continue
    }

    var addrColumn = "addr: \"\(opcode.addr)\", "
    addrColumn = pad(addrColumn, toLength: 17)

    var typeColumn = "type: .\(opcode.enumCase), "
    typeColumn = pad(typeColumn, toLength: 26)

    var debugColumn = "debug: \"\(opcode.debug)\", "
    debugColumn = pad(debugColumn, toLength: 25)

    var column3 = ""
    column3 += "length: \(opcode.length), "
    column3 += "cycles: \(opcode.cycles)"

    print("\(addressString) \(className)(\(addrColumn)\(typeColumn)\(debugColumn)\(column3)),")
  }

  print("]")
  print("")
}

private func byAddress(_ opcodes: [Opcode]) -> [String:Opcode] {
  var result = [String:Opcode]()
  for op in opcodes {
    result[op.addr] = op
  }
  return result
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
