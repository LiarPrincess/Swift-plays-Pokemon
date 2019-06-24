// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import GameBoyKit

class LcdTileIndexTests: XCTestCase {

  func test_from9800to9bff() {
    let lcd = Lcd()
    let map = TileMap.from9800to9bff

    XCTAssertEqual(lcd.getTileIndexAddress(from: map, row:  0, column:  0), 0x9800)
    XCTAssertEqual(lcd.getTileIndexAddress(from: map, row:  0, column:  1), 0x9801)
    XCTAssertEqual(lcd.getTileIndexAddress(from: map, row:  1, column:  0), 0x9820)
    XCTAssertEqual(lcd.getTileIndexAddress(from: map, row: 31, column: 31), 0x9bff)
  }

  func test_from9c00to9fff() {
    let lcd = Lcd()
    let map = TileMap.from9c00to9fff

    XCTAssertEqual(lcd.getTileIndexAddress(from: map, row:  0, column:  0), 0x9c00)
    XCTAssertEqual(lcd.getTileIndexAddress(from: map, row:  0, column:  1), 0x9c01)
    XCTAssertEqual(lcd.getTileIndexAddress(from: map, row:  1, column:  0), 0x9c20)
    XCTAssertEqual(lcd.getTileIndexAddress(from: map, row: 31, column: 31), 0x9fff)
  }
}
