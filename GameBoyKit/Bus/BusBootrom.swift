// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

/// Bootrom as seen by bus.
internal protocol BusBootrom: AnyObject {

  func read(_ address: UInt16) -> UInt8
  func write(_ address: UInt16, value: UInt8)
}

extension Bootrom: BusBootrom { }
