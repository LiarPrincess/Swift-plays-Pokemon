// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

/// Central processing unit 
public class Cpu {

  /// 4 194 304 Hz
  public static let clockSpeed: UInt = 4_194_304

  /// A 16-bit register that holds the address data of the program to be executed next.
  public var pc: UInt16 = 0

  /// A 16-bit register that holds the starting address of the stack area of memory.
  public var sp: UInt16 = 0

  /// Current cycle incremented after each operation (starting from 0).
  public var cycle: UInt64 = 0

  /// Interrupt Master Enable Flag.
  public var ime: Bool = false

  /// Is halted flag.
  public var isHalted: Bool = false

  /// Register values (except for pc and sp)
  public var registers: Registers

  private unowned var bus: CpuBus

  internal init(bus: CpuBus) {
    self.registers = Registers()
    self.bus = bus
  }

  // MARK: - Tick

  /// Run 1 instruction. Returns the number of cycles it took.
  internal func tick() -> UInt8 {

    // interrupts are the only way to escape HALT
    self.startInterruptRoutineIfNeeded()

    if self.isHalted {
      return 0
    }

    let oldCycle = self.cycle

    let opcode = self.read(self.pc)
    self.executeUnprefixed(opcode)

    return UInt8(self.calculateDuration(oldCycle))
  }

  private func calculateDuration(_ oldCycle: UInt64) -> UInt64 {
    let hasOverflow = self.cycle < oldCycle
    return hasOverflow ?
      self.cycle + (UInt64.max - oldCycle) :
      self.cycle - oldCycle
  }

  // MARK: - Interrupts

  internal func enableInterrupts() {
    self.ime = true
  }

  internal func disableInterrupts() {
    self.ime = false
  }

  private func startInterruptRoutineIfNeeded() {
    guard self.ime else {
      return
    }

    guard let interrupt = self.getAwaitingInterrupt() else {
      return
    }

    self.ime = false
    self.bus.clearInterrupt(interrupt)

    // Escape HALT on return
    if self.isHalted {
      self.pc += 1
    }

    self.push16(self.pc)
    self.pc = self.getInterruptHandlingRoutine(interrupt)
  }

  private func getAwaitingInterrupt() -> Interrupt? {
    if self.bus.hasInterrupt(.vBlank)  { return .vBlank }
    if self.bus.hasInterrupt(.lcdStat) { return .lcdStat }
    if self.bus.hasInterrupt(.timer)   { return .timer }
    if self.bus.hasInterrupt(.serial)  { return .serial }
    if self.bus.hasInterrupt(.joypad)  { return .joypad }
    return nil
  }

  private func getInterruptHandlingRoutine(_ interrupt: Interrupt) -> UInt16 {
    switch interrupt {
    case .vBlank:  return 0x40
    case .lcdStat: return 0x48
    case .timer:   return 0x50
    case .serial:  return 0x58
    case .joypad:  return 0x60
    }
  }

  // MARK: - Next bytes

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

  // MARK: - Stack operations

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
    return self.bus.read(address)
  }

  internal func write(_ address: UInt16, value: UInt8) {
    self.bus.write(address, value: value)
  }
}

// MARK: - Restorable

extension Cpu: Restorable {
  internal func save(to state: inout GameBoyState) {
    self.registers.save(to: &state)
    state.cpu.pc    = self.pc
    state.cpu.sp    = self.sp
    state.cpu.cycle = self.cycle
    state.cpu.ime      = self.ime
    state.cpu.isHalted = self.isHalted
  }

  internal func load(from state: GameBoyState) {
    self.registers.load(from: state)
    self.pc    = state.cpu.pc
    self.sp    = state.cpu.sp
    self.cycle = state.cpu.cycle
    self.ime      = state.cpu.ime
    self.isHalted = state.cpu.isHalted
  }
}
