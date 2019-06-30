// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import GameBoyKit

func runTestCpuInstrs01() {
  let rom = BlarggRoms.cpuInstrs01
  let url = BlarggRomDumps.cpuInstrs01
  runTest(rom: rom, dumpFiles: [url])
}

private func runTest(rom: URL, dumpFiles urls: [URL]) {
  let cartridge = openRom(url: rom)
  let gameBoy   = GameBoy(bootrom: .skip, cartridge: cartridge)
  let debugger  = Debugger(gameBoy: gameBoy)

  for (index, url) in urls.enumerated() {
    let fileName = url.lastPathComponent
    print("\(index)/\(urls.count - 1) - \(fileName)")

    let state = loadState(url)

    debugger.run(mode: .none, untilPC: state.cpu.pc)
    let hasError = compare(saved: state, gameboy: gameBoy)

    //    if hasError {
    //      fatalError()
    //    }
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





/*
// TODO: not working
func runTestCpuInstrs03() {
  let rom = BlarggRoms.cpuInstrs03
  let pyFiles = PyFiles.cpuInstrs03
  runTestWorking3(rom: rom, pyFiles: pyFiles)
}

func runTestCpuInstrs04() {
  let rom = BlarggRoms.cpuInstrs04
  let pyFiles = PyFiles.cpuInstrs04
  runTest(rom: rom, pyFiles: pyFiles)
}

func runTestCpuInstrs05() {
  let rom = BlarggRoms.cpuInstrs05
  let pyFiles = PyFiles.cpuInstrs05
  runTest(rom: rom, pyFiles: pyFiles)
}

func runTestCpuInstrs06() {
  let rom = BlarggRoms.cpuInstrs06
  let pyFiles = PyFiles.cpuInstrs06
  runTest(rom: rom, pyFiles: pyFiles)
}

// TODO: not working
func runTestCpuInstrs07() {
  let rom = BlarggRoms.cpuInstrs07
  let pyFiles = PyFiles.cpuInstrs07
  runTest(rom: rom, pyFiles: pyFiles)
}

// ----------------------------------

private func runTestWorking3(rom: URL, pyFiles: [URL]) {
  let cartridge = Helpers.openRom(url: rom)
  let gameBoy   = GameBoy(bootrom: .skip, cartridge: cartridge)
  let debugger  = Debugger(gameBoy: gameBoy)

  for (index, pyUrl) in pyFiles[0..<660].enumerated() {
    let fileName = pyUrl.lastPathComponent
    print("\(index)/\(pyFiles.count - 1) - \(fileName)")

    let pyBoy = pyLoad(pyUrl)

    let debugMode: DebugMode = index >= 660 ? .none : .none // opcodes
    debugger.run(mode: debugMode, untilPC: pyBoy.cpu.pc)
    let hasError = pyTest(py: pyBoy, swift: gameBoy)

    if fileName == "pyboy_cpu_instr_03_pc_0xc507" {
      break
    }

    if hasError {
      fatalError()
    }
  }

  let pyFiles2 = debugFileURLs3 // PyFiles.cpuInstrs03Debug
  for (index, pyUrl) in pyFiles2.enumerated() {
    let fileName = pyUrl.lastPathComponent
    print("\(index)/\(pyFiles2.count) - \(fileName)")

    let pyBoy = pyLoad(pyUrl)

    let debugMode: DebugMode = index >= 170 ? .none : .none
    debugger.run(mode: debugMode, untilPC: pyBoy.cpu.pc)
    let hasError = pyTest(py: pyBoy, swift: gameBoy)

    if fileName == "pyboy_cpu_instr_03_pc_0xc507" {
      break
    }

    if hasError {
      fatalError()
    }
  }
}

var debugFileURLs3: [URL] = {
  let currentFile = URL(fileURLWithPath: #file)
  let mainDir     = currentFile.deletingLastPathComponent()
  let debugDir    = mainDir.appendingPathComponent("PyBlarggFiles_cpu_instr_03_debug")

  let programCounters = 1...1853
  return programCounters.map { pc in
    return debugDir.appendingPathComponent("pyboy_cpu_instrs_03_pc_0xc505_\(pc).txt")
  }
}()

// ----------------------------------
*/
