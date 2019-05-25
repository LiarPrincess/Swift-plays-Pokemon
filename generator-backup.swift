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
  printOperands(opcodeData)
  printInstructions(opcodes.unprefixed)
}

// ------------------------

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

// ------------------------

private func printOpcodeTypes(_ opcodeData: [OpcodeData]) {
  print("enum OpcodeType {")

  for data in opcodeData {
    print("  case \(data.mnemonic.lowercased())", terminator: "")

    if data.operands1.count > 1 {
      print("(", terminator: "")
      print(getOperand1Name(data), terminator: "")

      if data.operands2.count > 1 {
        print(", \(getOperand2Name(data))", terminator: "")
      }

      print(")", terminator: "")
    }

    print("")
  }
  print("}")
  print("")
}

private func printOperands(_ opcodeData: [OpcodeData]) {
  for data in opcodeData {
    if data.operands1.count > 1 {
      print("enum \(getOperand1Name(data)) {")
      data.operands1.forEach { print("  case \(getOperandValue($0))") }
      print("}")
      print("")
    }

    if data.operands2.count > 1 {
      print("enum \(getOperand2Name(data)) {")
      data.operands2.forEach { print("  case \(getOperandValue($0))") }
      print("}")
      print("")
    }
  }
}

private func getOperand1Name(_ data: OpcodeData) -> String {
  return data.operands2.isEmpty ?
    data.mnemonic.capitalized + "Operand" :
    data.mnemonic.capitalized + "Operand1"
}

private func getOperand2Name(_ data: OpcodeData) -> String {
  return data.mnemonic.capitalized + "Operand2"
}

private func getOperandValue(_ value: String) -> String {
  switch value {
  case "00H": return "literal00H"
  case "08H": return "literal08H"
  case "10H": return "literal10H"
  case "18H": return "literal18H"
  case "20H": return "literal20H"
  case "28H": return "literal28H"
  case "30H": return "literal30H"
  case "38H": return "literal38H"

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

  case "SP":    return "stackPointer"
  case "SP+r8": return "stackPointerPlusR8"

  case "(BC)":  return "indirectBC"
  case "(C)":   return "indirectC"
  case "(DE)":  return "indirectDE"
  case "(HL)":  return "indirectHL"
  case "(HL+)": return "indirectHLPlus"
  case "(HL-)": return "indirectHLMinus"
  case "(a8)":  return "indirectA8"
  case "(a16)": return "indirectA16"
  default: return "Unknown value: " + value.lowercased()
  }
}

private func printInstructions(_ opcodes: [Opcode]) {
  let longestMnemonic = getLongestMnemonic(opcodes)

  print("let instructions: [instruction] = [")
  for op in opcodes {
    let padding = String(repeating: " ", count: longestMnemonic.count - op.mnemonic.count)

    let addr = quote(op.addr)
    let mnemonic = quote(op.mnemonic.lowercased())
    let length = op.length
    let cycles = op.cycles
    let type = "." + op.mnemonic.lowercased()
    let operand1 = op.operand1 == nil ? "nil" : quote(op.operand1!)
    let operand2 = op.operand2 == nil ? "nil" : quote(op.operand2!)
    let flags = op.flags

    print("  Opcode(\(addr), \(mnemonic),\(padding)type: \(type),\(padding)length: \(length), cycles: \(cycles), flags: \(flags), operand1: \(operand1), operand2: \(operand2)),")
  }
  print("]")
  print("")
}

// ------------------------

//private func printOpcodeEnum(_ opcodes: [Opcode]) {
//  let longestMnemonic = getLongestMnemonic(opcodes)
//
//  print("enum Opcode: UInt16 {")
//  for op in opcodes {
//    let padding = String(repeating: " ", count: longestMnemonic.count - op.mnemonic.count)
//    print("  case \(op.opcode) \(padding)= \(op.addr)")
//  }
//  print("}")
//  print("")
//}
//
//private func printInstructions(_ opcodes: [Opcode]) {
//  let longestMnemonic = getLongestMnemonic(opcodes)
//
//  print("let instructions: [Instruction] = [")
//  for op in opcodes {
//    let padding = String(repeating: " ", count: longestMnemonic.count - op.mnemonic.count)
//
//    let opcode = "." + op.opcode
//    let addr = quote(op.addr)
//    let mnemonic = quote(op.mnemonic.lowercased())
//    let length = op.length
//    let cycles = op.cycles
//    let flags = op.flags
//    let operand1 = op.operand1 == nil ? "nil" : quote(op.operand1!)
//    let operand2 = op.operand2 == nil ? "nil" : quote(op.operand2!)
//
//    print("  Instruction(\(opcode),\(padding)\(addr), \(mnemonic),\(padding)\(length), \(cycles), \(flags), \(operand1), \(operand2)),")
//  }
//  print("]")
//  print("")
//}

// ------------------------

private func quote(_ s: String) -> String {
  return "\"" + s + "\""
}

private func getLongestMnemonic(_ opcodes: [Opcode]) -> String {
  return opcodes
    .map { op in op.mnemonic }
    .max { lhs, rhs in lhs.count < rhs.count }!
}
