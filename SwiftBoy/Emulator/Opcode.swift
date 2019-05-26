// PrefixedOpcode

struct Opcode {

  /// Address
  let addr: String

  /// Instruction mnemonic
  let mnemonic: String

  /// Opcode type
  let type: OpcodeType

  /// Byte count
  let length: Int

  /// Duration in cycles
  let cycles: [Int]

  init(_ addr: String,
       _ mnemonic: String,
       type: OpcodeType,
       length: Int,
       cycles: [Int]) {

    self.addr = addr
    self.mnemonic = mnemonic
    self.type = type
    self.length = length
    self.cycles = cycles
  }
}

extension Opcode: CustomStringConvertible {
  var description: String {
    return self.addr + " " + self.mnemonic
  }
}

func ~= (value: OpcodeType, pattern: Opcode) -> Bool {
  return value == pattern.type
}
