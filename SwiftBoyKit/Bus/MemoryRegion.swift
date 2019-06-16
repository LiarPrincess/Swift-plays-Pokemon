// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

// TODO: Remove this and go for switch in bus

/// Stand-alone part of the memory
internal protocol MemoryRegion: AnyObject {

  /// Does this memory region contains this address?
  func contains(globalAddress address: UInt16) -> Bool

  /// Write value from memory
  func read(globalAddress address: UInt16) -> UInt8

  /// Write value to memory
  func write(globalAddress address: UInt16, value: UInt8)
}

/// Memory region that is internally backed by array
internal protocol ContinuousMemoryRegion: MemoryRegion {

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

  internal func localAddress(from address: UInt16) -> UInt16 {
    return address - Self.start
  }
}
