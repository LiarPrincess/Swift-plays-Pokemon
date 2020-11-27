// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftformat:disable consecutiveSpaces
private let vBlankMask:  UInt8 = 1 << 0
private let lcdStatMask: UInt8 = 1 << 1
private let timerMask:   UInt8 = 1 << 2
private let serialMask:  UInt8 = 1 << 3
private let joypadMask:  UInt8 = 1 << 4
// swiftformat:enable consecutiveSpaces

/// FF0F Interrupt Flag;
/// FFFF Interrupt Enable
public final class Interrupts {

  public struct Kind {
    public static let vBlank = Kind(mask: vBlankMask)
    public static let lcdStat = Kind(mask: lcdStatMask)
    public static let timer = Kind(mask: timerMask)
    public static let serial = Kind(mask: serialMask)
    public static let joypad = Kind(mask: joypadMask)

    fileprivate var mask: UInt8

    private init(mask: UInt8) {
      self.mask = mask
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
