// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import SwiftBoyKit

class InterruptsTests: XCTestCase {

  func test_isEnabled() {
    let interrupts = Interrupts()

    XCTAssertEqual(interrupts.isEnabled(.vBlank),  false)
    XCTAssertEqual(interrupts.isEnabled(.lcdStat), false)
    XCTAssertEqual(interrupts.isEnabled(.timer),   false)
    XCTAssertEqual(interrupts.isEnabled(.serial),  false)
    XCTAssertEqual(interrupts.isEnabled(.joypad),  false)

    interrupts.ie = Interrupts.vBlankMask
    XCTAssertEqual(interrupts.isEnabled(.vBlank), true)

    interrupts.ie = Interrupts.lcdStatMask
    XCTAssertEqual(interrupts.isEnabled(.lcdStat), true)

    interrupts.ie = Interrupts.timerMask
    XCTAssertEqual(interrupts.isEnabled(.timer), true)

    interrupts.ie = Interrupts.serialMask
    XCTAssertEqual(interrupts.isEnabled(.serial), true)

    interrupts.ie = Interrupts.joypadMask
    XCTAssertEqual(interrupts.isEnabled(.joypad), true)
  }

  func test_isSet() {
    let interrupts = Interrupts()

    XCTAssertEqual(interrupts.isSet(.vBlank),  false)
    XCTAssertEqual(interrupts.isSet(.lcdStat), false)
    XCTAssertEqual(interrupts.isSet(.timer),   false)
    XCTAssertEqual(interrupts.isSet(.serial),  false)
    XCTAssertEqual(interrupts.isSet(.joypad),  false)

    interrupts.if = Interrupts.vBlankMask
    XCTAssertEqual(interrupts.isSet(.vBlank), true)

    interrupts.if = Interrupts.lcdStatMask
    XCTAssertEqual(interrupts.isSet(.lcdStat), true)

    interrupts.if = Interrupts.timerMask
    XCTAssertEqual(interrupts.isSet(.timer), true)

    interrupts.if = Interrupts.serialMask
    XCTAssertEqual(interrupts.isSet(.serial), true)

    interrupts.if = Interrupts.joypadMask
    XCTAssertEqual(interrupts.isSet(.joypad), true)
  }

  func test_set() {
    let interrupts = Interrupts()

    interrupts.if = 0
    interrupts.set(.vBlank)
    XCTAssertEqual(interrupts.if, Interrupts.vBlankMask)

    interrupts.if = 0
    interrupts.set(.lcdStat)
    XCTAssertEqual(interrupts.if, Interrupts.lcdStatMask)

    interrupts.if = 0
    interrupts.set(.timer)
    XCTAssertEqual(interrupts.if, Interrupts.timerMask)

    interrupts.if = 0
    interrupts.set(.serial)
    XCTAssertEqual(interrupts.if, Interrupts.serialMask)

    interrupts.if = 0
    interrupts.set(.joypad)
    XCTAssertEqual(interrupts.if, Interrupts.joypadMask)
  }

  func test_reset() {
    let interrupts = Interrupts()

    interrupts.if = Interrupts.vBlankMask
    interrupts.reset(.vBlank)
    XCTAssertEqual(interrupts.if, 0)

    interrupts.if = Interrupts.lcdStatMask
    interrupts.reset(.lcdStat)
    XCTAssertEqual(interrupts.if, 0)

    interrupts.if = Interrupts.timerMask
    interrupts.reset(.timer)
    XCTAssertEqual(interrupts.if, 0)

    interrupts.if = Interrupts.serialMask
    interrupts.reset(.serial)
    XCTAssertEqual(interrupts.if, 0)

    interrupts.if = Interrupts.joypadMask
    interrupts.reset(.joypad)
    XCTAssertEqual(interrupts.if, 0)
  }
}
