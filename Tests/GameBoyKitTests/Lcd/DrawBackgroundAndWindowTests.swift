// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import GameBoyKit

// swiftlint:disable line_length
// swiftlint:disable function_body_length

/// Line that we will be using for tests.
private let line = 0
private let lcdWidth = Lcd.Constants.width

// In this tests we will draw both background and window to check
// if we correctly find start/end of each.
class DrawBackgroundAndWindowTests: LcdTestCase {

  // MARK: - Full background

  func test_windowDisabled_drawsBackground_wholeLine() {
    let lcd = self.createLcd(isWindowEnabled: false, // <- this
                             unshiftedWindowX: 0,
                             windowY: 0)

    let result = self.drawLine(lcd: lcd, line: line)
    let expected = "1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"
    XCTAssertEqual(result, expected)
  }

  func test_windowY_afterCurrentLine_drawsBackground_wholeLine() {
    let windowY = UInt8(5)
    assert(windowY > line)

    let lcd = self.createLcd(isWindowEnabled: true,
                             unshiftedWindowX: 3,
                             windowY: windowY) // <- this

    let result = self.drawLine(lcd: lcd, line: line)
    let expected = "1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"
    XCTAssertEqual(result, expected)
  }

  func test_windowX_afterVisibleArea_drawsBackground_wholeLine() {
    let windowX = lcdWidth + 3

    let lcd = self.createLcd(isWindowEnabled: true,
                             unshiftedWindowX: UInt8(windowX), // <- this
                             windowY: 0)

    let result = self.drawLine(lcd: lcd, line: line)
    let expected = "1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"
    XCTAssertEqual(result, expected)
  }

  // MARK: - Full window

  func test_windowX_atLineStart_drawsWindow_wholeLine() {
    let lcd = self.createLcd(isWindowEnabled: true,
                             unshiftedWindowX: 0, // <- this
                             windowY: 0)

    let result = self.drawLine(lcd: lcd, line: line)
    let expected = "2222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222"
    XCTAssertEqual(result, expected)
  }

  // MARK: - Partial window

  func test_windowX_insideFirstTile_startsWindow_insideFirstTile() {
    let lcd = self.createLcd(isWindowEnabled: true,
                             unshiftedWindowX: 3, // <- this
                             windowY: 0)

    let result = self.drawLine(lcd: lcd, line: line)
    let expected = "1112222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222"
    XCTAssertEqual(result, expected)
  }

  func test_windowX_insideLastTile_startsWindow_insideLastTile() {
    let windowX = lcdWidth - 3

    let lcd = self.createLcd(isWindowEnabled: true,
                             unshiftedWindowX: UInt8(windowX), // <- this
                             windowY: 0)

    let result = self.drawLine(lcd: lcd, line: line)
    let expected = "1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111222"
    XCTAssertEqual(result, expected)
  }

  // MARK: - Helpers

  /// Final configuration:
  /// - control.isWindowEnabled - controled by function argument
  /// - windowX - controled by function argument
  /// - windowY - controled by function argument
  /// - background - uses 'from9800to9bff' tile map which always draws '1'
  /// - window     - uses 'from9c00to9fff' tile map which always draws '2'
  private func createLcd(isWindowEnabled: Bool,
                         unshiftedWindowX: UInt8,
                         windowY: UInt8) -> Lcd
  {
    let interrupts = Interrupts()
    let lcd = Lcd(interrupts: interrupts)

    lcd.control = LcdControl(isLcdEnabled: true,
                             isBackgroundVisible: true,
                             isWindowEnabled: isWindowEnabled, // <-- This
                             isSpriteEnabled: true,
                             backgroundTileMap: .from9800to9bff,
                             windowTileMap: .from9c00to9fff,
                             tileDataSelect: .from8000to8fff,
                             isSpriteHeight16: false)

    lcd.status = LcdStatus(isOamInterruptEnabled: false,
                           isVBlankInterruptEnabled: false,
                           isHBlankInterruptEnabled: false,
                           isLineCompareInterruptEnabled: false,
                           isLineCompareInterrupt: false,
                           mode: .hBlank)

    lcd.scrollY = 0
    lcd.scrollX = 0
    lcd.line = UInt8(line)
    lcd.lineCompare = 0

    // backgroundColorPalette will not change tile color
    lcd.backgroundColorPalette = BackgroundColorPalette(value: 0b1110_0100)
    lcd.spriteColorPalette0 = SpriteColorPalette(value: 0xff)
    lcd.spriteColorPalette1 = SpriteColorPalette(value: 0xff)
    lcd.windowY = windowY
    lcd.windowX = unshiftedWindowX + UInt8(Lcd.Constants.windowXShift)

    assert(lcd.backgroundColorPalette.color0 == 0)
    assert(lcd.backgroundColorPalette.color1 == 1)
    assert(lcd.backgroundColorPalette.color2 == 2)
    assert(lcd.backgroundColorPalette.color3 == 3)

    // === Tile map ===

    // Background -> 1st tile
    let backgroundTileMap = MemoryMap.VideoRam.tileMap9800to9bff
    for address in backgroundTileMap {
      lcd.writeVideoRam(address, value: 0)
    }

    // Window -> 2nd tile
    let windowTileMap = MemoryMap.VideoRam.tileMap9c00to9fff
    for address in windowTileMap {
      lcd.writeVideoRam(address, value: 1)
    }

    // === Tiles ===

    // 1st tile, 1st line -> all 1
    let firstTileStart = MemoryMap.VideoRam.tileData.start
    lcd.writeVideoRam(firstTileStart + 0, value: 0b1111_1111) // data 1
    lcd.writeVideoRam(firstTileStart + 1, value: 0b0000_0000) // data 2
    //                                 that gives: 1111_1111 <- all 1

    // 2nd tile, 1st line -> all 2
    let secondTileStart = firstTileStart + UInt16(Tile.Constants.byteCount)
    lcd.writeVideoRam(secondTileStart + 0, value: 0b0000_0000) // data 1
    lcd.writeVideoRam(secondTileStart + 1, value: 0b1111_1111) // data 2
    //                                  that gives: 2222_2222 <- all 2

    return lcd
  }
}
