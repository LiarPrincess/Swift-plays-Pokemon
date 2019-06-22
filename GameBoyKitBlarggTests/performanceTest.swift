// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import GameBoyKit

private let totalLines = Lcd.height + LcdTimings.vBlankLineCount
private let fullFrame  = Int64(totalLines) * Int64(LcdTimings.lineLength) // 70_224

private let frameCount: Int64 = 60

internal func performanceTest() {
  let gameBoy = GameBoy()
  let debugger = Debugger(mode: .none)
  debugger.attach(gameBoy)

  let start = DispatchTime.now()
  debugger.run(cycles: frameCount * fullFrame)
  let end = DispatchTime.now()

  let timeNano = end.uptimeNanoseconds - start.uptimeNanoseconds
  let timeMs = Double(timeNano) / 1_000_000

  print("""
Finished
  Total time: \(timeMs) ms
  Per frame:  \(timeMs / Double(frameCount)) ms
  Budget:     \(1_000 / 60) ms

  Total cycles: \(gameBoy.cpu.cycle)
  Per cycle:    \(timeMs / Double(gameBoy.cpu.cycle)) ms

""")
}
