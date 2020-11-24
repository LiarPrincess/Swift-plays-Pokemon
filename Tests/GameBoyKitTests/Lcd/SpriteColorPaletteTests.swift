// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import GameBoyKit

class SpriteColorPaletteTests: XCTestCase {

  /// Transparent bits (0 and 1) should always be 0
  func test_color0() {
    let color: UInt8 = 0

    var value: UInt8 = 0b00
    var palette = SpriteColorPalette(value: value)
    XCTAssertEqual(palette.getColor(index: color), 0) // always 0
    XCTAssertEqual(palette.value, 0) // not even saved

    value = 0b01
    palette = SpriteColorPalette(value: value)
    XCTAssertEqual(palette.getColor(index: color), 0) // always 0
    XCTAssertEqual(palette.value, value) // not even saved

    value = 0b10
    palette = SpriteColorPalette(value: value)
    XCTAssertEqual(palette.getColor(index: color), 0) // always 0
    XCTAssertEqual(palette.value, value) // not even saved

    value = 0b11
    palette = SpriteColorPalette(value: value)
    XCTAssertEqual(palette.getColor(index: color), 0) // always 0
    XCTAssertEqual(palette.value, value) // not even saved
  }

  func test_colors123() {
    let colors: [UInt8] = [1, 2, 3]

    for color in colors {
      let shift = color * 2

      var value: UInt8 = 0b00 << shift
      var palette = SpriteColorPalette(value: value)
      XCTAssertEqual(palette.getColor(index: color), 0b00)
      XCTAssertEqual(palette.value, value) // check if we can restore it

      value = 0b01 << shift
      palette = SpriteColorPalette(value: value)
      XCTAssertEqual(palette.getColor(index: color), 0b01)
      XCTAssertEqual(palette.value, value) // check if we can restore it

      value = 0b10 << shift
      palette = SpriteColorPalette(value: value)
      XCTAssertEqual(palette.getColor(index: color), 0b10)
      XCTAssertEqual(palette.value, value) // check if we can restore it

      value = 0b11 << shift
      palette = SpriteColorPalette(value: value)
      XCTAssertEqual(palette.getColor(index: color), 0b11)
      XCTAssertEqual(palette.value, value) // check if we can restore it
    }
  }
}
