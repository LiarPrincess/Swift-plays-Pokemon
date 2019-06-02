public class Memory: Codable {

  public var data = [UInt8](repeating: 0, count: 0xffff + 1)

  public func read(_ address: UInt16) -> UInt8 {
    let value = self.data[address]
    Debug.memoryDidRead(self, address: address, value: value)
    return value
  }

  public func write(_ address: UInt16, value: UInt8) {
    self.data[address] = value
    Debug.memoryDidWrite(self, address: address, value: value)
  }
}
