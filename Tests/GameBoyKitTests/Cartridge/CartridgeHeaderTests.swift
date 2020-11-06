// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import GameBoyKit

class CartridgeHeaderTests: CartridgeTestCase {

  func test_invalidSize_throws() {
    do {
      var rom = createTetrisRom()
      rom[CartridgeMap.romSize] += 1

      _ = try CartridgeHeader(rom: rom, skipChecks: false)
      XCTFail("It should throw")
    } catch { }
  }

  func test_tetris() throws {
    let rom = self.createTetrisRom()
    let header = try CartridgeHeader(rom: rom, skipChecks: false)

    XCTAssertEqual(header.title, "TETRIS")
    XCTAssertEqual(header.romSize.byteCount, 32_768)
    XCTAssertEqual(header.ramSize.byteCount, 0)

    switch header.type.value {
    case .noMBC(hasRam: false, hasBattery: false):
      break
    default:
      XCTFail(String(describing: header.type))
    }
  }

  func test_pokemon() throws {
    let rom = self.createPokemonRedRom()
    let header = try CartridgeHeader(rom: rom, skipChecks: false)

    XCTAssertEqual(header.title, "POKEMON RED")
    XCTAssertEqual(header.romSize.byteCount, 1_048_576)
    XCTAssertEqual(header.ramSize.byteCount, 32_768)

    switch header.type.value {
    case .mbc3(hasRam: true, hasBattery: true, hasRTC: false):
      break
    default:
      XCTFail(String(describing: header.type))
    }
  }
}
