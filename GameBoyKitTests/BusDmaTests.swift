// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import GameBoyKit

class BusDmaTests: XCTestCase {

  func test_dma() {
    let bus = self.createBus()

    // fill source (somewhere in external ram)
    let sourceStart: UInt16 = 0xab00
    let sourceEnd:   UInt16 = 0xab9f

    for address in sourceStart...sourceEnd {
      let value = UInt8(address & 0x00ff)
      bus.write(address, value: value)
    }

    // dma
    let writeValue = UInt8(sourceStart >> 8)
    bus.write(MemoryMap.Lcd.dma, value: writeValue)

    // check values at 0xfeXX
    for address in sourceStart...sourceEnd {
      let dmaAddress = MemoryMap.oam.start + address & 0x00ff

      let value = bus.read(dmaAddress)
      let expectedValue = UInt8(address & 0x00ff)
      XCTAssertEqual(expectedValue, value)
    }
  }
}
