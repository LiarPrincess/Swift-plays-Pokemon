// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

enum BlarggRoms {

  private static var romsDir: URL = {
    let currentFile = URL(fileURLWithPath: #file)
    let mainDir = currentFile.deletingLastPathComponent().deletingLastPathComponent()
    return mainDir.appendingPathComponent("ROMs")
  }()

  /// 01-special.gb
  static var cpuInstrs01: URL {
    let cpuInstrsDir = romsDir.appendingPathComponent("cpu_instrs")
    let individualDir = cpuInstrsDir.appendingPathComponent("individual")
    return individualDir.appendingPathComponent("01-special.gb")
  }

  /// 03-op sp,hl.gb
  static var cpuInstrs03: URL {
    let cpuInstrsDir = romsDir.appendingPathComponent("cpu_instrs")
    let individualDir = cpuInstrsDir.appendingPathComponent("individual")
    return individualDir.appendingPathComponent("03-op sp,hl.gb")
  }

  /// 04-op r,imm.gb
  static var cpuInstrs04: URL {
    let cpuInstrsDir = romsDir.appendingPathComponent("cpu_instrs")
    let individualDir = cpuInstrsDir.appendingPathComponent("individual")
    return individualDir.appendingPathComponent("04-op r,imm.gb")
  }

  /// 02-interrupts.gb
  /// 05-op rp.gb
  /// 06-ld r,r.gb
  /// 07-jr,jp,call,ret,rst.gb
  /// 08-misc instrs.gb
  /// 09-op r,r.gb
  /// 10-bit ops.gb
  /// 11-op a,(hl).gb
}
