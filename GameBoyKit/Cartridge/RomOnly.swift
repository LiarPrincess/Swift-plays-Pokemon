// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

internal class RomOnly: Rom {

  internal override func writeBank0(_ address: UInt16, value: UInt8) {
    if 0x2000 <= address && address <= 0x3fff {
      self.selectedRamBank = max(1, UInt16(value))
    }
  }

  internal override func writeBankN(_ address: UInt16, value: UInt8) {
    // empty
  }
}
