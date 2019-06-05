/// FF00 - P1/JOYP
public class JoypadMemory: MemoryRegion {

  public static let address: UInt16 = 0xff00

  public var value: UInt8 = 0x00

  public func contains(globalAddress address: UInt16) -> Bool {
    return address == JoypadMemory.address
  }

  public func read(globalAddress address: UInt16) -> UInt8 {
    assert(self.contains(globalAddress: address))
    return self.value
  }

  public func write(globalAddress address: UInt16, value: UInt8) {
    assert(self.contains(globalAddress: address))
    self.value = value
  }
}
