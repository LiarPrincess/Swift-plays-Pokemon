// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import SwiftBoyKit

class ColorPaletteTests: XCTestCase {

  func test_colorPalette() {
    let palette = ColorPalette()

    let colors: [UInt8] = [0, 1, 2, 3]
    let possibleValues: [UInt8] = [0b00, 0b01, 0b10, 0b11]

    for color in colors {
      let shift = color * 2
      for value in possibleValues {
        let byte = value << shift
        palette.byte = byte
        XCTAssertEqual(palette.getColor(tileValue: color), value)
        XCTAssertEqual(palette.byte, byte)
      }
    }
  }

  func test_transparentColorPalette() {
    let palette = TransparentColorPalette()

    let colors: [UInt8] = [1, 2, 3]
    let possibleValues: [UInt8] = [0b00, 0b01, 0b10, 0b11]

    // transparent bits (0 and 1) should always be 0
    for value in possibleValues {
      let byte = value
      palette.byte = byte
      XCTAssertEqual(palette.getColor(tileValue: 0), 0x00)
      XCTAssertEqual(palette.byte, byte & 0b11111100)
    }

    // color bits
    for color in colors {
      let shift = color * 2
      for value in possibleValues {
        let byte = value << shift
        palette.byte = byte
        XCTAssertEqual(palette.getColor(tileValue: color), value)
        XCTAssertEqual(palette.byte, byte)
      }
    }
  }
}
