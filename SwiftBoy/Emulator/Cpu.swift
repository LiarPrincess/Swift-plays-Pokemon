struct Cpu {

  /// Program counter: PC.
  /// A 16-bit register that holds the address data of the program to be executed next.
  var pc: UInt16 = 0

  /// Stack pointer: SP.
  /// A 16-bit register that holds the starting address of the stack area of memory.
  var sp: UInt16 = 0

  var registers = Registers()
  var memory = Memory()

  internal var nextWord: UInt8 {
    return self.memory.read(self.pc + 1)
  }

  internal var nextLong: UInt16 {
    let low = self.memory.read(self.pc + 1)
    let high = self.memory.read(self.pc + 2)
    return (UInt16(high) << 8) | UInt16(low)
  }
}
