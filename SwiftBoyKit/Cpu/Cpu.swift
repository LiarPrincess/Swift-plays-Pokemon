// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

public class Cpu {

  /// 4.194304MHz
  public static let clockSpeed: UInt = 4_194_304

  /// A 16-bit register that holds the address data of the program to be executed next.
  public var pc: UInt16 = 0

  /// A 16-bit register that holds the starting address of the stack area of memory.
  public var sp: UInt16 = 0

  /// Current cycle incremented after each operation (starting from 0).
  public var cycle: UInt16 = 0

  /// Interrupt Master Enable Flag.
  public var ime: Bool = false

  /// True if interrupts should be enabled after next instruction.
  public var imeEnableNext: Bool = false

  /// Is halted flag.
  public var isHalted: Bool = false

  public var registers: Registers
  internal var memory: CpuMemoryView

  internal init(memory: CpuMemoryView) {
    self.registers = Registers()
    self.memory = memory
  }

  /// Runs 1 instruction. Returns the number of cycles it took.
  internal func tick() -> UInt8 {
    let rawOpcode = self.memory.read(self.pc)
    guard let opcode = UnprefixedOpcode(rawValue: rawOpcode) else {
      fatalError("Tried to execute non existing opcode '\(rawOpcode.hex)'.")
    }

    Debug.cpuWillExecute(self, opcode: opcode)
    let oldCycle = self.cycle
    self.execute(opcode)
    Debug.cpuDidExecute(self, opcode: opcode)

    return UInt8(self.calculateDuration(oldCycle))
  }

  private func calculateDuration(_ oldCycle: UInt16) -> UInt16 {
    let hasOverflow = self.cycle < oldCycle
    return hasOverflow ?
      self.cycle + (0xFF - oldCycle) :
      self.cycle - oldCycle
  }

  // MARK: - Next bytes

  /// Next 8 bits after pc
  internal var next8: UInt8 {
    return self.memory.read(self.pc + 1)
  }

  /// Next 16 bits after pc
  internal var next16: UInt16 {
    let low  = UInt16(self.memory.read(self.pc + 1))
    let high = UInt16(self.memory.read(self.pc + 2))
    return (high << 8) | low
  }

  // MARK: - Stack operations

  internal func push8(_ n: UInt8) {
    self.sp -= 1
    self.memory.write(self.sp, value: n)
  }

  internal func push16(_ nn: UInt16) {
    self.push8(UInt8(nn >> 8))
    self.push8(UInt8(nn & 0xff))
  }

  internal func pop8() -> UInt8 {
    let n = self.memory.read(self.sp)
    self.sp += 1
    return n
  }

  internal func pop16() -> UInt16 {
    let low  = UInt16(self.pop8())
    let high = UInt16(self.pop8())
    return (high << 8) | low
  }

  // MARK: - Interrupts

  internal func enableInterrupts() {
    self.ime = true
    self.imeEnableNext = true
  }

  internal func enableInterruptsNext() {
    self.imeEnableNext = true
  }

  internal func disableInterrupts() {
    self.ime = false
    self.imeEnableNext = false
  }
}
