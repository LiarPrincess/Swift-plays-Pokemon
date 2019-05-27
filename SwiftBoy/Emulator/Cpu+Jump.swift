// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

enum JumpCondition {
  case nz
  case z
  case nc
  case c
}

extension Cpu {

  // MARK: - JP

  /// Loads the operand nn to the program counter (PC).
  /// nn specifies the address of the subsequently executed instruction.
  mutating func jp_nn(_ nn: UInt16) {
    self.pc = nn
  }

  /// Loads operand nn in the PC if condition cc and the flag status match.
  mutating func jp_cc_nn(_ condition: JumpCondition, _ nn: UInt16) {
    if self.canJump(condition) {
      self.pc = nn
    }
  }

  /// Loads the contents of register pair HL in program counter PC.
  mutating func jp_pHL() {
    self.pc = self.registers.hl
  }

  // MARK: - JR

   /// Jumps -127 to +129 steps from the current address.
  mutating func jr_e(_ e: UInt8) {
    self.jr(e)
  }

  /// If condition cc and the flag status match, jumps -127 to +129 steps from the current address.
  mutating func jr_cc_e(_ condition: JumpCondition, _ e: UInt8) {
    if self.canJump(condition) {
      self.jr(e)
    }
  }

  private mutating func jr(_ e: UInt8) {
    let offset = Int8(bitPattern: e)
    let pc = Int(self.pc) + Int(offset)
    self.pc = UInt16(pc)
  }

  // MARK: - Can jump

  private func canJump(_ condition: JumpCondition) -> Bool {
    switch condition {
    case .nz: return !self.registers.zeroFlag
    case .z:  return  self.registers.zeroFlag
    case .nc: return !self.registers.carryFlag
    case .c:  return  self.registers.carryFlag
    }
  }
}
