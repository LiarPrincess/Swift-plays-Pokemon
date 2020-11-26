// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import GameBoyKit

private let lcdWidth = Lcd.Constants.width

private let coordinates = [
  0,
  2,
  8,
  lcdWidth / 4,
  lcdWidth / 2,
  lcdWidth / 4 * 3,
  lcdWidth - 1
]

class TileColorInLineTests: XCTestCase {

  func test_differentColorValues() {
    let array = TileColorInLine()

    var x = 2
    var color: UInt8 = 0
    XCTAssertTrue(array.isColorZero(x: x))
    array.set(x: x, color: color)
    XCTAssertTrue(array.isColorZero(x: x))

    x = lcdWidth / 4
    color = 1
    XCTAssertTrue(array.isColorZero(x: x))
    array.set(x: x, color: color)
    XCTAssertFalse(array.isColorZero(x: x))

    x = lcdWidth / 2
    color = 2
    XCTAssertTrue(array.isColorZero(x: x))
    array.set(x: x, color: color)
    XCTAssertFalse(array.isColorZero(x: x))

    x = lcdWidth / 4 * 3
    color = 3
    XCTAssertTrue(array.isColorZero(x: x))
    array.set(x: x, color: color)
    XCTAssertFalse(array.isColorZero(x: x))
  }

  func test_settingSingleValue_setsOnlyThisValue() {
    for x in coordinates {
      let array = TileColorInLine()
      XCTAssertTrue(array.isColorZero(x: x))

      array.set(x: x, color: 1)

      for innerX in 0..<lcdWidth {
        let expectedIsZero = innerX != x
        XCTAssertEqual(
          array.isColorZero(x: innerX),
          expectedIsZero,
          "x: \(x), innerX: \(innerX)"
        )
      }

      array.set(x: x, color: 0)
      XCTAssertTrue(array.isColorZero(x: x))
    }
  }

  func test_settingMultipleValues_doesNotUnsetOther() {
    let array = TileColorInLine()
    var indicesSetTo1 = [Int]()

    var color: UInt8 = 1
    for x in coordinates {
      array.set(x: x, color: color)
      indicesSetTo1.append(x)

      for innerX in 0..<lcdWidth {
        let expectedIsZero = !indicesSetTo1.contains(innerX)
        XCTAssertEqual(
          array.isColorZero(x: innerX),
          expectedIsZero,
          "x: \(x), innerX: \(innerX)"
        )
      }
    }

    color = 0
    for x in coordinates.reversed() { // 'reversed' so we can use 'removeLast'
      array.set(x: x, color: color)
      indicesSetTo1.removeLast()

      for innerX in 0..<lcdWidth {
        let expectedIsZero = !indicesSetTo1.contains(innerX)
        XCTAssertEqual(
          array.isColorZero(x: innerX),
          expectedIsZero,
          "x: \(x), innerX: \(innerX)"
        )
      }
    }
  }
}
