// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import GameBoyKit

private let frameCount: Int64 = 60
private let romUrl = romsDir.appendingPathComponent("Tetris.gb")

func performanceTest() {
  let bootrom = Bootrom.dmg
  let cartridge = openRom()
  let input = DummyInputProvider()
  let gameBoy = GameBoy(bootrom: bootrom, cartridge: cartridge, input: input)

  let start = DispatchTime.now()
  for _ in 0..<frameCount {
    gameBoy.tickFrame()
  }
  let end = DispatchTime.now()

  let timeNano = end.uptimeNanoseconds - start.uptimeNanoseconds
  let timeMs = Double(timeNano) / 1_000_000

  let perFrameMs = timeMs / Double(frameCount)

  print("""
Finished
  Total time: \(timeMs) ms
  Per frame:  \(perFrameMs) ms (\(1_000 / perFrameMs) fps)
  Budget:     \(1_000 / 60) ms

  Total cycles: \(gameBoy.cpu.cycle)
  Per cycle:    \(timeMs / Double(gameBoy.cpu.cycle)) ms

""")
}

private func openRom() -> Cartridge {
  do {
    let data = try Data(contentsOf: romUrl)
    return try CartridgeFactory.create(rom: data, ram: nil)
  } catch {
    fatalError("Unable to open: '\(romUrl)'")
  }
}
