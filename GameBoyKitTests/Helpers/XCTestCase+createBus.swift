// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import GameBoyKit

extension XCTestCase {

  internal func createBus(bootrom:    Bootrom?    = nil,
                          cartridge:  Cartridge?  = nil,
                          interrupts: Interrupts? = nil) -> Bus {

    let bootromCount = MemoryMap.bootrom.count
    let cartridgeCount = MemoryMap.rom0.count + MemoryMap.rom1.count

    let ints = interrupts ?? Interrupts()

    return Bus(
      bootrom:   bootrom   ?? Bootrom(data: Data(count: bootromCount)),
      cartridge: cartridge ?? Cartridge(data: Data(count: cartridgeCount)),
      joypad:    Joypad(),
      lcd:       Lcd(interrupts: ints),
      timer:     Timer(interrupts: ints),
      interrupts: ints
    )
  }
}
