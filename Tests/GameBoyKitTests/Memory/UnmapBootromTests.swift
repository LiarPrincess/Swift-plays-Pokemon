// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import GameBoyKit

class UnmapBootromTests: XCTestCase {

  private static let startValue: UInt8 = 5
  private static let endValue:   UInt8 = 6

  // write to X should disable bootrom (next read:)
  func test_unmapBootrom() {
    let range = MemoryMap.rom0

    let cartridge = FakeCartridgeMemory()
    cartridge.rom[range.start] = UnmapBootromTests.startValue
    cartridge.rom[range.end]   = UnmapBootromTests.endValue

    let memory = self.createMemory(cartridge: cartridge)
    memory.write(MemoryMap.IO.unmapBootrom, value: 1) // <-- this

    // cartridge.rom instead of bootrom
    XCTAssertEqual(memory.read(range.start), UnmapBootromTests.startValue)
    XCTAssertEqual(memory.read(range.end), UnmapBootromTests.endValue)
  }
}
