// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import GameBoyKit

class ColorPaletteTests: XCTestCase {

  func test_backgroundColorPalette() {
    let palette = BackgroundColorPalette()

    let colors: [UInt8] = [0, 1, 2, 3]
    let possibleValues: [UInt8] = [0b00, 0b01, 0b10, 0b11]

    for color in colors {
      let shift = color * 2
      for v in possibleValues {
        let value = v << shift
        palette.value = value
        XCTAssertEqual(palette.getColor(base: color), v)
        XCTAssertEqual(palette.value, value)
      }
    }
  }

  func test_objectColorPalette() {
    let palette = ObjectColorPalette()

    let colors: [UInt8] = [1, 2, 3]
    let possibleValues: [UInt8] = [0b00, 0b01, 0b10, 0b11]

    // transparent bits (0 and 1) should always be 0
    for v in possibleValues {
      let value = v
      palette.value = value
      XCTAssertEqual(palette.getColor(base: 0), 0x00)
      XCTAssertEqual(palette.value, value & 0b11111100)
    }

    // color bits
    for color in colors {
      let shift = color * 2
      for v in possibleValues {
        let value = v << shift
        palette.value = value
        XCTAssertEqual(palette.getColor(base: color), v)
        XCTAssertEqual(palette.value, value)
      }
    }
  }
}
