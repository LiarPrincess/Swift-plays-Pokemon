// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

enum BlarggRomDumps {

  private static var dumpsDir: URL = {
    let currentFile = URL(fileURLWithPath: #file)
    let mainDir = currentFile.deletingLastPathComponent()
    return mainDir.appendingPathComponent("Dumps")
  }()

  static var cpuInstrs01: [URL] {
    return listStates(dir: dumpsDir.appendingPathComponent("cpu_instr_01"))
  }

  static var cpuInstrs02: [URL] {
    return listStates(dir: dumpsDir.appendingPathComponent("cpu_instr_02"))
  }

  static var cpuInstrs03: [URL] {
    return listStates(dir: dumpsDir.appendingPathComponent("cpu_instr_03"))
  }

  static var cpuInstrs04: [URL] {
    return listStates(dir: dumpsDir.appendingPathComponent("cpu_instr_04"))
  }

  static var cpuInstrs05: [URL] {
    return listStates(dir: dumpsDir.appendingPathComponent("cpu_instr_05"))
  }

  static var cpuInstrs06: [URL] {
    return listStates(dir: dumpsDir.appendingPathComponent("cpu_instr_06"))
  }

  static var cpuInstrs07: [URL] {
    return listStates(dir: dumpsDir.appendingPathComponent("cpu_instr_07"))
  }

  static var cpuInstrs08: [URL] {
    return listStates(dir: dumpsDir.appendingPathComponent("cpu_instr_08"))
  }

  static var cpuInstrs09: [URL] {
    return listStates(dir: dumpsDir.appendingPathComponent("cpu_instr_09"))
  }

  static var cpuInstrs10: [URL] {
    return listStates(dir: dumpsDir.appendingPathComponent("cpu_instr_10"))
  }

  static var cpuInstrs11: [URL] {
    return listStates(dir: dumpsDir.appendingPathComponent("cpu_instr_11"))
  }
}
