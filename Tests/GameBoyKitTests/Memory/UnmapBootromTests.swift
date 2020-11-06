// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import GameBoyKit

/// Value that will be written at the 1st address in given range
private let startValue: UInt8 = 5
/// Value that will be written at the last address in given range
private let endValue: UInt8 = 6

class UnmapBootromTests: MemoryTestCase {

  // Write to 'MemoryMap.IO.unmapBootrom' should disable bootrom
  func test_unmapBootrom() {
    let range = MemoryMap.rom0

    let cartridge = FakeCartridgeMemory()
    cartridge.rom[range.start] = startValue
    cartridge.rom[range.end]   = endValue

    let memory = self.createMemory(cartridge: cartridge)
    memory.write(MemoryMap.IO.unmapBootrom, value: 1) // <-- this

    // Now it should read from 'cartridge.rom' instead of 'bootrom'
    XCTAssertEqual(memory.read(range.start), startValue)
    XCTAssertEqual(memory.read(range.end), endValue)
  }
}
