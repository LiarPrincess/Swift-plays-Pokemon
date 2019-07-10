// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

private let vBlankMask:  UInt8 = 1 << 0
private let lcdStatMask: UInt8 = 1 << 1
private let timerMask:   UInt8 = 1 << 2
private let serialMask:  UInt8 = 1 << 3
private let joypadMask:  UInt8 = 1 << 4

internal enum InterruptType {
  case vBlank
  case lcdStat
  case timer
  case serial
  case joypad
}

/// FF0F Interrupt Flag;
/// FFFF Interrupt Enable
public class Interrupts {

  /// FF0F - IF - Interrupt Flag
  public internal(set) var flag: UInt8 = 0

  /// FFFF - IE - Interrupt Enable
  public internal(set) var enable: UInt8 = 0

  internal var isAnySet: Bool {
    return self.enable & self.flag > 0
  }

  internal func set(_ type: InterruptType) {
    let mask = getMask(type)
    self.flag |= mask
  }

  internal func isSet(_ type: InterruptType) -> Bool {
    let mask = getMask(type)
    return self.enable & self.flag & mask > 0
  }

  internal func clear(_ type: InterruptType) {
    let mask = getMask(type)
    self.flag &= ~mask
  }
}

private func getMask(_ type: InterruptType) -> UInt8 {
  switch type {
  case .vBlank:  return vBlankMask
  case .lcdStat: return lcdStatMask
  case .timer:   return timerMask
  case .serial:  return serialMask
  case .joypad:  return joypadMask
  }
}
