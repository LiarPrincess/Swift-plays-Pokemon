// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

enum BlarggRoms {

  private static var romsDir: URL = {
    let currentFile = URL(fileURLWithPath: #file)
    let mainDir = currentFile.deletingLastPathComponent()
    return mainDir.appendingPathComponent("ROMs")
  }()

  // MARK: - Cpu instrs

  /// 01-special.gb
  static var cpuInstrs01 = individualCpuInstrs("01-special.gb")

  /// 02-interrupts.gb
  static var cpuInstrs02 = individualCpuInstrs("02-interrupts.gb")

  /// 03-op sp,hl.gb
  static var cpuInstrs03 = individualCpuInstrs("03-op sp,hl.gb")

  /// 04-op r,imm.gb
  static var cpuInstrs04 = individualCpuInstrs("04-op r,imm.gb")

  /// 05-op rp.gb
  static var cpuInstrs05 = individualCpuInstrs("05-op rp.gb")

  /// 06-ld r,r.gb
  static var cpuInstrs06 = individualCpuInstrs("06-ld r,r.gb")

  /// 07-jr,jp,call,ret,rst.gb
  static var cpuInstrs07 = individualCpuInstrs("07-jr,jp,call,ret,rst.gb")

  /// 08-misc instrs.gb
  static var cpuInstrs08 = individualCpuInstrs("08-misc instrs.gb")

  /// 09-op r,r.gb
  static var cpuInstrs09 = individualCpuInstrs("09-op r,r.gb")

  /// 10-bit ops.gb
  static var cpuInstrs10 = individualCpuInstrs("10-bit ops.gb")

  /// 11-op a,(hl).gb
  static var cpuInstrs11 = individualCpuInstrs("11-op a,(hl).gb")

  private static func individualCpuInstrs(_ gb: String) -> URL {
    return romsDir.appendingPathComponent("cpu_instrs")
                  .appendingPathComponent("individual")
                  .appendingPathComponent(gb)
  }

  // MARK: - Instr timing

  static var instrTiming: URL {
    return romsDir.appendingPathComponent("instr_timing")
                  .appendingPathComponent("instr_timing.gb")
  }
}
