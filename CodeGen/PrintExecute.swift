func printExecuteExtension(_ opcodes: Opcodes) {
  printHeader()
  printCpuExtension("UnprefixedOpcode", opcodes.unprefixed, getUnprefixedOpcodeCall(_:))
}

func printExecutePrefixExtension(_ opcodes: Opcodes) {
  printHeader()
  printCpuExtension("CBPrefixedOpcode", opcodes.cbprefixed, getCBPrefixedOpcodeCall(_:))
}

// MARK: - Printing

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

private typealias GetCall = (Opcode) -> String

private func printCpuExtension(_ className: String, _ opcodes: [Opcode], _ getCall: GetCall) {
  print("extension Cpu {")
  print("  internal func execute(_ opcode: \(className)) {")
  print("    switch opcode.value {")

  for opcode in opcodes {
    let call = getCall(opcode)
    print("/* \(opcode.addr) */ case .\(getEnumCase(opcode)): self.\(call)")
  }

  print("    }")
  print("  }")
  print("}")
}
