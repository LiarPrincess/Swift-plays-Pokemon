// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

internal protocol BootromMemory: AnyObject {

  func read(_ address: UInt16) -> UInt8
  func write(_ address: UInt16, value: UInt8)
}

internal protocol CartridgeMemory: AnyObject {

  func readRom(_ address: UInt16) -> UInt8
  func writeRom(_ address: UInt16, value: UInt8)

  func readRam(_ address: UInt16) -> UInt8
  func writeRam(_ address: UInt16, value: UInt8)
}
