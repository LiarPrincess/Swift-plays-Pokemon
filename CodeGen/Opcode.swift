struct Opcode {

  /// Instruction mnemonic
  let mnemonic: String

  /// Length in bytes
  let length: Int

  /// Duration in cycles
  let cycles: [Int]

  /// Flags affected
  /// - 0 - Zero Flag (Z)
  /// - 1 - Subtract Flag (N)
  /// - 2 - Half Carry Flag (H)
  /// - 3 - Carry Flag (C)
  let flags: [String]

  /// Address
  let addr: String

  /// Operand 1
  let operand1: String?

  /// Operand 2
  let operand2: String?

  var enumCase: String {
    var result = ""

    result += self.mnemonic.lowercased()
    result += "_"

    if let operand1 = self.operand1 {
      result += getOperandValue(operand1)
      result += "_"
    }

    if let operand2 = self.operand2 {
      result += getOperandValue(operand2)
      result += "_"
    }

    let addrNum: String.SubSequence = {
      let a = self.addr.dropFirst(2)
      return a.count == 2 ? a : "0" + a
    }()

    result += addrNum

    return result
  }

  // swiftlint:disable:next cyclomatic_complexity function_body_length
  private func getOperandValue(_ value: String) -> String {
    switch value {
    case "00H": return "00h"
    case "08H": return "08h"
    case "10H": return "10h"
    case "18H": return "18h"
    case "20H": return "20h"
    case "28H": return "28h"
    case "30H": return "30h"
    case "38H": return "38h"

    case "A": return "a"
    case "B": return "b"
    case "C": return "c"
    case "D": return "d"
    case "E": return "e"
    case "H": return "h"
    case "L": return "l"

    case "0": return "0"
    case "1": return "1"
    case "2": return "2"
    case "3": return "3"
    case "4": return "4"
    case "5": return "5"
    case "6": return "6"
    case "7": return "7"

    case "AF": return "af"
    case "BC": return "bc"
    case "CB": return "cb"
    case "DE": return "de"
    case "HL": return "hl"

    case "NC":  return "nc"
    case "NZ":  return "nz"
    case "Z":   return "z"
    case "a16": return "a16"
    case "d16": return "d16"
    case "d8":  return "n"
    case "r8":  return "r8"

    case "SP":    return "sp"
    case "SP+r8": return "spPlusR8"

    case "(BC)":  return "pBC"
    case "(C)":   return "pC"
    case "(DE)":  return "pDE"
    case "(HL)":  return "pHL"
    case "(HL+)": return "pHLI"
    case "(HL-)": return "pHLD"
    case "(a8)":  return "pA8"
    case "(a16)": return "pA16"

    default: return "Unknown value: " + value.lowercased()
    }
  }
}
