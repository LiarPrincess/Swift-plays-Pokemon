// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

private let vBlankMask:  UInt8 = 1 << 0
private let lcdStatMask: UInt8 = 1 << 1
private let timerMask:   UInt8 = 1 << 2
private let serialMask:  UInt8 = 1 << 3
private let joypadMask:  UInt8 = 1 << 4

/// FFFF Interrupt Enable Register
public class InterruptEnable {

  public static let address: UInt16 = 0xffff

  public var vBlank:  Bool { return isSet(self.value, mask: vBlankMask) }
  public var lcdStat: Bool { return isSet(self.value, mask: lcdStatMask) }
  public var timer:   Bool { return isSet(self.value, mask: timerMask) }
  public var serial:  Bool { return isSet(self.value, mask: serialMask) }
  public var joypad:  Bool { return isSet(self.value, mask: joypadMask) }

  public internal(set) var value: UInt8 = 0x00
}

private func isSet(_ value: UInt8, mask: UInt8) -> Bool {
  return (value & mask) == mask
}
