// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import GameBoyKit

extension XCTestCase {

  internal func createBus(bootrom:   Bootrom?   = nil,
                          cartridge: Cartridge? = nil) -> Bus {

    let cartridgeCount = MemoryMap.rom0.count + MemoryMap.rom1.count
    let cartridgeData  = Data(count: cartridgeCount)

    return Bus(
      bootrom:   bootrom ?? .skip,
      cartridge: cartridge ?? Cartridge(data: cartridgeData),
      joypad:    Joypad(),
      lcd:       Lcd(),
      timer:     Timer()
    )
  }
}
