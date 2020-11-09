// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

@testable import GameBoyKit

class FakeTimerMemory: TimerMemory {
  var div = UInt8()
  var tima = UInt8()
  var tma = UInt8()
  var tac = UInt8()
}
