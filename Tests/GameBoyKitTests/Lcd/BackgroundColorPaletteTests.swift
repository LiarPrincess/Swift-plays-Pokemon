// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import GameBoyKit

class BackgroundColorPaletteTests: XCTestCase {

  func test_main() {
    let colors: [UInt8] = [0, 1, 2, 3]

    for color in colors {
      let shift = color * 2

      var value: UInt8 = 0b00 << shift
      var palette = BackgroundColorPalette(value: value)
      XCTAssertEqual(palette.getColor(index: color), 0b00)
      XCTAssertEqual(palette.value, value) // check if we can restore it

      value = 0b01 << shift
      palette = BackgroundColorPalette(value: value)
      XCTAssertEqual(palette.getColor(index: color), 0b01)
      XCTAssertEqual(palette.value, value) // check if we can restore it

      value = 0b10 << shift
      palette = BackgroundColorPalette(value: value)
      XCTAssertEqual(palette.getColor(index: color), 0b10)
      XCTAssertEqual(palette.value, value) // check if we can restore it

      value = 0b11 << shift
      palette = BackgroundColorPalette(value: value)
      XCTAssertEqual(palette.getColor(index: color), 0b11)
      XCTAssertEqual(palette.value, value) // check if we can restore it
    }
  }
}
