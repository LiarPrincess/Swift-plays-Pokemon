// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import GameBoyKit

class CpuTestCase: XCTestCase {

  func createFakeMemory() -> FakeCpuMemory {
    return FakeCpuMemory()
  }

  func createCpu(memory: CpuMemory? = nil, interrupts: Interrupts? = nil) -> Cpu {
    return Cpu(
      memory: memory ?? FakeCpuMemory(),
      interrupts: interrupts ?? Interrupts()
    )
  }
}
