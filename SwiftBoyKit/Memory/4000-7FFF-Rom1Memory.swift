/// 4000-7FFF 16KB ROM Bank 01..NN (in cartridge, switchable bank number)
public class Rom1Memory: ContinuousMemoryRegion {

  public static let start: UInt16 = 0x4000
  public static let end:   UInt16 = 0x7fff

  public var data = [UInt8](repeating: 0, count: Rom1Memory.size)

  public func write(globalAddress address: UInt16, value: UInt8) {
    assert(self.contains(globalAddress: address))
    fatalError("Attempting to write to read-only rom memory at: \(address.hex).")
  }
}
