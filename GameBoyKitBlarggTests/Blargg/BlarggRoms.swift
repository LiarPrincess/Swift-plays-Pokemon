// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

private var romsDir: URL = {
  let currentFile = URL(fileURLWithPath: #file)
  let mainDir = currentFile.deletingLastPathComponent().deletingLastPathComponent()
  return mainDir.appendingPathComponent("ROMs")
}()


internal var instructionRoms: [URL] = {
  var result: [URL] = []

  let cpuInstrsDir = romsDir.appendingPathComponent("cpu_instrs")

  /*
  //  GameBoyKitBlarggTests/ROMs/cpu_instrs/cpu_instrs.gb
  result.append(cpuInstrsDir.appendingPathComponent("cpu_instrs.gb"))

  //  GameBoyKitBlarggTests/ROMs/cpu_instrs/individual/x.gb
  let individual = [
    "01-special.gb",
    "02-interrupts.gb",
    "03-op sp,hl.gb",
    "04-op r,imm.gb",
    "05-op rp.gb",
    "06-ld r,r.gb",
    "07-jr,jp,call,ret,rst.gb",
    "08-misc instrs.gb",
    "09-op r,r.gb",
    "10-bit ops.gb",
    "11-op a,(hl).gb"
  ]

  let individualDir = cpuInstrsDir.appendingPathComponent("individual")
  for rom in individual {
    result.append(individualDir.appendingPathComponent(rom))
  }
   */
  let individualDir = cpuInstrsDir.appendingPathComponent("individual")
  result.append(individualDir.appendingPathComponent("06-ld r,r.gb"))

  return result
}()
