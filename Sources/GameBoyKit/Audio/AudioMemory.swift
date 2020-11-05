// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

internal protocol AudioMemory: AnyObject {
  var nr10: UInt8 { get set }
  var nr11: UInt8 { get set }
  var nr12: UInt8 { get set }
  var nr13: UInt8 { get set }
  var nr14: UInt8 { get set }
  var nr21: UInt8 { get set }
  var nr22: UInt8 { get set }
  var nr23: UInt8 { get set }
  var nr24: UInt8 { get set }
  var nr30: UInt8 { get set }
  var nr31: UInt8 { get set }
  var nr32: UInt8 { get set }
  var nr33: UInt8 { get set }
  var nr34: UInt8 { get set }
  var nr41: UInt8 { get set }
  var nr42: UInt8 { get set }
  var nr43: UInt8 { get set }
  var nr44: UInt8 { get set }
  var nr50: UInt8 { get set }
  var nr51: UInt8 { get set }
  var nr52: UInt8 { get set }
  var nr3_ram_start: UInt8 { get set }
  var nr3_ram_end: UInt8 { get set }
}
