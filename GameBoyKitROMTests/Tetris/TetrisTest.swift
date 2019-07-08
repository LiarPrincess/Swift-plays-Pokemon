// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import GameBoyKit

private let rom = URL(fileURLWithPath: #file)
                    .deletingLastPathComponent()
                    .appendingPathComponent("Tetris.gb")

private let urls: [URL] = {
  let dumpsDir = URL(fileURLWithPath: #file)
                  .deletingLastPathComponent()
                  .appendingPathComponent("Dump")
  return listStates(dir: dumpsDir)
}()

func testTetris() {
  let cartridge = openRom(url: rom)
  let gameBoy   = GameBoy(bootrom: nil, cartridge: cartridge)
  let debugger  = Debugger(gameBoy: gameBoy)

  for (index, url) in urls.enumerated() {
    let fileName = url.lastPathComponent
    print("\(index)/\(urls.count - 1) - \(fileName) (cycle: \(gameBoy.cpu.cycle))")

    // https://swiftrocks.com/autoreleasepool-in-2019-swift.html
    autoreleasepool {
      let state = loadState(url)
      debugger.run(mode: .none, untilPC: state.cpu.pc)
      let hasError = compare(saved: state, gameboy: gameBoy)

//      if hasError {
//        fatalError()
//      }
    }
  }

  let map = gameBoy.lcd.control.backgroundTileMap
  let data = gameBoy.lcd.control.tileData
  print("------------------------------------------------")
  print(map)
  print(data)
  debugger.dumpTileIndices(map)
  debugger.dumpTileData(data)
  debugger.dumpBackground(map, data)
}

private func openRom(url: URL) -> Cartridge {
  do {
    let data = try Data(contentsOf: url)
    return try CartridgeFactory.fromData(data, isTest: true)
  } catch let error as CartridgeFactoryError {
    print("Error when opening ROM: \(error.description).")
    exit(1)
  } catch {
    let url = "http://gbdev.gg8.se/files/roms/blargg-gb-tests/"
    print("Error when opening ROM: \(error.localizedDescription). You can donwload roms from: '\(url)')")
    exit(1)
  }
}
