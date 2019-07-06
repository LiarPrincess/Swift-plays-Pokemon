// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import GameBoyKit

private typealias Roms = BlarggRoms
private typealias Dumps = BlarggRomDumps

func testCpuInstrs01() { test(Roms.cpuInstrs01, dump: Dumps.cpuInstrs01) }
func testCpuInstrs02() { test(Roms.cpuInstrs02, dump: Dumps.cpuInstrs02) }
func testCpuInstrs03() { test(Roms.cpuInstrs03, dump: Dumps.cpuInstrs03) }
func testCpuInstrs04() { test(Roms.cpuInstrs04, dump: Dumps.cpuInstrs04) }
func testCpuInstrs05() { test(Roms.cpuInstrs05, dump: Dumps.cpuInstrs05) }
func testCpuInstrs06() { test(Roms.cpuInstrs06, dump: Dumps.cpuInstrs06) }
func testCpuInstrs07() { test(Roms.cpuInstrs07, dump: Dumps.cpuInstrs07) }
func testCpuInstrs08() { test(Roms.cpuInstrs08, dump: Dumps.cpuInstrs08) }
func testCpuInstrs09() { test(Roms.cpuInstrs09, dump: Dumps.cpuInstrs09) }
func testCpuInstrs10() { test(Roms.cpuInstrs10, dump: Dumps.cpuInstrs10) }
func testCpuInstrs11() { test(Roms.cpuInstrs11, dump: Dumps.cpuInstrs11) }

func testInstrTiming() { test(Roms.instrTiming, dump: Dumps.instrTiming) }

private func test(_ rom: URL, dump urls: [URL]) {
  print(rom.lastPathComponent)

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

  print("---")
  print(String(bytes: gameBoy.linkCable, encoding: .ascii) ?? "")
  print("---")
}

private func openRom(url: URL) -> Cartridge {
  do {
    let data = try Data(contentsOf: url)
    return try CartridgeFactory.fromData(data, isTest: true)
  } catch let error as CartridgeFactoryError {
    print("Error when opening ROM: \(error.description)")
    exit(1)
  } catch {
    print("Error when opening ROM: \(error.localizedDescription)")
    exit(1)
  }
}
