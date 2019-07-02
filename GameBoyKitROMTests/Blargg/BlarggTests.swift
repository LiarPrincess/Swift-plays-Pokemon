// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import GameBoyKit

func runTestCpuInstrs01() {
  let rom = BlarggRoms.cpuInstrs01
  let dump = BlarggRomDumps.cpuInstrs01
  runTest(rom: rom, dump: dump)
}

func runTestCpuInstrs02() {
  let rom = BlarggRoms.cpuInstrs02
  let dump = BlarggRomDumps.cpuInstrs02
  runTest(rom: rom, dump: dump)
}

func runTestCpuInstrs03() {
  let rom = BlarggRoms.cpuInstrs03
  let dump = BlarggRomDumps.cpuInstrs03
  runTest(rom: rom, dump: dump)
}

func runTestCpuInstrs04() {
  let rom = BlarggRoms.cpuInstrs04
  let dump = BlarggRomDumps.cpuInstrs04
  runTest(rom: rom, dump: dump)
}

func runTestCpuInstrs05() {
  let rom = BlarggRoms.cpuInstrs05
  let dump = BlarggRomDumps.cpuInstrs05
  runTest(rom: rom, dump: dump)
}

func runTestCpuInstrs06() {
  let rom = BlarggRoms.cpuInstrs06
  let dump = BlarggRomDumps.cpuInstrs06
  runTest(rom: rom, dump: dump)
}

func runTestCpuInstrs07() {
  let rom = BlarggRoms.cpuInstrs07
  let dump = BlarggRomDumps.cpuInstrs07
  runTest(rom: rom, dump: dump)
}

func runTestCpuInstrs08() {
  let rom = BlarggRoms.cpuInstrs08
  let dump = BlarggRomDumps.cpuInstrs08
  runTest(rom: rom, dump: dump)
}

func runTestCpuInstrs09() {
  let rom = BlarggRoms.cpuInstrs09
  let dump = BlarggRomDumps.cpuInstrs09
  runTest(rom: rom, dump: dump)
}

func runTestCpuInstrs10() {
  let rom = BlarggRoms.cpuInstrs10
  let dump = BlarggRomDumps.cpuInstrs10
  runTest(rom: rom, dump: dump)
}

func runTestCpuInstrs11() {
  let rom = BlarggRoms.cpuInstrs11
  let dump = BlarggRomDumps.cpuInstrs11
  runTest(rom: rom, dump: dump)

}

private func runTest(rom: URL, dump urls: [URL]) {
  let cartridge = openRom(url: rom)
  let gameBoy   = GameBoy(bootrom: nil, cartridge: cartridge)
  let debugger  = Debugger(gameBoy: gameBoy)

  for (index, url) in urls.enumerated() {
    let fileName = url.lastPathComponent
    print("\(index)/\(urls.count - 1) - \(fileName)")

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

  print("---")
  print(String(bytes: gameBoy.linkCable, encoding: .ascii) ?? "")
  print("---")
}

private func openRom(url: URL) -> Cartridge {
  do {
    let data = try Data(contentsOf: url)
    return try CartridgeFactory.fromData(data)
  } catch let error as CartridgeInitError {
    print("Error when opening ROM: \(error.description)")
    exit(1)
  } catch {
    print("Error when opening ROM: \(error.localizedDescription)")
    exit(1)
  }
}
