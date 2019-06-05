// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

/// FF01 and FF02 Serial Data Transfer (Link Cable)
public class SerialPortMemory: MemoryRegion {

  public static let sbAddress: UInt16 = 0xff01
  public static let scAddress: UInt16 = 0xff02

  /// Serial transfer data
  public var sb: UInt8 = 0x00

  /// Serial Transfer Control
  public var sc: UInt8 = 0x00

  public func contains(globalAddress address: UInt16) -> Bool {
    return address == SerialPortMemory.sbAddress
        || address == SerialPortMemory.scAddress
  }

  public func read(globalAddress address: UInt16) -> UInt8 {
    assert(self.contains(globalAddress: address))
    switch address {
    case SerialPortMemory.sbAddress: return self.sb
    case SerialPortMemory.scAddress: return self.sc
    default:
      fatalError("Attempting to read invalid serial port memory")
    }
  }

  public func write(globalAddress address: UInt16, value: UInt8) {
    assert(self.contains(globalAddress: address))
    switch address {
    case SerialPortMemory.sbAddress: self.sb = value
    case SerialPortMemory.scAddress: self.sc = value
    default:
      fatalError("Attempting to write invalid serial port memory")
    }
  }
}
