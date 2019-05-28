public class Memory: Codable {

  public var data = [UInt8](repeating: 0, count: 0xffff + 1)

  public weak var delegate: MemoryDelegate?

  public init(delegate: MemoryDelegate? = nil) {
    self.delegate = delegate
  }

  public func fakeEmptyCartridge() {
    let bootromStart = 0x0000
    let bootromEnd = bootromStart + bootrom.count
    self.data.replaceSubrange(bootromStart..<bootromEnd, with: bootrom)

    let logoStart = 0x0104
    let logoEnd = logoStart + nintendoLogo.count
    self.data.replaceSubrange(logoStart..<logoEnd, with: nintendoLogo)
  }

  public func read(_ address: UInt16) -> UInt8 {
    self.delegate?.memoryWillRead(self, address: address)
    let value = self.data[address]
    self.delegate?.memoryDidRead(self, address: address, value: value)
    return value
  }

  public func write(_ address: UInt16, value: UInt8) {
    self.delegate?.memoryWillWrite(self, address: address, value: value)
    self.data[address] = value
    self.delegate?.memoryDidWrite(self, address: address, value: value)
  }

  // MARK: - Codable

  public enum CodingKeys: CodingKey {
    case data
  }
}
