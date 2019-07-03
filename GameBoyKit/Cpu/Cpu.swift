// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

/// Central processing unit 
public class Cpu {

  /// 4 194 304 Hz
  public static let clockSpeed: UInt = 4_194_304

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

  private let bus: CpuBus
  private let interrupts: Interrupts

  internal init(bus: CpuBus, interrupts: Interrupts) {
    self.registers = Registers()
    self.bus = bus
    self.interrupts = interrupts
  }

  // MARK: - Tick

  /// Run 1 instruction. Returns the number of cycles it took.
  internal func tick() -> Int {

    // interrupts are the only way to escape HALT
    self.startInterruptRoutineIfNeeded()

    if self.isHalted {
      return 0
    }

    let opcode = self.read(self.pc)
    let cycles = self.executeUnprefixed(opcode)
    self.cycle &+= UInt64(cycles)

    // TODO: make executeUnprefixed return Int + remove @discardedResult
    return Int(cycles)
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

    if self.interrupts.isVBlankEnabled && self.interrupts.vBlank {
      self.interrupts.vBlank = false
      self.processInterrupt(0x40)
      return
    }

    if self.interrupts.isLcdStatEnabled && self.interrupts.lcdStat {
      self.interrupts.lcdStat = false
      self.processInterrupt(0x48)
      return
    }

    if self.interrupts.isTimerEnabled && self.interrupts.timer {
      self.interrupts.timer = false
      self.processInterrupt(0x50)
      return
    }

    if self.interrupts.isSerialEnabled && self.interrupts.serial {
      self.interrupts.serial = false
      self.processInterrupt(0x58)
      return
    }

    if self.interrupts.isJoypadEnabled && self.interrupts.joypad {
      self.interrupts.joypad = false
      self.processInterrupt(0x60)
      return
    }
  }

  private func processInterrupt(_ handlingRoutineAddress: UInt16) {
    self.ime = false

    // Escape HALT on return
    if self.isHalted {
      self.pc += 1
    }

    self.push16(self.pc)
    self.pc = handlingRoutineAddress
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
