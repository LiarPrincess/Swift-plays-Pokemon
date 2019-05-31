public protocol MemoryDelegate: AnyObject {
  func memoryWillRead(_ memory: Memory, address: UInt16)
  func memoryDidRead(_ memory: Memory, address: UInt16, value: UInt8)

  func memoryWillWrite(_ memory: Memory, address: UInt16, value: UInt8)
  func memoryDidWrite(_ memory: Memory, address: UInt16, value: UInt8)
}

extension MemoryDelegate {
  public func memoryWillRead(_ memory: Memory, address: UInt16) { }
  public func memoryDidRead(_ memory: Memory, address: UInt16, value: UInt8) { }

  public func memoryWillWrite(_ memory: Memory, address: UInt16, value: UInt8) { }
  public func memoryDidWrite(_ memory: Memory, address: UInt16, value: UInt8) { }
}
