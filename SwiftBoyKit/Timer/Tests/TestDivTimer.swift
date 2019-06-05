// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

//import XCTest
//@testable import SwiftBoyKit
//
//class TestDivTimer: XCTestCase {
//
//  func test_divIncrement() {
//    let memory = FakeTimerMemory()
//    let timer = Timer(memory: memory)
//
//    for _ in 1..<64 {
//      timer.tick(cycles: 4)
//      XCTAssertEqual(memory.div, 0)
//    }
//
//    timer.tick(cycles: 4)
//    XCTAssertEqual(memory.div, 1)
//  }
//
//  func test_divOverflow() {
//    let memory = FakeTimerMemory()
//    let timer = Timer(memory: memory)
//
//    // next tick will overflow
//    memory.div = 0xff
//
//    for _ in 1..<64 {
//      timer.tick(cycles: 4)
//      XCTAssertEqual(memory.div, 0xff)
//    }
//
//    timer.tick(cycles: 4)
//    XCTAssertEqual(memory.div, 0)
//  }
//}
