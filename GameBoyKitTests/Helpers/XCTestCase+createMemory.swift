// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import GameBoyKit

extension XCTestCase {

  internal func createMemory(bootrom:    BootromMemory?   = nil,
                             cartridge:  CartridgeMemory? = nil,
                             interrupts: Interrupts?      = nil) -> Memory {

    let ints = interrupts ?? Interrupts()
    return Memory(
      bootrom:   bootrom   ?? FakeBootromMemory(),
      cartridge: cartridge ?? FakeCartridgeMemory(),
      joypad:    Joypad(),
      lcd:       Lcd(interrupts: ints),
      timer:     Timer(interrupts: ints),
      interrupts: ints
    )
  }
}
