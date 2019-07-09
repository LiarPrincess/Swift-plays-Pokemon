// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
import XCTest
@testable import GameBoyKit

class LcdColorValueTests: XCTestCase {

  /// Source: http://www.codeslinger.co.uk/pages/projects/gameboy/graphics.html
  /// Section: 'How to draw a tile/sprite from memory'
  func test_rawColorValue() {
    let lcd = self.createLcd()

    let data2: UInt8 = 0b1010_1110
    let data1: UInt8 = 0b0011_0101
    //         expected: 2031_2321

    XCTAssertEqual(lcd.getColorValue(data1, data2, bit: 0), 0b10)
    XCTAssertEqual(lcd.getColorValue(data1, data2, bit: 1), 0b00)
    XCTAssertEqual(lcd.getColorValue(data1, data2, bit: 2), 0b11)
    XCTAssertEqual(lcd.getColorValue(data1, data2, bit: 3), 0b01)
    XCTAssertEqual(lcd.getColorValue(data1, data2, bit: 4), 0b10)
    XCTAssertEqual(lcd.getColorValue(data1, data2, bit: 5), 0b11)
    XCTAssertEqual(lcd.getColorValue(data1, data2, bit: 6), 0b10)
    XCTAssertEqual(lcd.getColorValue(data1, data2, bit: 7), 0b01)
  }
}
