// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

/// 0xFF0F and 0xFFFF Interrupts
public class InterruptMemory: MemoryRegion {

  public static let ifAddress: UInt16 = 0xff0f
  public static let ieAddress: UInt16 = 0xffff

  /// Interrupt Flag
  public var `if`: UInt8 = 0x00

  /// Interrupt Enable
  public var ie:   UInt8 = 0x00

  public func contains(globalAddress address: UInt16) -> Bool {
    return address == InterruptMemory.ifAddress
      || address == InterruptMemory.ieAddress
  }

  public func read(globalAddress address: UInt16) -> UInt8 {
    assert(self.contains(globalAddress: address))
    switch address {
    case InterruptMemory.ifAddress: return self.if
    case InterruptMemory.ieAddress: return self.ie
    default:
      fatalError("Attempting to read invalid interrupt memory")
    }
  }

  public func write(globalAddress address: UInt16, value: UInt8) {
    assert(self.contains(globalAddress: address))
    switch address {
    case InterruptMemory.ifAddress: self.if = value
    case InterruptMemory.ieAddress: self.ie = value
    default:
      fatalError("Attempting to write invalid interrupt memory")
    }
  }
}
