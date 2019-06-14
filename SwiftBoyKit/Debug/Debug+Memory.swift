// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

extension Debug {

  internal static func memoryDidRead(from address: UInt16, region: MemoryRegion, value: UInt8) {
    if self.mode == .full {
      print("> memory - reading \(value.hex) from \(address.hex) (\(region))")
    }
  }

  internal static func memoryDidWrite(to address: UInt16, region: MemoryRegion, value: UInt8) {
    if self.mode == .full || self.mode == .onlyMemoryWrites {
      print("> memory - writing \(value.hex) to \(address.hex) (\(region))")
    }
  }
}
