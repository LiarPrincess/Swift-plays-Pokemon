// swiftlint:disable cyclomatic_complexity
// swiftlint:disable function_body_length

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
  print("// swiftlint:disable switch_case_alignment")
  print("")
}

private func printCpuExtension(_ opcodes: [Opcode]) {
  print("extension Cpu {")
  print("  mutating func execute(_ opcode: PrefixOpcode) {")
  print("    switch opcode.type {")

  for op in opcodes {
    printOpcodeCase(op)
  }

  print("    }")
  print("  }")
  print("}")
}

private func printOpcodeCase(_ opcode: Opcode) {
  let function = getFunctionName(opcode)

  let argument1 = getFunctionArgument(opcode.operand1)
  let argument2 = getFunctionArgument(opcode.operand2)

  var arguments = ""
  arguments += argument1 ?? ""
  arguments += argument1 != nil && argument2 != nil ? ", " : ""
  arguments += argument2 ?? ""

  print("/* \(opcode.addr) */ case .\(opcode.enumCase): self.\(function)(\(arguments))")
}

private func getFunctionName(_ opcode: Opcode) -> String {
  var result = opcode.mnemonic.lowercased()

  // For consistency with other functions
  if result == "sub" {
    result = "sub_a"
  }

  if let operand1 = getFunctionNameOperand(opcode.operand1) {
    result += "_"
    result += operand1
  }

  if let operand2 = getFunctionNameOperand(opcode.operand2) {
    result += "_"
    result += operand2
  }

  return result
}

private func getFunctionNameOperand(_ value: String?) -> String? {
  switch value {
  case "A": return "r"
  case "B": return "r"
  case "C": return "r"
  case "D": return "r"
  case "E": return "r"
  case "H": return "r"
  case "L": return "r"

  case "AF": return "af"
  case "BC": return "rr"
  case "CB": return "rr"
  case "DE": return "rr"
  case "HL": return "rr"

  case "0": return nil
  case "1": return nil
  case "2": return nil
  case "3": return nil
  case "4": return nil
  case "5": return nil
  case "6": return nil
  case "7": return nil

    //  case "00H": return "00h"
    //  case "08H": return "08h"
    //  case "10H": return "10h"
    //  case "18H": return "18h"
    //  case "20H": return "20h"
    //  case "28H": return "28h"
    //  case "30H": return "30h"
    //  case "38H": return "38h"
    //
    //  case "SP":    return "sp"
    //  case "SP+r8": return "spR8"
  //
  case "d8":  return "d8"
  case "d16": return "d16"
  case "r8":  return "r8"
  case "a16": return "a16"
    //  case "NC":  return "nc"
    //  case "NZ":  return "nz"
    //  case "Z":   return "z"

  case "(BC)":  return "pBC"
  case "(C)":   return "pC"
  case "(DE)":  return "pDE"
  case "(HL)":  return "pHL"
  case "(HL+)": return "pHLI"
  case "(HL-)": return "pHLD"
  case "(a8)":  return "pA8"
  case "(a16)": return "pA16"

  default: return nil
  }
}

private func getFunctionArgument(_ value: String?) -> String? {
  switch value {
  case "A": return ".a"
  case "B": return ".b"
  case "C": return ".c"
  case "D": return ".d"
  case "E": return ".e"
  case "H": return ".h"
  case "L": return ".l"

  case "AF": return ".af"
  case "BC": return ".bc"
  case "CB": return ".cb"
  case "DE": return ".de"
  case "HL": return ".hl"

  case "0": return "0"
  case "1": return "1"
  case "2": return "2"
  case "3": return "3"
  case "4": return "4"
  case "5": return "5"
  case "6": return "6"
  case "7": return "7"

    //  case "00H": return "00h"
    //  case "08H": return "08h"
    //  case "10H": return "10h"
    //  case "18H": return "18h"
    //  case "20H": return "20h"
    //  case "28H": return "28h"
    //  case "30H": return "30h"
    //  case "38H": return "38h"
    //
    //  case "SP":    return "sp"
    //  case "SP+r8": return "spR8"

  case "d8":  return "self.next8"
  case "d16": return "self.next16"
    //  case "r8":  return "r8"
    //  case "a16": return "a16"
    //  case "NC":  return "nc"
    //  case "NZ":  return "nz"
    //  case "Z":   return "z"

    //  case "(BC)":  return "pBC"
    //  case "(C)":   return "pC"
    //  case "(DE)":  return "pDE"
    //  case "(HL)":  return "pHL"
    //  case "(HL+)": return "pHLI"
    //  case "(HL-)": return "pHLD"
    //  case "(a8)":  return "pA8"
    //  case "(a16)": return "pA16"

  default: return nil
  }
}
