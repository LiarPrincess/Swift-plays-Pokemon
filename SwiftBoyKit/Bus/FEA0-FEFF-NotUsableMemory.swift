// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

private let pandocs = "See 'http://bgb.bircd.org/pandocs.htm#memorymap' for details."

/// FEA0-FEFF   Not Usable
public class NotUsableMemory: MemoryRegion {

  public static let start: UInt16 = 0xfea0
  public static let end:   UInt16 = 0xfeff

  public func contains(globalAddress address: UInt16) -> Bool {
    return NotUsableMemory.start <= address && address <= NotUsableMemory.end
  }

  public func read(globalAddress address: UInt16) -> UInt8 {
    fatalError("Attempting to read from non-usable memory at: \(address.hex). \(pandocs)")
  }

  public func write(globalAddress address: UInt16, value: UInt8) {
    fatalError("Attempting to write to non-usable memory at: \(address.hex). \(pandocs)")
  }
}
