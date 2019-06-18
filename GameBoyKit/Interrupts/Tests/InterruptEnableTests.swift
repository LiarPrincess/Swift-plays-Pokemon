// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import GameBoyKit

class InterruptsTests: XCTestCase {

  func test_isEnabled() {
    let isEnabled = InterruptEnable()

    XCTAssertEqual(isEnabled.vBlank,  false)
    XCTAssertEqual(isEnabled.lcdStat, false)
    XCTAssertEqual(isEnabled.timer,   false)
    XCTAssertEqual(isEnabled.serial,  false)
    XCTAssertEqual(isEnabled.joypad,  false)

    isEnabled.value = 1 << 0
    XCTAssertEqual(isEnabled.vBlank, true)

    isEnabled.value = 1 << 1
    XCTAssertEqual(isEnabled.lcdStat, true)

    isEnabled.value = 1 << 2
    XCTAssertEqual(isEnabled.timer, true)

    isEnabled.value = 1 << 3
    XCTAssertEqual(isEnabled.serial, true)

    isEnabled.value = 1 << 4
    XCTAssertEqual(isEnabled.joypad, true)
  }
}
