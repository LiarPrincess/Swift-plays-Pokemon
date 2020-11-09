// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import GameBoyKit

// swiftformat:disable consecutiveSpaces

class MemoryTestCase: XCTestCase {

  func createMemory(bootrom:    BootromMemory?   = nil,
                    cartridge:  CartridgeMemory? = nil,
                    joypad:     JoypadMemory?    = nil,
                    lcd:        LcdMemory?       = nil,
                    audio:      AudioMemory?     = nil,
                    timer:      TimerMemory?     = nil,
                    interrupts: Interrupts?      = nil) -> Memory
  {
    return Memory(
      bootrom:    bootrom    ?? FakeBootromMemory(),
      cartridge:  cartridge  ?? FakeCartridgeMemory(),
      joypad:     joypad     ?? FakeJoypadMemory(),
      lcd:        lcd        ?? FakeLcdMemory(),
      audio:      audio      ?? FakeAudioMemory(),
      timer:      timer      ?? FakeTimerMemory(),
      interrupts: interrupts ?? Interrupts(),
      serialPort: SerialPort(),
      linkCable:  LinkCable()
    )
  }
}
