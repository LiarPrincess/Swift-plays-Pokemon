// swiftlint:disable cyclomatic_complexity
// swiftlint:disable function_body_length

//  Flags 0: ["-", "Z", "0"]
//  Flags 1: ["-", "0", "1", "N"]
//  Flags 2: ["-", "0", "1", "H"]
//  Flags 3: ["-", "0", "1", "C"]
func printOpcodes() throws {
  print("// This file was auto-generated.")
  print("// DO NOT EDIT!")
  print("")

  print("// swiftlint:disable superfluous_disable_command")
  print("// swiftlint:disable trailing_comma")
  print("// swiftlint:disable file_length")
  print("")

  let opcodes = try openOpcodesFile()
  let opcodeData = getOpcodeData(opcodes.unprefixed)
  printOpcodeTypes(opcodeData)
//  printOperands(opcodeData)
  printOpcodes(opcodes.unprefixed)
}

// MARK: - Opcode data

private class OpcodeData {
  let mnemonic: String
  var operands1 = Set<String>()
  var operands2 = Set<String>()

  init(mnemonic: String) {
    self.mnemonic = mnemonic
  }
}

private func getOpcodeData(_ opcodes: [Opcode]) -> [OpcodeData] {
  var result = [OpcodeData]()
  for op in opcodes {
    // O(n), but we try to preserve order
    var data = result.first { $0.mnemonic == op.mnemonic }
    if data == nil {
      data = OpcodeData(mnemonic: op.mnemonic)
      result.append(data!)
    }

    if op.operand1 != nil {
      data!.operands1.insert(op.operand1!)
    }

    if op.operand2 != nil {
      data!.operands2.insert(op.operand2!)
    }
  }
  return result
}

// MARK: - Printing

private func printOpcodeTypes(_ opcodeData: [OpcodeData]) {
  print("enum OpcodeType {")
  for data in opcodeData {
    print("  case \(data.mnemonic.lowercased())")
  }
  print("}")
  print("")
}

private func printOperands(_ opcodeData: [OpcodeData]) {
  var uniqueOperands = Set<String>()
  for data in opcodeData {
    data.operands1.forEach { uniqueOperands.insert($0) }
    data.operands2.forEach { uniqueOperands.insert($0) }
  }

  print("enum Operand {")
  uniqueOperands.forEach { print("  case \(getOperandValue($0))") }
  print("}")
  print("")
}

private func printOpcodes(_ opcodes: [Opcode]) {
//  let longestMnemonic = getLongestMnemonic(opcodes)

  print("let opcodes: [Opcode] = [")
  for op in opcodes {

    var column1 = ""
    column1 += quote(op.addr) + ", "
    column1 += quote(op.mnemonic.lowercased()) + ","
    column1 += String(repeating: " ", count: 20 - column1.count)

    var column2 = ""
    column2 += ".\(op.mnemonic.lowercased()), "
    column2 += String(repeating: " ", count: 9 - column2.count)
    column2 += "\(op.operand1 == nil ? "nil" : quote(op.operand1!)), "
    column2 += String(repeating: " ", count: 18 - column2.count)
    column2 += "\(op.operand2 == nil ? "nil" : quote(op.operand2!)), "
    column2 += String(repeating: " ", count: 28 - column2.count)

    var column3 = ""
    column3 += "length: \(op.length), "
    column3 += "cycles: \(op.cycles), "
    column3 += String(repeating: " ", count: 31 - column3.count)

    var column4 = ""
    column4 += "flags: \(op.flags)"

    print("  Opcode(\(column1)\(column2)\(column3)\(column4)),")
  }
  print("]")
  print("")
}

// MARK: - Helpers

private func getOperandValue(_ value: String) -> String {
  switch value {
  case "00H": return "l00H"
  case "08H": return "l08H"
  case "10H": return "l10H"
  case "18H": return "l18H"
  case "20H": return "l20H"
  case "28H": return "l28H"
  case "30H": return "l30H"
  case "38H": return "l38H"

  case "A": return "a"
  case "B": return "b"
  case "C": return "c"
  case "D": return "d"
  case "E": return "e"
  case "H": return "h"
  case "L": return "l"

  case "AF": return "af"
  case "BC": return "bc"
  case "DE": return "de"
  case "HL": return "hl"

  case "NC":  return "nc"
  case "NZ":  return "nz"
  case "Z":   return "z"
  case "a16": return "a16"
  case "d16": return "d16"
  case "d8":  return "d8"
  case "r8":  return "r8"

  case "SP":    return "sp"
  case "SP+r8": return "spPlusR8"

  case "(BC)":  return "pBC"
  case "(C)":   return "pC"
  case "(DE)":  return "pDE"
  case "(HL)":  return "pHL"
  case "(HL+)": return "pHLPlus"
  case "(HL-)": return "pHLMinus"
  case "(a8)":  return "pA8"
  case "(a16)": return "pA16"

  // single case
  case "CB": return "cb"
  case "0": return "zero"

  default: return "Unknown value: " + value.lowercased()
  }
}


private func quote(_ s: String) -> String {
  return "\"" + s + "\""
}

private func getLongestMnemonic(_ opcodes: [Opcode]) -> String {
  return opcodes
    .map { op in op.mnemonic }
    .max { lhs, rhs in lhs.count < rhs.count }!
}
