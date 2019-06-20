// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

@testable import GameBoyKit

class FakeCpuBus: CpuBus {

  private var data = [UInt16: UInt8]()

  func hasInterrupt(_ interrupt: Interrupt) -> Bool {
    return false
  }

  func clearInterrupt(_ interrupt: Interrupt) { }

  func read(_ address: UInt16) -> UInt8 {
    return self.data[address] ?? 0
  }

  func write(_ address: UInt16, value: UInt8) {
    self.data[address] = value
  }
}
