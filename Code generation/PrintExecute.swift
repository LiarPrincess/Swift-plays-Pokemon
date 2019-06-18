// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

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

private func printCpuExtension(_ enumName: String, _ opcodes: [Opcode], _ getCall: GetCall) {
  print("extension Cpu {")
  print("  internal func execute(_ opcode: \(enumName)) {")
  print("    switch opcode {")

  for opcode in opcodes {
    let call = getCall(opcode)
    print("/* \(opcode.addr) */ case .\(getEnumCase(opcode)): self.\(call)")
  }

  print("    }")
  print("  }")
  print("}")
}
