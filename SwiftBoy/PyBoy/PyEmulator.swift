// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

class PyRegisters {
  var a: UInt8 = 0
  var c: UInt8 = 0
  var b: UInt8 = 0
  var e: UInt8 = 0
  var d: UInt8 = 0
  var l: UInt8 = 0
  var h: UInt8 = 0
  var zeroFlag:      Bool = false
  var subtractFlag:  Bool = false
  var halfCarryFlag: Bool = false
  var carryFlag:     Bool = false
}

class PyCpu {
  var pc:    UInt16 = 0
  var sp:    UInt16 = 0
  var cycle: UInt16 = 0
  var ime:      Bool = false
  var isHalted: Bool = false
  var registers = PyRegisters()
}

class PyMemory {
  var data = [UInt8](repeating: 0, count: 0x10000)
}

class PyEmulator {
  let filename: String
  let cpu    = PyCpu()
  let memory = PyMemory()

  init(filename: String) {
    self.filename = filename
  }
}
