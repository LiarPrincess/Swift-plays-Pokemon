// PrefixedOpcode

struct Opcode {

  /// Address
  let addr: String

  /// Instruction mnemonic
  let mnemonic: String

  /// Type of the opcode
  let type: OpcodeType

  /// Operand 1
  let operand1: String?

  /// Operand 2
  let operand2: String?

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

  init(_ addr: String,
       _ mnemonic: String,
       type: OpcodeType,
       operand1: String?,
       operand2: String?,
       length: Int,
       cycles: [Int],
       flags: [String]) {

    self.addr = addr
    self.mnemonic = mnemonic
    self.type = type
    self.length = length
    self.cycles = cycles
    self.flags = flags
    self.operand1 = operand1
    self.operand2 = operand2
  }
}

extension Opcode: CustomStringConvertible {
  var description: String {
    return self.addr + " " + self.mnemonic
  }
}
