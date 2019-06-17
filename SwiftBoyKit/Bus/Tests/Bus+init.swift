// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

@testable import SwiftBoyKit

extension Bus {
  convenience init() {
    let lcd = Lcd()
    let timer = Timer()
    let joypad = Joypad()
    let cartridge = Cartridge.bootrom
    self.init(cartridge: cartridge, joypad: joypad, lcd: lcd, timer: timer)
  }
}
