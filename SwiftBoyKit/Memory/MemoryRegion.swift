// Source: http://bgb.bircd.org/pandocs.htm#memorymap
// and:    http://gameboy.mongenel.com/dmg/asmmemmap.html

// TODO: Implement 'FEA0-FEFF Not Usable'?

/// Stand-alone part of the memory
public protocol MemoryRegion: AnyObject, Codable {

  /// Does this memory region contains this address?
  func contains(globalAddress address: UInt16) -> Bool

  /// Write value from memory
  func read(globalAddress address: UInt16) -> UInt8

  /// Write value to memory
  func write(globalAddress address: UInt16, value: UInt8)
}

/// Memory region that is internally backed by array
public protocol ContinuousMemoryRegion: MemoryRegion {

  /// First address included in the region
  static var start: UInt16 { get }

  /// Last address included in the region
  static var end: UInt16 { get }

  /// Memory content
  var data: [UInt8] { get set }
}

extension ContinuousMemoryRegion {
  public static var size: UInt16 { return Self.end - Self.start + 1 }

  public func contains(globalAddress address: UInt16) -> Bool {
    return Self.start <= address && address <= Self.end
  }

  public func read(globalAddress address: UInt16) -> UInt8 {
    assert(self.contains(globalAddress: address))
    let localAddress = self.localAddress(from: address)
    return self.data[localAddress]
  }

  public func write(globalAddress address: UInt16, value: UInt8) {
    assert(self.contains(globalAddress: address))
    let localAddress = self.localAddress(from: address)
    self.data[localAddress] = value
  }

  private func localAddress(from address: UInt16) -> UInt16 {
    return address - Self.start
  }
}
