// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import GameBoyKit

private typealias Roms = BlarggRoms
private typealias Dumps = BlarggRomDumps

func testCpuInstrs01() { test(Roms.cpuInstrs01, frames:   145) }
func testCpuInstrs02() { test(Roms.cpuInstrs02, frames:    30) }
func testCpuInstrs03() { test(Roms.cpuInstrs03, frames:   145) }
func testCpuInstrs04() { test(Roms.cpuInstrs04, frames:   170) }
func testCpuInstrs05() { test(Roms.cpuInstrs05, frames:   230) }
func testCpuInstrs06() { test(Roms.cpuInstrs06, frames:    40) }
func testCpuInstrs07() { test(Roms.cpuInstrs07, frames:    45) }
func testCpuInstrs08() { test(Roms.cpuInstrs08, frames:    35) }
func testCpuInstrs09() { test(Roms.cpuInstrs09, frames:   550) }
func testCpuInstrs10() { test(Roms.cpuInstrs10, frames:   835) }
func testCpuInstrs11() { test(Roms.cpuInstrs11, frames: 1_055) }
func testInstrTiming() { test(Roms.instrTiming, frames:    45) }

func debugCpuInstrs01() { debug(Roms.cpuInstrs01, dump: Dumps.cpuInstrs01) }
func debugCpuInstrs02() { debug(Roms.cpuInstrs02, dump: Dumps.cpuInstrs02) }
func debugCpuInstrs03() { debug(Roms.cpuInstrs03, dump: Dumps.cpuInstrs03) }
func debugCpuInstrs04() { debug(Roms.cpuInstrs04, dump: Dumps.cpuInstrs04) }
func debugCpuInstrs05() { debug(Roms.cpuInstrs05, dump: Dumps.cpuInstrs05) }
func debugCpuInstrs06() { debug(Roms.cpuInstrs06, dump: Dumps.cpuInstrs06) }
func debugCpuInstrs07() { debug(Roms.cpuInstrs07, dump: Dumps.cpuInstrs07) }
func debugCpuInstrs08() { debug(Roms.cpuInstrs08, dump: Dumps.cpuInstrs08) }
func debugCpuInstrs09() { debug(Roms.cpuInstrs09, dump: Dumps.cpuInstrs09) }
func debugCpuInstrs10() { debug(Roms.cpuInstrs10, dump: Dumps.cpuInstrs10) }
func debugCpuInstrs11() { debug(Roms.cpuInstrs11, dump: Dumps.cpuInstrs11) }
func debugInstrTiming() { debug(Roms.instrTiming, dump: Dumps.instrTiming) }

private func test(_ rom: URL, frames: Int) {
  print(rom.lastPathComponent, terminator: "")
  let cartridge = openRom(url: rom)
  let gameBoy   = GameBoy(bootrom: nil, cartridge: cartridge)

  for _ in 0..<frames {
    gameBoy.tickFrame()
  }

  let link = String(bytes: gameBoy.linkCable, encoding: .ascii) ?? ""
  let passed = link.contains("Passed")

  if passed {
    print(" ✔")
  } else {
    print(" ✖ (serial: \(link.replacingOccurrences(of: "\n", with: " "))")
  }
}

private func debug(_ rom: URL, dump urls: [URL]) {
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

private var resultsDir = URL(fileURLWithPath: #file)
                          .deletingLastPathComponent()
                          .appendingPathComponent("Results")

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
