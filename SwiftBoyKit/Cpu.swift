public class Cpu: Codable {

  /// Program counter: PC.
  /// A 16-bit register that holds the address data of the program to be executed next.
  public var pc: UInt16 = 0

  /// Stack pointer: SP.
  /// A 16-bit register that holds the starting address of the stack area of memory.
  public var sp: UInt16 = 0

  /// Current cycle incremented after each operation (counting from 0 at the start).
  public var cycle: UInt16 = 0

  public var memory: Memory
  public var registers: Registers

  public weak var delegate: CpuDelegate? {
    didSet { self.registers.delegate = self.delegate }
  }

  public init(memory: Memory? = nil, delegate: CpuDelegate? = nil) {
    self.registers = Registers(delegate: delegate)
    self.memory = memory ?? Memory()
    self.delegate = delegate
  }

  public var currentCycle: UInt = 0

  public func run(maxCycles: UInt? = nil, lastPC: UInt16? = nil) {
    let maxCycles = maxCycles ?? UInt.max
    let lastPC  = lastPC ?? UInt16.max

    var brakepoint = false
    while currentCycle <= maxCycles && self.pc != lastPC {
      let oldPc = self.pc

      let opcodeIndex = self.memory.read(self.pc)
      guard let opcode = unprefixedOpcodes[opcodeIndex] else {
        fatalError("Tried to execute non existing opcode '\(opcodeIndex.hex)'.")
      }

      self.delegate?.cpuWillExecute(self, opcode: opcode)
      self.execute(opcode)
      self.delegate?.cpuDidExecute(self, opcode: opcode)

      // ------------
      brakepoint = brakepoint || oldPc == 0x0064
      if brakepoint { // conditional brakepoint in lldb slows down code (by a lot)
        _ = 5
      }
      // ------------

      self.currentCycle += 1
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
    // TODO: Implement interrupts
  }

  // MARK: - Codable

  public enum CodingKeys: CodingKey {
    case pc
    case sp
    case memory
    case registers
  }
}
