public class Memory {

  private var data = [UInt8](repeating: 0, count: 0xffff + 1)

  internal weak var delegate: MemoryDelegate?

  public init(delegate: MemoryDelegate? = nil) {
    self.delegate = delegate
  }

  public func loadBootrom() {
    self.data.replaceSubrange(0..<bootrom.count, with: bootrom)
  }

  public func read(_ address: UInt16) -> UInt8 {
    self.delegate?.memoryWillRead(self, address: address)
    let value = self.data[address]
    self.delegate?.memoryDidRead(self, address: address, value: value)
    return value
  }

  public func write(_ address: UInt16, value: UInt8) {
    self.delegate?.memoryWillWrite(self, address, value: value)
    self.data[address] = value
    self.delegate?.memoryDidWrite(self, address, value: value)
  }
}
