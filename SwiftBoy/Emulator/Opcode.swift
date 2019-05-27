typealias Opcode       = OpcodeBase<OpcodeType>
typealias PrefixOpcode = OpcodeBase<PrefixOpcodeType>

struct OpcodeBase<Type> {

  /// Address
  let addr: String

  /// Opcode type
  let type: Type

  /// Debug string
  let debug: String

  /// Byte count
  let length: UInt16

  /// Duration in cycles
  let cycles: [UInt]

  init(addr: String,
       type: Type,
       debug: String,
       length: UInt16,
       cycles: [UInt]) {

    self.type = type
    self.addr = addr
    self.debug = debug
    self.length = length
    self.cycles = cycles
  }
}

extension Opcode: CustomStringConvertible {
  var description: String {
    return self.debug
  }
}

func ~= (value: OpcodeType, pattern: Opcode) -> Bool {
  return value == pattern.type
}
