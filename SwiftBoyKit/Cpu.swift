public class Cpu {

  /// Program counter: PC.
  /// A 16-bit register that holds the address data of the program to be executed next.
  public var pc: UInt16 = 0

  /// Stack pointer: SP.
  /// A 16-bit register that holds the starting address of the stack area of memory.
  public var sp: UInt16 = 0

  public var memory: Memory
  public var registers: Registers

  internal weak var delegate: CpuDelegate?

  public init(memory: Memory? = nil, delegate: CpuDelegate? = nil) {
    self.registers = Registers()
    self.memory = memory ?? Memory()
    self.delegate = delegate
  }

  public func run(cycles: UInt) {
    let limitByCycles = true
    let maxCycle =  limitByCycles ?    11 : 99_999
    let maxPc    = !limitByCycles ? 0x00c : 0xffff

    var cycle = 0
    while cycle < maxCycle && self.pc < maxPc {
      let oldPc = self.pc

      let opcodeIndex = self.memory.read(self.pc)
      guard let opcode = unprefixedOpcodes[opcodeIndex] else {
        fatalError("Tried to execute non existing opcode '\(opcodeIndex.hex)'.")
      }

      self.delegate?.cpuWillExecute(self, opcode: opcode)
      self.execute(opcode)
      self.delegate?.cpuDidExecute(self, opcode: opcode)

      // if instruction has set new PC then skip update
      if self.pc == oldPc {
        self.pc += opcode.length
      }

      cycle += 1
    }
  }

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
}
