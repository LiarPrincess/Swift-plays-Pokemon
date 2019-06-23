// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// TODO: Rename tests. BusBootromTests, CpuXTests

import XCTest
@testable import GameBoyKit

class UnmapBootromTests: XCTestCase {

  private static let startValue: UInt8 = 5
  private static let endValue:   UInt8 = 6

  // write to X should disable bootrom (next read:)
  func test_unmapBootrom() {
    let range = MemoryMap.rom0

    let dataSize = MemoryMap.rom0.count + MemoryMap.rom1.count
    var data = Data(count: dataSize)
    data[range.start] = UnmapBootromTests.startValue
    data[range.end]   = UnmapBootromTests.endValue

    let cartridge = Cartridge(data: data)
    let bus = self.createBus(cartridge: cartridge)

    bus.write(MemoryMap.unmapBootrom, value: 1) // <-- this

    XCTAssertEqual(bus.read(range.start), UnmapBootromTests.startValue)
    XCTAssertEqual(bus.read(range.end), UnmapBootromTests.endValue)
  }
}
