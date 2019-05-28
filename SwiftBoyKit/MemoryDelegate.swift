public protocol MemoryDelegate: class {
  func memoryWillRead(_ memory: Memory, address: UInt16)
  func memoryDidRead(_ memory: Memory, address: UInt16, value: UInt8)

  func memoryWillWrite(_ memory: Memory, address: UInt16, value: UInt8)
  func memoryDidWrite(_ memory: Memory, address: UInt16, value: UInt8)
}

public extension MemoryDelegate {
  func memoryWillRead(_ memory: Memory, address: UInt16) { }
  func memoryDidRead(_ memory: Memory, _ address: UInt16, _ value: UInt8) { }

  func memoryWillWrite(_ memory: Memory, _ address: UInt16, value: UInt8) { }
  func memoryDidWrite(_ memory: Memory, _ address: UInt16, value: UInt8) { }
}
