// swiftlint:disable file_length

struct Cpu {

  /// Program counter: PC.
  /// A 16-bit register that holds the address data of the program to be executed next.
  var pc: UInt16 = 0

  /// Stack pointer: SP.
  /// A 16-bit register that holds the starting address of the stack area of memory.
  var sp: UInt16 = 0

  var registers = Registers()
  var memory = Memory()
}
