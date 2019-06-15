// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import SwiftBoyKit

class ArrayUIntTests: XCTestCase {

  // MARK: - Init

  func test_init_UInt8() {
    let value = Array(repeating: 1, count: UInt8(5))
    XCTAssertEqual(value, [1, 1, 1, 1, 1])
  }

  func test_init_UInt16() {
    let value = Array(repeating: 1, count: UInt16(5))
    XCTAssertEqual(value, [1, 1, 1, 1, 1])
  }

  // MARK: - Subscript

  func test_subscript_UInt8() {
    let array = [1, 2, 3, 4, 5]
    for i in 0..<array.count {
      XCTAssertEqual(array[UInt8(i)], array[i])
    }
  }

  func test_subscript_UInt16() {
    let array = [1, 2, 3, 4, 5]
    for i in 0..<array.count {
      XCTAssertEqual(array[UInt16(i)], array[i])
    }
  }
}
