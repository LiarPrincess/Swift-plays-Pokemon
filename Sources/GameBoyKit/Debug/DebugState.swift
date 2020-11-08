// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

/// Everything that we care during debugging (basically cpu + io).
internal struct DebugState {

  // MARK: - Cpu

  internal struct Cpu {
    internal let a: UInt8
    internal let b: UInt8
    internal let c: UInt8
    internal let d: UInt8
    internal let e: UInt8
    internal let h: UInt8
    internal let l: UInt8

    internal let zeroFlag:      Bool
    internal let subtractFlag:  Bool
    internal let halfCarryFlag: Bool
    internal let carryFlag:     Bool

    internal let pc: UInt16
    internal let sp: UInt16
  }

  internal let cpu: Cpu

  // MARK: - IO

  // swiftlint:disable:next type_name
  internal struct IO {
    internal let joypad: UInt8
    internal let sb:     UInt8
    internal let sc:     UInt8
    internal let unmapBootrom:  UInt8
  }

  internal let io: IO

  // MARK: - Timer

  internal struct Timer {
    internal let div:  UInt8
    internal let tima: UInt8
    internal let tma:  UInt8
    internal let tac:  UInt8
  }

  internal let timer: Timer

  // MARK: - Audio

  internal struct Audio {
    internal let nr10:          UInt8
    internal let nr11:          UInt8
    internal let nr12:          UInt8
    internal let nr13:          UInt8
    internal let nr14:          UInt8
    internal let nr21:          UInt8
    internal let nr22:          UInt8
    internal let nr23:          UInt8
    internal let nr24:          UInt8
    internal let nr30:          UInt8
    internal let nr31:          UInt8
    internal let nr32:          UInt8
    internal let nr33:          UInt8
    internal let nr34:          UInt8
    internal let nr41:          UInt8
    internal let nr42:          UInt8
    internal let nr43:          UInt8
    internal let nr44:          UInt8
    internal let nr50:          UInt8
    internal let nr51:          UInt8
    internal let nr52:          UInt8
    internal let nr3_ram_start: UInt8
    internal let nr3_ram_end:   UInt8
  }

  internal let audio: Audio

  // MARK: - Lcd

  internal struct Lcd {
    internal let control:     UInt8
    internal let status:      UInt8
    internal let scrollY:     UInt8
    internal let scrollX:     UInt8
    internal let line:        UInt8
    internal let lineCompare: UInt8
    internal let dma:         UInt8
    internal let backgroundPalette: UInt8
    internal let spritePalette0:    UInt8
    internal let spritePalette1:    UInt8
    internal let windowY: UInt8
    internal let windowX: UInt8
  }

  internal let lcd: Lcd

  // MARK: - Interrupts

  internal struct Interrupts {
    internal let enable: UInt8
    internal let flag:   UInt8
  }

  internal let interrupts: Interrupts
}
