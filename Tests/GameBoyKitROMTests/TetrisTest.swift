// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import GameBoyKit

private let romUrl = romsDir
  .appendingPathComponent("Tetris.gb")

private let dumpDirUrl = romsDir
  .appendingPathComponent("Tests - Tetris")
  .appendingPathComponent("Dump")

enum TetrisTest {

  // Tetris will always use 'compareWithDumps',
  // but we still want to expose this fact outisde of the function.
  static func run(compareWithDumps: Void) {
    print("Tetris test")

    let bootrom = Bootrom.dmg
    let cartridge = Self.openRom()
    let input = DummyInputProvider()
    let gameBoy = GameBoy(bootrom: bootrom, cartridge: cartridge, input: input)

    runDump(gameBoy: gameBoy, dumpDirUrl: dumpDirUrl)
  }

  private static func openRom() -> Cartridge {
    do {
      let data = try Data(contentsOf: romUrl)
      return try CartridgeFactory.create(data: data)
    } catch {
      fatalError("Unable to open: '\(romUrl)'")
    }
  }
}
