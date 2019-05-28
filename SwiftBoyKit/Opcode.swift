public typealias UnprefixedOpcode = OpcodeBase<UnprefixedOpcodeType>
public typealias CBPrefixedOpcode = OpcodeBase<CBPrefixedOpcodeType>

public struct OpcodeBase<Type> {

  /// Address
  public let addr: String

  /// Opcode type
  public let type: Type

  /// Debug string
  public let debug: String

  /// Byte count
  public let length: UInt16

  /// Duration in cycles
  public let cycles: [UInt]

  internal init(addr: String,
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

extension OpcodeBase: CustomStringConvertible {
  public var description: String {
    return self.debug
  }
}
