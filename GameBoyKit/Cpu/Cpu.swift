// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

internal protocol CpuAddressableMemory: AnyObject {
  func read(_ address: UInt16) -> UInt8
  func write(_ address: UInt16, value: UInt8)
}

/// Central processing unit 
public class Cpu {

  /// 4 194 304 Hz
  public static let clockSpeed = 4_194_304

  /// A 16-bit register that holds the address of the next executed instruction.
  public internal(set) var pc: UInt16 = 0

  /// A 16-bit register that holds the starting address of the stack.
  public internal(set) var sp: UInt16 = 0

  /// Current cycle incremented after each operation (starting from 0).
  public internal(set) var cycle: UInt64 = 0

  /// Interrupt Master Enable Flag.
  public internal(set) var ime: Bool = false

  /// Is halted flag.
  public internal(set) var isHalted: Bool = false

  /// Register values (except for pc and sp).
  public internal(set) var registers: Registers

  private let memory: CpuAddressableMemory
  private let interrupts: Interrupts

  internal init(memory: CpuAddressableMemory, interrupts: Interrupts) {
    self.registers = Registers()
    self.memory = memory
    self.interrupts = interrupts
  }

  // MARK: - Tick

  /// Run 1 instruction. Returns the number of cycles it took.
  internal func tick() -> Int {
    if let interrupt = self.getAwaitingInterrupt() {
      if self.isHalted {
        self.isHalted = false
        return 4
      }

      self.interrupts.clear(interrupt)
      self.startInterruptHandlingRoutine(interrupt)
      return 4
    }

    let opcode = self.read(self.pc)
    let cycles = self.executeUnprefixed(opcode)

    self.cycle &+= UInt64(cycles)
    return cycles
  }

  // MARK: - Interrupts

  internal func enableInterrupts() {
    self.ime = true
  }

  internal func disableInterrupts() {
    self.ime = false
  }

  private func getAwaitingInterrupt() -> InterruptType? {
    guard self.ime || self.isHalted else {
      return nil
    }

    if self.interrupts.isVBlankEnabled && self.interrupts.vBlank {
      return .vBlank
    }

    if self.interrupts.isLcdStatEnabled && self.interrupts.lcdStat {
      return .lcdStat
    }

    if self.interrupts.isTimerEnabled && self.interrupts.timer {
      return .timer
    }

    if self.interrupts.isSerialEnabled && self.interrupts.serial {
      return .serial
    }

    if self.interrupts.isJoypadEnabled && self.interrupts.joypad {
      return .joypad
    }

    return nil
  }

  private func startInterruptHandlingRoutine(_ type: InterruptType) {
    let address: UInt16 = {
      switch type {
      case .vBlank:  return 0x40
      case .lcdStat: return 0x48
      case .timer:   return 0x50
      case .serial:  return 0x58
      case .joypad:  return 0x60
      }
    }()

    self.ime = false
    self.push16(self.pc)
    self.pc = address
  }

  // MARK: - Operands

  /// Next 8 bits after pc
  internal var next8: UInt8 {
    return self.read(self.pc + 1)
  }

  /// Next 16 bits after pc
  internal var next16: UInt16 {
    let low  = UInt16(self.read(self.pc + 1))
    let high = UInt16(self.read(self.pc + 2))
    return (high << 8) | low
  }

  // MARK: - Stack

  internal func push8(_ n: UInt8) {
    self.sp -= 1
    self.write(self.sp, value: n)
  }

  internal func push16(_ nn: UInt16) {
    self.push8(UInt8(nn >> 8))
    self.push8(UInt8(nn & 0xff))
  }

  internal func pop8() -> UInt8 {
    let n = self.read(self.sp)
    self.sp += 1
    return n
  }

  internal func pop16() -> UInt16 {
    let low  = UInt16(self.pop8())
    let high = UInt16(self.pop8())
    return (high << 8) | low
  }

  // MARK: - Read/Write

  internal func read(_ address: UInt16) -> UInt8 {
    return self.memory.read(address)
  }

  internal func write(_ address: UInt16, value: UInt8) {
    self.memory.write(address, value: value)
  }
}
