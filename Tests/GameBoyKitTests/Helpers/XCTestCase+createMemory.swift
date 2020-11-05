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

  func createMemory(bootrom:    BootromMemory?   = nil,
                    cartridge:  CartridgeMemory? = nil,
                    joypad:     JoypadMemory?    = nil,
                    lcd:        WritableLcd?     = nil,
                    audio:      AudioMemory?     = nil,
                    timer:      TimerMemory?     = nil,
                    interrupts: Interrupts?      = nil) -> Memory {
    return Memory(
      bootrom:    .executing(bootrom ?? FakeBootromMemory()),
      cartridge:  cartridge  ?? FakeCartridgeMemory(),
      joypad:     joypad     ?? FakeJoypadMemory(),
      lcd:        lcd        ?? FakeLcd(),
      audio:      audio      ?? FakeAudioMemory(),
      timer:      timer      ?? FakeTimerMemory(),
      interrupts: interrupts ?? Interrupts()
    )
  }
}
