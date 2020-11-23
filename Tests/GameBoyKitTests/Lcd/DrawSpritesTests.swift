// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import GameBoyKit

// swiftlint:disable line_length
// swiftlint:disable function_body_length

class DrawSpritesTests: LcdTestCase {

  // MARK: - Disable background and window

  private func disableBackgroundAndSprites(lcd: Lcd) {
    let enableMask = LcdControl.Masks.isBackgroundVisible | LcdControl.Masks.isWindowEnabled
    let disableMask = ~enableMask

    let value = lcd.control.value
    let disabledValue = value & disableMask
    lcd.control = LcdControl(value: disabledValue)
  }

  // MARK: - Tetris

  func test_tetris() {
    let lcd = self.createLcdWithTetris()
    self.disableBackgroundAndSprites(lcd: lcd)
    let lines = self.drawFramebuffer(lcd: lcd)

    // Tetris uses prrites to display current & next blocks
    let currentBlockStart = 56
    let currentBlockEnd = 71
    let currentBlockExpected = [
      "                                        333333333333333333333333                                                                                                ",
      "                                        322222233222222332222223                                                                                                ",
      "                                        322222233222222332222223                                                                                                ",
      "                                        322222233222222332222223                                                                                                ",
      "                                        322222233222222332222223                                                                                                ",
      "                                        322222233222222332222223                                                                                                ",
      "                                        322222233222222332222223                                                                                                ",
      "                                        333333333333333333333333                                                                                                ",
      "                                        33333333                                                                                                                ",
      "                                        32222223                                                                                                                ",
      "                                        32222223                                                                                                                ",
      "                                        32222223                                                                                                                ",
      "                                        32222223                                                                                                                ",
      "                                        32222223                                                                                                                ",
      "                                        32222223                                                                                                                ",
      "                                        33333333                                                                                                                "
    ]

    let nextBlockStart = 112
    let nextBlockEnd = 127
    let nextBlockExpected = [
      "                                                                                                                        333333333333333333333333                ",
      "                                                                                                                        311111133111111331111113                ",
      "                                                                                                                        313333133133331331333313                ",
      "                                                                                                                        313  313313  313313  313                ",
      "                                                                                                                        313  313313  313313  313                ",
      "                                                                                                                        313333133133331331333313                ",
      "                                                                                                                        311111133111111331111113                ",
      "                                                                                                                        333333333333333333333333                ",
      "                                                                                                                                        33333333                ",
      "                                                                                                                                        31111113                ",
      "                                                                                                                                        31333313                ",
      "                                                                                                                                        313  313                ",
      "                                                                                                                                        313  313                ",
      "                                                                                                                                        31333313                ",
      "                                                                                                                                        31111113                ",
      "                                                                                                                                        33333333                "
    ]

    for (index, line) in lines.enumerated() {
      let expectedLine: String = {
        switch index {
        case currentBlockStart...currentBlockEnd:
          return currentBlockExpected[index - currentBlockStart]
        case nextBlockStart...nextBlockEnd:
          return nextBlockExpected[index - nextBlockStart]
        default:
          return emptyLine
        }
      }()

      XCTAssertEqual(line, expectedLine, "Index: \(index)")
    }
  }
}
