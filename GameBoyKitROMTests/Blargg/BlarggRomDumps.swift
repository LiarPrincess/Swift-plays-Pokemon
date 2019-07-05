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

  private static func list(_ dir: String) -> [URL] {
    return listStates(dir: dumpsDir.appendingPathComponent(dir))
  }

  // MARK: - Cpu instrs

  static var cpuInstrs01 = list("cpu_instr_01")
  static var cpuInstrs02 = list("cpu_instr_02")
  static var cpuInstrs03 = list("cpu_instr_03")
  static var cpuInstrs04 = list("cpu_instr_04")
  static var cpuInstrs05 = list("cpu_instr_05")
  static var cpuInstrs06 = list("cpu_instr_06")
  static var cpuInstrs07 = list("cpu_instr_07")
  static var cpuInstrs08 = list("cpu_instr_08")
  static var cpuInstrs09 = list("cpu_instr_09")
  static var cpuInstrs10 = list("cpu_instr_10")
  static var cpuInstrs11 = list("cpu_instr_11")

  // MARK: - Instr timing

  static var instrTiming = list("instr_timing")
}
