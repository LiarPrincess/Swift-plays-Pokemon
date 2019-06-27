// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import GameBoyKit

// swiftlint:disable collection_alignment

func pyBoyBlarggCpuInstrs01() {
  let rom = BlarggRoms.cpuInstrs01
  let pyFiles = PyFiles.cpuInstrs01
  pyBoyBlargg(rom: rom, pyFiles: pyFiles)
}

func pyBoyBlarggCpuInstrs03() {
  let rom = BlarggRoms.cpuInstrs03
  let pyFiles = PyFiles.cpuInstrs03
  pyBoyBlargg(rom: rom, pyFiles: pyFiles)
}

private func pyBoyBlargg(rom: URL, pyFiles: [URL]) {
  let cartridge = Helpers.openRom(url: rom)
  let gameBoy   = GameBoy(bootrom: .skip, cartridge: cartridge)
  let debugger  = Debugger(gameBoy: gameBoy)

  for (index, pyUrl) in pyFiles.enumerated() {
    let fileName = pyUrl.lastPathComponent
    print("\(index)/\(pyFiles.count) - \(fileName)")

    let pyBoy = pyLoad(pyUrl)

    let debugMode: DebugMode = index >= 660 ? .none : .none // opcodes
    debugger.run(mode: debugMode, lastPC: pyBoy.cpu.pc)
    let hasError = pyTest(pyBoy: pyBoy, swiftBoy: gameBoy)

    if hasError {
      fatalError()
    }
  }
}
