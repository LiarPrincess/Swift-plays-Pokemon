public class Cpu: Codable {

  /// Program counter: PC.
  /// A 16-bit register that holds the address data of the program to be executed next.
  public var pc: UInt16 = 0

  /// Stack pointer: SP.
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

  public var memory: Memory
  public var registers: Registers

  public init(memory: Memory? = nil) {
    self.registers = Registers()
    self.memory = memory ?? Memory()
  }

  public func run(maxCycles: UInt16? = nil, lastPC: UInt16? = nil) {
    Debug.cpuWillRun(self)
    let maxCycles = maxCycles ?? UInt16.max
    let lastPC  = lastPC ?? UInt16.max

    var brakepoint = false
    while self.cycle <= maxCycles && self.pc != lastPC {
      // ------------
      brakepoint = brakepoint || self.pc == 0x004A
      if brakepoint { // conditional brakepoint in lldb slows down code (by a lot)
        _ = 5
      }
      // ------------

      let rawOpcode = self.memory.read(self.pc)
      guard let opcode = UnprefixedOpcode(rawValue: rawOpcode) else {
        fatalError("Tried to execute non existing opcode '\(rawOpcode.hex)'.")
      }

      Debug.cpuWillExecute(self, opcode: opcode)
      self.execute(opcode)
      Debug.cpuDidExecute(self, opcode: opcode)
    }
  }

  func reset() { }

  // MARK: - Next bytes

  /// Next 8 bits after pc
  public var next8: UInt8 {
    return self.memory.read(self.pc + 1)
  }

  /// Next 16 bits after pc
  public var next16: UInt16 {
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
