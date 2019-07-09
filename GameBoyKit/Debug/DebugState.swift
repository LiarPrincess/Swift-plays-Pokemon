// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

internal struct DebugCpuState {
  internal var a: UInt8 = 0
  internal var b: UInt8 = 0
  internal var c: UInt8 = 0
  internal var d: UInt8 = 0
  internal var e: UInt8 = 0
  internal var h: UInt8 = 0
  internal var l: UInt8 = 0

  internal var zeroFlag:      Bool = false
  internal var subtractFlag:  Bool = false
  internal var halfCarryFlag: Bool = false
  internal var carryFlag:     Bool = false

  internal var pc: UInt16 = 0
  internal var sp: UInt16 = 0
}

internal struct DebugIOState {
  internal var joypad: UInt8 = 0
  internal var sb:     UInt8 = 0
  internal var sc:     UInt8 = 0
  internal var unmapBootrom:  UInt8 = 0
}

internal struct DebugTimerState {
  internal var div:  UInt8 = 0
  internal var tima: UInt8 = 0
  internal var tma:  UInt8 = 0
  internal var tac:  UInt8 = 0
}

internal struct DebugAudioState {
  internal var nr10:          UInt8 = 0
  internal var nr11:          UInt8 = 0
  internal var nr12:          UInt8 = 0
  internal var nr13:          UInt8 = 0
  internal var nr14:          UInt8 = 0
  internal var nr21:          UInt8 = 0
  internal var nr22:          UInt8 = 0
  internal var nr23:          UInt8 = 0
  internal var nr24:          UInt8 = 0
  internal var nr30:          UInt8 = 0
  internal var nr31:          UInt8 = 0
  internal var nr32:          UInt8 = 0
  internal var nr33:          UInt8 = 0
  internal var nr34:          UInt8 = 0
  internal var nr41:          UInt8 = 0
  internal var nr42:          UInt8 = 0
  internal var nr43:          UInt8 = 0
  internal var nr44:          UInt8 = 0
  internal var nr50:          UInt8 = 0
  internal var nr51:          UInt8 = 0
  internal var nr52:          UInt8 = 0
  internal var nr3_ram_start: UInt8 = 0
  internal var nr3_ram_end:   UInt8 = 0
}

internal struct DebugLcdState {
  internal var control:     UInt8 = 0
  internal var status:      UInt8 = 0
  internal var scrollY:     UInt8 = 0
  internal var scrollX:     UInt8 = 0
  internal var line:        UInt8 = 0
  internal var lineCompare: UInt8 = 0
  internal var dma:         UInt8 = 0
  internal var backgroundPalette: UInt8 = 0
  internal var spritePalette0:    UInt8 = 0
  internal var spritePalette1:    UInt8 = 0
  internal var windowY: UInt8 = 0
  internal var windowX: UInt8 = 0
}

internal struct DebugInterruptState {
  internal var enable: UInt8 = 0
  internal var flag:   UInt8 = 0
}

/// Everything that we care during debugging (basically cpu + io).
internal struct DebugState {
  internal var cpu = DebugCpuState()

  internal var io    = DebugIOState()
  internal var timer = DebugTimerState()
  internal var audio = DebugAudioState()
  internal var lcd   = DebugLcdState()

  internal var interrupts = DebugInterruptState()
}
