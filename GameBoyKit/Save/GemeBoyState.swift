// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

/// Implementation independent representation of GameBoy state
internal struct GameBoyState {
  internal var cpu = CpuState()
  internal var lcd = LcdState()
  internal var bus = BusState()
//  public var timer: Timer
//  public var joypad: Joypad
//  internal let serialPort: SerialPort
  internal var cartridge = CartridgeState()
//  interrupts
}
