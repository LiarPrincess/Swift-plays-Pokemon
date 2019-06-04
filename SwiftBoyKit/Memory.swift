public class Memory {

  public var data = [UInt8](repeating: 0, count: 0x10000)

  public func read(_ address: UInt16) -> UInt8 {
    let value = self[address]
    Debug.memoryDidRead(self, address: address, value: value)
    return value
  }

  public func write(_ address: UInt16, value: UInt8) {
    switch address {
    case 0x0000...0x8000: // read-only
      break
    case 0xe000...0xfdff: // echo also writes in C000-DDFF
      self[address] = value
      self[address - 0x2000] = value
    case 0xfea0...0xfeff: // restricted
      break
    case TimerMemoryAddress.div: // div should be reset to 0 on any write
      // TODO: we shoudl also invalidate internal counter in timer
      self[address] = 0
    default:
      self[address] = value
    }

    Debug.memoryDidWrite(self, address: address, value: value)
  }

  public subscript(_ address: UInt16) -> UInt8 {
    get { return self.data[address] }
    set { self.data[address] = newValue }
  }

  public subscript(bounds: Range<Int>) -> Slice<[UInt8]> {
    get { return self.data[bounds] }
    set { self.data[bounds] = newValue }
  }
}
