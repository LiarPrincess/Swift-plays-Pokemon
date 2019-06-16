// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

/// E000-FDFF Same as C000-DDFF (ECHO) (typically not used)
public class InternalRamEcho: MemoryRegion {

  public static let start: UInt16 = 0xe000
  public static let end:   UInt16 = 0xfdff
  public static let size:  UInt16 = end - start + 1

  private unowned let internalRam: InternalRam

  internal init(internalRam: InternalRam) {
    self.internalRam = internalRam
  }

  public func contains(globalAddress address: UInt16) -> Bool {
    return InternalRamEcho.start <= address && address <= InternalRamEcho.end
  }

  public func read(globalAddress address: UInt16) -> UInt8 {
    assert(self.contains(globalAddress: address))
    let mappedAddress = self.mappedAddress(from: address)
    return self.internalRam.read(globalAddress: mappedAddress)
  }

  public func write(globalAddress address: UInt16, value: UInt8) {
    assert(self.contains(globalAddress: address))
    let mappedAddress = self.mappedAddress(from: address)
    self.internalRam.write(globalAddress: mappedAddress, value: value)
  }

  private func mappedAddress(from address: UInt16) -> UInt16 {
    return address - 0x2000
  }
}
