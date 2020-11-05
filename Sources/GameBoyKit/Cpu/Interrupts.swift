// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

private let vBlankMask:  UInt8 = 1 << 0
private let lcdStatMask: UInt8 = 1 << 1
private let timerMask:   UInt8 = 1 << 2
private let serialMask:  UInt8 = 1 << 3
private let joypadMask:  UInt8 = 1 << 4

/// FF0F Interrupt Flag;
/// FFFF Interrupt Enable
public final class Interrupts {

  public enum Kind {
    case vBlank
    case lcdStat
    case timer
    case serial
    case joypad

    fileprivate var mask: UInt8 {
      switch self {
      case .vBlank:  return vBlankMask
      case .lcdStat: return lcdStatMask
      case .timer:   return timerMask
      case .serial:  return serialMask
      case .joypad:  return joypadMask
      }
    }
  }

  /// FF0F - IF - Interrupt Flag
  public internal(set) var flag: UInt8 = 0

  /// FFFF - IE - Interrupt Enable
  public internal(set) var enable: UInt8 = 0

  public func isSet(_ type: Kind) -> Bool {
    let mask = type.mask
    return self.flag & mask > 0
  }

  public func isEnabled(_ type: Kind) -> Bool {
    let mask = type.mask
    return self.enable & mask > 0
  }

  public func isEnabledAndSet(_ type: Kind) -> Bool {
    let mask = type.mask
    return self.enable & self.flag & mask > 0
  }

  internal func set(_ type: Kind) {
    let mask = type.mask
    self.flag |= mask
  }

  internal func clear(_ type: Kind) {
    let mask = type.mask
    self.flag &= ~mask
  }
}
