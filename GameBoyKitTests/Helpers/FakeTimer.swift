// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

@testable import GameBoyKit

class FakeTimer: Timer {
  var div:  UInt8 = 0
  var tima: UInt8 = 0
  var tma:  UInt8 = 0
  var tac:  UInt8 = 0

  func tick(cycles: Int) { }
}
