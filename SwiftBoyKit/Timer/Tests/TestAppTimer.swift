// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import SwiftBoyKit

class TestAppTimer: XCTestCase {

  private let disabled:   UInt8 = 0b000
  private let enabled:    UInt8 = 0b100
  private let period16:   UInt8 = 0b01
  private let period1024: UInt8 = 0b00

  func test_period16_incrementsAt_16cycles() {
    let interrupts = Interrupts()
    let timer = AppTimer(interrupts: interrupts)

    let tac = enabled | period16
    timer.write(globalAddress: AppTimer.tacAddress, value: tac)

    timer.tick(cycles: 8)
    XCTAssertEqual(timer.tima, 0x00)

    timer.tick(cycles: 8)
    XCTAssertEqual(timer.tima, 0x01)

    XCTAssertEqual(interrupts.ie, 0)
    XCTAssertEqual(interrupts.if, 0)
  }

  func test_period1024_incrementsAt_1024cycles() {
    let interrupts = Interrupts()
    let timer = AppTimer(interrupts: interrupts)

    let tac = enabled | period1024
    timer.write(globalAddress: AppTimer.tacAddress, value: tac)

    for _ in 0..<4 {
      timer.tick(cycles: 250)
      XCTAssertEqual(timer.tima, 0x00)
    }

    timer.tick(cycles: 24)
    XCTAssertEqual(timer.tima, 0x01)

    XCTAssertEqual(interrupts.ie, 0)
    XCTAssertEqual(interrupts.if, 0)
  }

  func test_disabled_doesNothing() {
    let interrupts = Interrupts()
    let timer = AppTimer(interrupts: interrupts)

    let tac = disabled | period16
    timer.write(globalAddress: AppTimer.tacAddress, value: tac)

    timer.tick(cycles: 8)
    XCTAssertEqual(timer.tima, 0x00)

    timer.tick(cycles: 8)
    XCTAssertEqual(timer.tima, 0x00)

    // just to be sure
    timer.tick(cycles: 8)
    XCTAssertEqual(timer.tima, 0x00)

    XCTAssertEqual(interrupts.ie, 0)
    XCTAssertEqual(interrupts.if, 0)
  }

  func test_overflow() {
    let interrupts = Interrupts()
    let timer = AppTimer(interrupts: interrupts)

    let tac = enabled | period16
    timer.write(globalAddress: AppTimer.tacAddress, value: tac)

    // this value should be set after overflow
    let tma = UInt8(0x16)
    timer.write(globalAddress: AppTimer.tmaAddress, value: tma)

    // tick up until tima = 255
    for i in 0..<255 {
      timer.tick(cycles: 16)
      XCTAssertEqual(timer.tima, UInt8(i + 1))
    }

    // tima = 255, it should overflow after 16 cycles
    timer.tick(cycles: 8)
    XCTAssertEqual(timer.tima, 0xff) // not yet...

    timer.tick(cycles: 8)
    XCTAssertEqual(timer.tima, tma) // now!

    XCTAssertEqual(interrupts.ie, 0)
    XCTAssertEqual(interrupts.if, Interrupts.timerMask)
  }
}
