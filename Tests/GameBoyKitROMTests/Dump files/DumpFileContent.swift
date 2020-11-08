// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

struct DumpFileContent {

  struct Cpu {
    var a = UInt8()
    var c = UInt8()
    var b = UInt8()
    var e = UInt8()
    var d = UInt8()
    var l = UInt8()
    var h = UInt8()

    var zeroFlag = false
    var subtractFlag = false
    var halfCarryFlag = false
    var carryFlag = false

    var pc = UInt16()
    var sp = UInt16()
    var cycle = UInt16()

    var ime = false
    var isHalted = false
    var isStopped = false
  }

  var cpu = Cpu()
  var memory = [UInt8](repeating: 0, count: 0x10000)
}
