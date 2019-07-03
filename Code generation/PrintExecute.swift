// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

func printExecuteExtension(_ opcodes: Opcodes) {
  printHeader()
  printCpuExtension("executeUnprefixed", opcodes.unprefixed, getUnprefixedOpcodeCall(_:))
}

func printExecutePrefixExtension(_ opcodes: Opcodes) {
  printHeader()
  printCpuExtension("executePrefixed", opcodes.cbprefixed, getCBPrefixedOpcodeCall(_:))
}

// MARK: - Printing

private func printHeader() {
  print("// This Source Code Form is subject to the terms of the Mozilla Public")
  print("// License, v. 2.0. If a copy of the MPL was not distributed with this")
  print("// file, You can obtain one at http://mozilla.org/MPL/2.0/.")
  print("")

  print("// This file was auto-generated.")
  print("// DO NOT EDIT!")
  print("")

  print("// swiftlint:disable file_length")
  print("// swiftlint:disable function_body_length")
  print("// swiftlint:disable cyclomatic_complexity")
  print("")
}

private typealias GetCall = (Opcode) -> String

private func printCpuExtension(_ functionName: String, _ opcodes: [Opcode], _ getCall: GetCall) {
  print("extension Cpu {")
  print("")
  print("  /// Executes the instruction, returns the number of cycles it took.")
  print("  internal func \(functionName)(_ opcode: UInt8) -> Int {")
  print("    switch opcode {")

  for opcode in opcodes {
    let call = getCall(opcode)
    print("    case \(opcode.addr): return self.\(call)")
  }

  print("    default: fatalError(\"Tried to execute non existing opcode: \\(opcode.hex).\")")
  print("    }")
  print("  }")
  print("}")
}
