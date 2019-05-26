// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

extension Cpu {

  /// Loads the operand nn to the program counter (PC).
  /// nn specifies the address of the subsequently executed instruction.
  mutating func jp_nn(_ nn: UInt16) {
    self.pc = nn
  }
}
