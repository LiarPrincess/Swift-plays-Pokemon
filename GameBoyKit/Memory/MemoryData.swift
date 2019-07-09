// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public typealias MemoryData = UnsafeMutableBufferPointer<UInt8>

extension MemoryData {

  internal static func allocate(_ region: ClosedRange<UInt16>) -> MemoryData {
    let result = MemoryData.allocate(capacity: region.count)
    result.assign(repeating: 0)
    return result
  }
}
