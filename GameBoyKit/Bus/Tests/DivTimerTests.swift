// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import GameBoyKit

class DivTimerTests: XCTestCase {

  func test_increment() {
    let timer = Timer()

    // 250 cycles -> no increment (<256)
    for _ in 0..<25 {
      timer.tick(cycles: 10)
      XCTAssertEqual(timer.div, 0)
    }

    // 260 cycles -> increment (>256)
    timer.tick(cycles: 10)
    XCTAssertEqual(timer.div, 1)
  }

  func test_overflow() {
    let timer = Timer()

    // Set div to 0xff
    for i in 0..<0xff {
      timer.tick(cycles: 0xff)
      timer.tick(cycles: 0x01) // to go to next div
      XCTAssertEqual(timer.div, UInt8(i + 1))
    }

    // Almost overflow it
    for _ in 0..<25 {
      timer.tick(cycles: 10)
      XCTAssertEqual(timer.div, 0xff)
    }

    // Overflow it -> Should go back to 0
    timer.tick(cycles: 10)
    XCTAssertEqual(timer.div, 0x00)
  }
}
