// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

internal class DivTimer {

  /// Frequency at which div register should be incremented.
  private static let frequency: UInt = 16_384

  internal private(set) var value: UInt8 = 0x00

  private var progress: UInt = 0

  internal func read() -> UInt8 {
    return self.value
  }

  internal func write() {
    self.value = 0
    self.progress = 0
  }

  internal func tick(cycles: UInt8) {
    let max = Cpu.clockSpeed / DivTimer.frequency // 256

    self.progress += UInt(cycles)

    if self.progress >= max {
      self.value &+= 1
      self.progress %= max
    }
  }
}
