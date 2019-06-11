// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import SwiftBoyKit

class DivTimerTests: XCTestCase {

  /// clockSpeed/divFrequency = 4_194_304/16_384 = 256
  /// 1. 250 cycles -> no increment (<256)
  /// 2. 260 cycles -> increment (>256)
  func test_increment() {
    let timer = DivTimer()

    for _ in 0..<25 {
      timer.tick(cycles: 10)
      XCTAssertEqual(timer.value, 0)
    }

    timer.tick(cycles: 10)
    XCTAssertEqual(timer.value, 1)
  }

  /// 1. Set div to 0xff
  /// 2. Overflow it
  /// 3. Should go back to 0
  func test_overflow() {
    let timer = DivTimer()

    timer.value = 0xff

    for _ in 0..<25 {
      timer.tick(cycles: 10)
      XCTAssertEqual(timer.value, 0xff)
    }

    timer.tick(cycles: 10)
    XCTAssertEqual(timer.value, 0x00)
  }
}