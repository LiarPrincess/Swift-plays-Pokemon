// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

/// Stand-alone part of the memory
internal protocol MemoryRegion: AnyObject {

  /// Does this memory region contains this address?
  func contains(globalAddress address: UInt16) -> Bool

  /// Read value from memory
  func read(globalAddress address: UInt16) -> UInt8

  /// Write value to memory
  func write(globalAddress address: UInt16, value: UInt8)
}
