// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import SwiftBoyKit

class TestDivTimer: XCTestCase {

  /// clockSpeed/divFrequency = 4_194_304/16_384 = 256
  /// 1. 250 cycles -> no increment (<256)
  /// 2. 260 cycles -> increment (>256)
  func test_divIncrement() {
    let timer = TimerMemory()

    for _ in 0..<25 {
      timer.tick(cycles: 10)
      XCTAssertEqual(timer.div, 0)
    }

    timer.tick(cycles: 10)
    XCTAssertEqual(timer.div, 1)
  }

  /// 1. Set div to 0xff
  /// 2. Overflow it
  /// 3. Should go back to 0
  func test_divOverflow() {
    let timer = TimerMemory()

    timer.div = 0xff

    for _ in 0..<25 {
      timer.tick(cycles: 10)
      XCTAssertEqual(timer.div, 0xff)
    }

    timer.tick(cycles: 10)
    XCTAssertEqual(timer.div, 0x00)
  }
}
