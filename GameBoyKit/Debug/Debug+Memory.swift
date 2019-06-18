// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

extension Debug {

  internal static func busDidRead(from address: UInt16, value: UInt8) {
    if fMemoryReads {
      print("> memory - reading \(value.hex) from \(address.hex)")
    }
  }

  internal static func busDidWrite(to address: UInt16, value: UInt8) {
    if fMemoryWrites {
      print("> memory - writing \(value.hex) to \(address.hex)")
    }
  }
}
