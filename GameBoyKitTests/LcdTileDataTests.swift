// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import GameBoyKit

class LcdTileDataTests: XCTestCase {

  func test_tileDataAddress_from8000() {
    let lcd = self.createLcd()
    lcd.control.value = 1 << 4

    XCTAssertEqual(lcd.getTileDataAddress(tileIndex: 0), 0x8000)
    XCTAssertEqual(lcd.getTileDataAddress(tileIndex: 1), 0x8010)
    XCTAssertEqual(lcd.getTileDataAddress(tileIndex: 127), 0x87f0)
    XCTAssertEqual(lcd.getTileDataAddress(tileIndex: 128), 0x8800)
    XCTAssertEqual(lcd.getTileDataAddress(tileIndex: 254), 0x8fe0)
    XCTAssertEqual(lcd.getTileDataAddress(tileIndex: 255), 0x8ff0)
  }

  func test_tileDataAddress_from8800() {
    let lcd = self.createLcd()
    lcd.control.value = 0

    XCTAssertEqual(lcd.getTileDataAddress(tileIndex: 0), 0x9000)
    XCTAssertEqual(lcd.getTileDataAddress(tileIndex: 1), 0x9010)
    XCTAssertEqual(lcd.getTileDataAddress(tileIndex: 127), 0x97f0)
    XCTAssertEqual(lcd.getTileDataAddress(tileIndex: 128), 0x8800)
    XCTAssertEqual(lcd.getTileDataAddress(tileIndex: 254), 0x8fe0)
    XCTAssertEqual(lcd.getTileDataAddress(tileIndex: 255), 0x8ff0)
  }
}
