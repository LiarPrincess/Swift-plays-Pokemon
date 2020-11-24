// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import GameBoyKit

private let lcdWidth = Lcd.Constants.width

private let indices = [
  0,
  2,
  8,
  lcdWidth / 4,
  lcdWidth / 2,
  lcdWidth / 4 * 3,
  lcdWidth - 1
]

class LcdLineBitArrayTests: XCTestCase {

  func test_trivial() {
    var array = LcdLineBitArray(initialValue: false)

    var index = 2
    XCTAssertFalse(array[index])
    array[index] = true
    XCTAssertTrue(array[index])

    index = lcdWidth / 2
    XCTAssertFalse(array[index])
    array[index] = true
    XCTAssertTrue(array[index])
  }

  func test_settingSingleValue_setsOnlyThisValue() {
    for indexToSet in indices {
      var array = LcdLineBitArray(initialValue: false)
      XCTAssertFalse(array[indexToSet])

      array[indexToSet] = true

      for i in 0..<lcdWidth {
        let expected = i == indexToSet
        XCTAssertEqual(
          array[i],
          expected,
          "index to set: \(indexToSet), index: \(i)"
        )
      }

      array[indexToSet] = false
      XCTAssertFalse(array[indexToSet])
    }
  }

  func test_settingMultipleValues_doesNotUnsetOther() {
    var array = LcdLineBitArray(initialValue: false)
    var alreadySetIndices = [Int]()

    for indexToSet in indices {
      array[indexToSet] = true
      alreadySetIndices.append(indexToSet)

      for i in 0..<lcdWidth {
        let expected = alreadySetIndices.contains(i)
        XCTAssertEqual(
          array[i],
          expected,
          "index to set: \(indexToSet), index: \(i)"
        )
      }
    }
  }
}
