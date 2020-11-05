// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import GameBoyKit

class DummyInput: GameboyInputProvider {

  func getGameboyInput() -> GameboyInput {
    return GameboyInput()
  }
}

extension XCTestCase {

  internal func createMemory(bootrom:    BootromMemory?   = nil,
                             cartridge:  CartridgeMemory? = nil,
                             joypad:     WritableJoypad?  = nil,
                             lcd:        WritableLcd?     = nil,
                             timer:      TimerMemory?     = nil,
                             interrupts: Interrupts?      = nil) -> Memory {
    return Memory(
      bootrom:    bootrom    ?? FakeBootromMemory(),
      cartridge:  cartridge  ?? FakeCartridgeMemory(),
      joypad:     joypad     ?? FakeJoypad(),
      lcd:        lcd        ?? FakeLcd(),
      timer:      timer      ?? FakeTimerMemory(),
      interrupts: interrupts ?? Interrupts()
    )
  }
}
