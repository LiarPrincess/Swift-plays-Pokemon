// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftlint:disable force_unwrapping
// swiftlint:disable function_body_length

import Foundation

func modifyInstructions(_ opcodes: Opcodes, _ instructionsFileContent: String) {
  let groupedFunctions = groupByFunction(opcodes)
  validate(groupedFunctions)

  let swiftLines = instructionsFileContent.split(separator: "\n", maxSplits: .max, omittingEmptySubsequences: false)

  var functionName: String? = nil
  for line in swiftLines {
    if line.starts(with: "  internal func") {
      let nameStart = line.index(line.startIndex, offsetBy: 16)
      let nameEnd = line.firstIndex(of: "(")!
      functionName = String(line[nameStart..<nameEnd])
    }

    if line.starts(with: "  }") && functionName != nil {
      guard let opcode = groupedFunctions[functionName!]?.first else {
        fatalError("Function '\(String(describing: functionName))' is not an CPU instruction. Maybe it has invalid ACL?")
        continue
      }

      print("")
      if opcode.cycles.count == 1 {
        print("    self.pc += \(opcode.length)")
        print("    self.cycle &+= \(opcode.cycles[0])")
      } else {
        print("to fix manually") // just so it does not compile
        print("      self.cycle &+= \(opcode.cycles[0])")
        print("    } else {")
        print("      self.pc += \(opcode.length)")
        print("      self.cycle &+= \(opcode.cycles[1])")
        print("    }")
      }

      functionName = nil
    }

    print(line)
  }
}

// MARK: - Group by function call

private typealias FunctionName = String

private func groupByFunction(_ opcodes: Opcodes) -> [FunctionName: [Opcode]] {
  var result = [FunctionName: [Opcode]]()
  for opcode in opcodes.unprefixed {
    let call = getUnprefixedOpcodeCall(opcode)
    let functionName = getFunctionName(call)
    result[functionName, default: []].append(opcode)
  }
  for opcode in opcodes.cbprefixed {
    let call = getCBPrefixedOpcodeCall(opcode)
    let functionName = getFunctionName(call)
    result[functionName, default: []].append(opcode)
  }
  return result
}

private func getFunctionName(_ call: String) -> String {
  let parenIndex = call.firstIndex(of: "(")!
  return String(call[..<parenIndex])
}

// MARK: - Validate

private func validate(_ grouping: [FunctionName: [Opcode]]) {
  for (_, opcodes) in grouping {
    let first = opcodes.first!
    for opcode in opcodes {
      assert(opcode.length == first.length)
      assert(opcode.cycles == first.cycles)
    }
  }
}
