//// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//// If a copy of the MPL was not distributed with this file,
//// You can obtain one at http://mozilla.org/MPL/2.0/.
//
//import XCTest
//@testable import GameBoyKit
//
//class LineDrawerColorValueTests: XCTestCase {
//
//  /// Source: http://www.codeslinger.co.uk/pages/projects/gameboy/graphics.html
//  /// Section: 'How to draw a tile/sprite from memory'
//  func test_rawColorValue() {
//    let bus = Bus()
//    let drawer = LineDrawer(memory: bus)
//
//    let data2: UInt8 = 0b1010_1110
//    let data1: UInt8 = 0b0011_0101
//    //         expected: 2031_2321
//
//    XCTAssertEqual(drawer.getRawColorValue(data1, data2, bitOffset: 0), 0b10)
//    XCTAssertEqual(drawer.getRawColorValue(data1, data2, bitOffset: 1), 0b00)
//    XCTAssertEqual(drawer.getRawColorValue(data1, data2, bitOffset: 2), 0b11)
//    XCTAssertEqual(drawer.getRawColorValue(data1, data2, bitOffset: 3), 0b01)
//    XCTAssertEqual(drawer.getRawColorValue(data1, data2, bitOffset: 4), 0b10)
//    XCTAssertEqual(drawer.getRawColorValue(data1, data2, bitOffset: 5), 0b11)
//    XCTAssertEqual(drawer.getRawColorValue(data1, data2, bitOffset: 6), 0b10)
//    XCTAssertEqual(drawer.getRawColorValue(data1, data2, bitOffset: 7), 0b01)
//  }
//}
