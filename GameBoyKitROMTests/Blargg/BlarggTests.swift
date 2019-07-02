// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import GameBoyKit

private typealias Roms = BlarggRoms
private typealias Dumps = BlarggRomDumps

func runTestCpuInstrs01() { runTest(rom: Roms.cpuInstrs01, dump: Dumps.cpuInstrs01) }
func runTestCpuInstrs02() { runTest(rom: Roms.cpuInstrs02, dump: Dumps.cpuInstrs02) }
func runTestCpuInstrs03() { runTest(rom: Roms.cpuInstrs03, dump: Dumps.cpuInstrs03) }
func runTestCpuInstrs04() { runTest(rom: Roms.cpuInstrs04, dump: Dumps.cpuInstrs04) }
func runTestCpuInstrs05() { runTest(rom: Roms.cpuInstrs05, dump: Dumps.cpuInstrs05) }
func runTestCpuInstrs06() { runTest(rom: Roms.cpuInstrs06, dump: Dumps.cpuInstrs06) }
func runTestCpuInstrs07() { runTest(rom: Roms.cpuInstrs07, dump: Dumps.cpuInstrs07) }
func runTestCpuInstrs08() { runTest(rom: Roms.cpuInstrs08, dump: Dumps.cpuInstrs08) }
func runTestCpuInstrs09() { runTest(rom: Roms.cpuInstrs09, dump: Dumps.cpuInstrs09) }
func runTestCpuInstrs10() { runTest(rom: Roms.cpuInstrs10, dump: Dumps.cpuInstrs10) }
func runTestCpuInstrs11() { runTest(rom: Roms.cpuInstrs11, dump: Dumps.cpuInstrs11) }

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
