// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import GameBoyKit

class StringPadTests: XCTestCase {

  func test_emptyString() {
    let value = "".padLeft(toLength: 3)
    XCTAssertEqual(value, "   ")
  }

  func test_shorterString() {
    let value = "1".padLeft(toLength: 3)
    XCTAssertEqual(value, "  1")
  }

  func test_equalString() {
    let value = "123".padLeft(toLength: 3)
    XCTAssertEqual(value, "123")
  }

  func test_longerString() {
    let value = "12345".padLeft(toLength: 3)
    XCTAssertEqual(value, "12345")
  }
}
