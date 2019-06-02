public class Memory: Codable {

  public var data = [UInt8](repeating: 0, count: 0xffff + 1)

  public func fakeEmptyCartridge() {
    let bootromStart = 0x0000
    let bootromEnd = bootromStart + bootrom.count
    self.data.replaceSubrange(bootromStart..<bootromEnd, with: bootrom)

    let logoStart = 0x0104
    let logoEnd = logoStart + nintendoLogo.count
    self.data.replaceSubrange(logoStart..<logoEnd, with: nintendoLogo)
  }

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
