// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

var romsDir: URL = {
  let currentFile = URL(fileURLWithPath: #file)
  let mainDir = currentFile.deletingLastPathComponent().deletingLastPathComponent()
  return mainDir.appendingPathComponent("ROMs")
}()

var cpuInstrs01special: URL = {
  let cpuInstrsDir = romsDir.appendingPathComponent("cpu_instrs")
  let individualDir = cpuInstrsDir.appendingPathComponent("individual")
  return individualDir.appendingPathComponent("01-special.gb")
}()
