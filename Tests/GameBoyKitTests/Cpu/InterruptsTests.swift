// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import GameBoyKit

class InterruptsTests: XCTestCase {

  func test_flag() {
    let interrupts = Interrupts()

    XCTAssertEqual(interrupts.isVBlankSet,  false)
    XCTAssertEqual(interrupts.isLcdStatSet, false)
    XCTAssertEqual(interrupts.isTimerSet,   false)
    XCTAssertEqual(interrupts.isSerialSet,  false)
    XCTAssertEqual(interrupts.isJoypadSet,  false)

    interrupts.flag = 1 << 0
    XCTAssertEqual(interrupts.isVBlankSet, true)

    interrupts.flag = 1 << 1
    XCTAssertEqual(interrupts.isLcdStatSet, true)

    interrupts.flag = 1 << 2
    XCTAssertEqual(interrupts.isTimerSet, true)

    interrupts.flag = 1 << 3
    XCTAssertEqual(interrupts.isSerialSet, true)

    interrupts.flag = 1 << 4
    XCTAssertEqual(interrupts.isJoypadSet, true)
  }

  func test_enabled() {
    let interrupts = Interrupts()

    XCTAssertEqual(interrupts.isVBlankEnabled,  false)
    XCTAssertEqual(interrupts.isLcdStatEnabled, false)
    XCTAssertEqual(interrupts.isTimerEnabled,   false)
    XCTAssertEqual(interrupts.isSerialEnabled,  false)
    XCTAssertEqual(interrupts.isJoypadEnabled,  false)

    interrupts.enable = 1 << 0
    XCTAssertEqual(interrupts.isVBlankEnabled, true)

    interrupts.enable = 1 << 1
    XCTAssertEqual(interrupts.isLcdStatEnabled, true)

    interrupts.enable = 1 << 2
    XCTAssertEqual(interrupts.isTimerEnabled, true)

    interrupts.enable = 1 << 3
    XCTAssertEqual(interrupts.isSerialEnabled, true)

    interrupts.enable = 1 << 4
    XCTAssertEqual(interrupts.isJoypadEnabled, true)
  }
}
