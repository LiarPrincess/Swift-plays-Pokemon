// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

@testable import GameBoyKit

class FakeBusBootrom: BusBootrom {

  lazy var data: Data = {
    Data(count: MemoryMap.bootrom.count)
  }()

  func read(_ address: UInt16) -> UInt8 {
    return self.data[address]
  }

  func write(_ address: UInt16, value: UInt8) {
    // we will actually modify bootom
    // even if normal one is read-only
    self.data[address] = value
  }
}
