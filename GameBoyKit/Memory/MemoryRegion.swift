// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public typealias MemoryRegion = UnsafeMutableBufferPointer<UInt8>

extension MemoryRegion {

  internal static func allocate(_ region: ClosedRange<UInt16>) -> MemoryRegion {
      return MemoryRegion.allocate(capacity: region.count)
  }
}
