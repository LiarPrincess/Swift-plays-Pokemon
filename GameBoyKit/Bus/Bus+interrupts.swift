// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

extension Bus {

  internal func hasInterrupt(_ interrupt: Interrupt) -> Bool {
    switch interrupt {
    case .vBlank:  return self.interruptEnable.vBlank  && false
    case .lcdStat: return self.interruptEnable.lcdStat && false
    case .timer:   return self.interruptEnable.timer   && self.timer.hasInterrupt
    case .serial:  return self.interruptEnable.serial  && false
    case .joypad:  return self.interruptEnable.joypad  && false
    }
  }

  internal func clearInterrupt(_ interrupt: Interrupt) {
    switch interrupt {
    case .vBlank: break
    case .lcdStat: break
    case .timer: self.timer.hasInterrupt = false
    case .serial: break
    case .joypad: break
    }
  }
}
