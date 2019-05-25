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

  var opcode: String {
  let mnemonic = self.mnemonic.lowercased()

    var addrNum = self.addr.dropFirst(2)
    if addrNum.count == 1 {
      addrNum = "0" + addrNum
    }

    return "\(mnemonic)_\(addrNum)"
  }
}
