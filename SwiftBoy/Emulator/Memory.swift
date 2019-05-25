struct Memory {
  private var data = [UInt8](repeating: 0, count: 0xffff)

  func read(_ address: UInt16) -> UInt8 {
    return self.data[address]
  }
}
