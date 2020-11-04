// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import GameBoyKit

class DataUIntTests: XCTestCase {

  func test_subscript_UInt8() {
    let array: [UInt8] = [1, 2, 3, 4, 5]
    let data = Data(array)

    for i in 0..<data.count {
      XCTAssertEqual(data[UInt8(i)], array[i])
    }
  }

  func test_subscript_UInt16() {
    let array: [UInt8] = [1, 2, 3, 4, 5]
    let data = Data(array)

    for i in 0..<data.count {
      XCTAssertEqual(data[UInt16(i)], array[i])
    }
  }
}
