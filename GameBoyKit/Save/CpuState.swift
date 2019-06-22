// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

internal struct CpuState {
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

  internal var pc:    UInt16 = 0
  internal var sp:    UInt16 = 0
  internal var cycle: UInt64 = 0

  internal var ime:      Bool = false
  internal var isHalted: Bool = false
}
