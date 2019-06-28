// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import GameBoyKit

func pyBoyBlarggCpuInstrs01() {
  let rom = BlarggRoms.cpuInstrs01
  let pyFiles = PyFiles.cpuInstrs01
  pyBoyBlargg(rom: rom, pyFiles: pyFiles)
}

// TODO: not working
func pyBoyBlarggCpuInstrs03() {
  let rom = BlarggRoms.cpuInstrs03
  let pyFiles = PyFiles.cpuInstrs03
  pyBoyBlarggWorking3(rom: rom, pyFiles: pyFiles)
}

func pyBoyBlarggCpuInstrs04() {
  let rom = BlarggRoms.cpuInstrs04
  let pyFiles = PyFiles.cpuInstrs04
  pyBoyBlargg(rom: rom, pyFiles: pyFiles)
}

func pyBoyBlarggCpuInstrs05() {
  let rom = BlarggRoms.cpuInstrs05
  let pyFiles = PyFiles.cpuInstrs05
  pyBoyBlargg(rom: rom, pyFiles: pyFiles)
}

// TODO: not working
func pyBoyBlarggCpuInstrs06() {
  let rom = BlarggRoms.cpuInstrs06
  let pyFiles = PyFiles.cpuInstrs06
  pyBoyBlarggWorking6(rom: rom, pyFiles: pyFiles)
}

// TODO: not working
func pyBoyBlarggCpuInstrs07() {
  let rom = BlarggRoms.cpuInstrs07
  let pyFiles = PyFiles.cpuInstrs07
  pyBoyBlargg(rom: rom, pyFiles: pyFiles)
}

private func pyBoyBlargg(rom: URL, pyFiles: [URL]) {
  let cartridge = Helpers.openRom(url: rom)
  let gameBoy   = GameBoy(bootrom: .skip, cartridge: cartridge)
  let debugger  = Debugger(gameBoy: gameBoy)

  for (index, pyUrl) in pyFiles.enumerated() {
    let fileName = pyUrl.lastPathComponent
    print("\(index)/\(pyFiles.count - 1) - \(fileName)")

    let pyBoy = pyLoad(pyUrl)

    debugger.run(mode: .none, untilPC: pyBoy.cpu.pc)
    let hasError = pyTest(py: pyBoy, swift: gameBoy)

    if hasError {
      fatalError()
    }
  }

  print("---")
  print(String(bytes: gameBoy.linkCable, encoding: .ascii) ?? "")
  print("---")
}

// ----------------------------------

//272/666 - pyboy_cpu_instr_06_pc_0xc8d5.txt
//273/666 - pyboy_cpu_instr_06_pc_0xc8d8.txt
private func pyBoyBlarggWorking6(rom: URL, pyFiles: [URL]) {
  let cartridge = Helpers.openRom(url: rom)
  let gameBoy   = GameBoy(bootrom: .skip, cartridge: cartridge)
  let debugger  = Debugger(gameBoy: gameBoy)

  for (index, pyUrl) in pyFiles[0..<273].enumerated() {
    let fileName = pyUrl.lastPathComponent
    print("\(index)/\(pyFiles.count - 1) - \(fileName)")

    let pyBoy = pyLoad(pyUrl)

    let debugMode: DebugMode = index >= 660 ? .none : .none // opcodes
    debugger.run(mode: debugMode, untilPC: pyBoy.cpu.pc)
    let hasError = pyTest(py: pyBoy, swift: gameBoy)

//    if hasError {
//      fatalError()
//    }
  }

  let pyFiles2 = debugFileURLs6
  for (index, pyUrl) in pyFiles2.enumerated() {
    let fileName = pyUrl.lastPathComponent
    print("\(index)/\(pyFiles2.count) - \(fileName)")

    let pyBoy = pyLoad(pyUrl)

    let debugMode: DebugMode = index >= 7 ? .full : .none

    debugger.run(mode: debugMode, untilPC: pyBoy.cpu.pc)
    let hasError = pyTest(py: pyBoy, swift: gameBoy)

    if hasError {
      fatalError()
    }
  }
}

var debugFileURLs6: [URL] = {
  let currentFile = URL(fileURLWithPath: #file)
  let mainDir     = currentFile.deletingLastPathComponent()
  let debugDir    = mainDir.appendingPathComponent("PyBlarggFiles_cpu_instr_06_debug")

  let programCounters = 1...4029
  return programCounters.map { pc in
    return debugDir.appendingPathComponent("pyboy_cpu_instrs_06_pc_0xc8d5_\(pc).txt")
  }
}()


// ----------------------------------

private func pyBoyBlarggWorking3(rom: URL, pyFiles: [URL]) {
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
