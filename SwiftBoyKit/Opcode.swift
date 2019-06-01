/// One of standard 256 opcodes
public typealias UnprefixedOpcode = Opcode<UnprefixedOpcodeValue>

/// One of additional 256 opcodes that should be executed if standard opcode is 0xCB
public typealias CBPrefixedOpcode = Opcode<CBPrefixedOpcodeValue>

/// Single operation that can be executed on Gameboy cpu.
public struct Opcode<Value: RawRepresentable> where Value.RawValue == UInt8 {

  /// Specifies which operation should be performed
  public let value: Value

  /// Raw opcode value
  public var rawValue: UInt8 {
    return self.value.rawValue
  }

  /// Byte count
  public let length: UInt8

  /// Duration in cycles
  public let cycles: UInt8

  /// Duration in cycles for alternative execution path. For example:
  /// `jr` with condition may take 3 or 4 cycles depending whether jump was taken or not.
  /// 0 if this opcode does not have alternative execution path.
  public let alternativeCycles: UInt8

  internal init(value: Value,
                length: UInt8,
                cycles: [UInt8]) {
    self.value = value
    self.length = length
    self.cycles = cycles[0]
    self.alternativeCycles = cycles.count == 2 ? cycles[0] : 0
  }
}
