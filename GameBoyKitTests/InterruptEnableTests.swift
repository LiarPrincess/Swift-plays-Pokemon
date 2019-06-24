// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import GameBoyKit

class InterruptsTests: XCTestCase {

  func test_flag() {
    let interrupts = Interrupts()

    XCTAssertEqual(interrupts.vBlank,  false)
    XCTAssertEqual(interrupts.lcdStat, false)
    XCTAssertEqual(interrupts.timer,   false)
    XCTAssertEqual(interrupts.serial,  false)
    XCTAssertEqual(interrupts.joypad,  false)

    interrupts.flag = 1 << 0
    XCTAssertEqual(interrupts.vBlank, true)

    interrupts.flag = 1 << 1
    XCTAssertEqual(interrupts.lcdStat, true)

    interrupts.flag = 1 << 2
    XCTAssertEqual(interrupts.timer, true)

    interrupts.flag = 1 << 3
    XCTAssertEqual(interrupts.serial, true)

    interrupts.flag = 1 << 4
    XCTAssertEqual(interrupts.joypad, true)
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
