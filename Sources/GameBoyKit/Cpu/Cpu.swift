// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

/// Central processing unit
public final class Cpu {

  /// 4 194 304 Hz
  public static let clockSpeed = 4_194_304

  /// A 16-bit register that holds the address of the next executed instruction.
  public internal(set) var pc = UInt16(0)

  /// A 16-bit register that holds the starting address of the stack.
  public internal(set) var sp = UInt16(0)

  /// Current cycle incremented after each operation (starting from 0).
  public internal(set) var cycle = UInt64(0)

  /// Interrupt Master Enable Flag.
  public internal(set) var ime = false

  /// True if interrupts should be enabled after next instruction.
  /// https://www.reddit.com/r/EmuDev/comments/7rm8l2/game_boy_vblank_interrupt_confusion/
  public internal(set) var imeNext = false

  /// Is halted flag.
  public internal(set) var isHalted = false

  /// Register values (except for pc and sp).
  public internal(set) var registers = CpuRegisters()

  private unowned let memory: CpuMemory
  private unowned let interrupts: Interrupts

  internal init(memory: CpuMemory, interrupts: Interrupts) {
    self.memory = memory
    self.interrupts = interrupts
  }

  // MARK: - Tick

  /// Run 1 instruction. Returns the number of cycles it took.
  internal func tick() -> Int {
    let interruptHandlingRoutine = self.getAwaitingInterruptHandlingRoutine()

    if self.isHalted {
      if interruptHandlingRoutine != nil {
        self.isHalted = false
        self.pc += 1 // move past halt
      } else {
        return 4 // just so we 'tick' other components
      }
    }

    if let handlingRoutine = interruptHandlingRoutine, self.ime {
      self.disableInterrupts()
      self.interrupts.clear(handlingRoutine.kind)
      self.push16(self.pc)
      self.pc = handlingRoutine.address
      return 8 // because of push
    }

    self.ime = self.imeNext

    let opcode = self.read(self.pc)
    let cycles = self.executeUnprefixed(opcode)

    self.cycle &+= UInt64(cycles)
    return cycles
  }

  // MARK: - Interrupts

  internal func enableInterrupts() {
    self.ime = true
    self.imeNext = true
  }

  internal func enableInterruptsNext() {
    self.imeNext = true
  }

  internal func disableInterrupts() {
    self.ime = false
    self.imeNext = false
  }

  private struct InterruptHandlingRoutine {
    fileprivate static let vBlank = InterruptHandlingRoutine(kind: .vBlank, address: 0x40)
    fileprivate static let lcdStat = InterruptHandlingRoutine(kind: .lcdStat, address: 0x48)
    fileprivate static let timer = InterruptHandlingRoutine(kind: .timer, address: 0x50)
    fileprivate static let serial = InterruptHandlingRoutine(kind: .serial, address: 0x58)
    fileprivate static let joypad = InterruptHandlingRoutine(kind: .joypad, address: 0x60)

    fileprivate let kind: Interrupts.Kind
    fileprivate let address: UInt16
  }

  private func getAwaitingInterruptHandlingRoutine() -> InterruptHandlingRoutine? {
    guard self.ime || self.isHalted else {
      return nil
    }

    let interrupts = self.interrupts
    if interrupts.isEnabledAndSet(.vBlank) { return .vBlank }
    if interrupts.isEnabledAndSet(.lcdStat) { return .lcdStat }
    if interrupts.isEnabledAndSet(.timer) { return .timer }
    if interrupts.isEnabledAndSet(.serial) { return .serial }
    if interrupts.isEnabledAndSet(.joypad) { return .joypad }

    return nil
  }

  // MARK: - Operands

  /// Next 8 bits after pc
  internal var next8: UInt8 {
    return self.read(self.pc + 1)
  }

  /// Next 16 bits after pc
  internal var next16: UInt16 {
    let low = UInt16(self.read(self.pc + 1))
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
    let low = UInt16(self.pop8())
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
