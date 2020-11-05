// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import GameBoyKit

extension Interrupts {

  var isVBlankSet: Bool { return self.isSet(.vBlank) }
  var isLcdStatSet: Bool { return self.isSet(.lcdStat) }
  var isTimerSet: Bool { return self.isSet(.timer) }
  var isSerialSet: Bool { return self.isSet(.serial) }
  var isJoypadSet: Bool { return self.isSet(.joypad) }

  var isVBlankEnabled: Bool { return self.isEnabled(.vBlank) }
  var isLcdStatEnabled: Bool { return self.isEnabled(.lcdStat) }
  var isTimerEnabled: Bool { return self.isEnabled(.timer) }
  var isSerialEnabled: Bool { return self.isEnabled(.serial) }
  var isJoypadEnabled: Bool { return self.isEnabled(.joypad) }
}
