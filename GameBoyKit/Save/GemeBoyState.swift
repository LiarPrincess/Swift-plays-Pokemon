// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// TODO: Save also memory

/// Implementation independent representation of GameBoy state
internal struct GameBoyState {
  internal var cpu = CpuState()
//  public var lcd: Lcd
//  public var bus: Bus
//  public var timer: Timer
//  public var joypad: Joypad
//  public var cartridge: Cartridge
}
