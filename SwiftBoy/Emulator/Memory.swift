struct Memory {

  // TODO: Check correct memory size
  private var data = [UInt8](repeating: 0, count: 0xffff + 1)

  func read(_ address: UInt16) -> UInt8 {
    return self.data[address]
  }

  mutating func write(_ address: UInt16, value: UInt8) {
    self.data[address] = value
  }
}
