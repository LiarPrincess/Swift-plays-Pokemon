// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

func printOpcodes(_ opcodes: Opcodes) {
  printHeader()

  print("/// One of standard 256 opcodes.")
  print("/// See official \"Gameboy programming manual\" for details of each operation.")
  printOpcodeEnum("UnprefixedOpcode", opcodes.unprefixed)
}

func printPrefixOpcodes(_ opcodes: Opcodes) {
  printHeader()

  print("/// One of additional 256 opcodes that should be executed if standard opcode is 0xCB.")
  print("/// See official \"Gameboy programming manual\" for details of each operation.")
  printOpcodeEnum("CBPrefixedOpcode", opcodes.cbprefixed)
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
  print("")
}

private func printOpcodeEnum(_ className: String, _ opcodes: [Opcode]) {
  print("public enum \(className): UInt8, RawRepresentable {")

  // Some opcodes are missing
  let opcodeByAddress = byAddress(opcodes)

  for i in 0...0xff {
    let address = "0x" + String(i, radix: 16, uppercase: false)

    if let opcode = opcodeByAddress[address] {
      print("  case \(getEnumCase(opcode)) = \(opcode.addr)")
    } else {
      print("  /* \(address) - this opcode does not exists */")
    }
  }
  print("}")
  print("")
}

private func byAddress(_ opcodes: [Opcode]) -> [String:Opcode] {
  var result = [String:Opcode]()
  for op in opcodes {
    result[op.addr] = op
  }
  return result
}
