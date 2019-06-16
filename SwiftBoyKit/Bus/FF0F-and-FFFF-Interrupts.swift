// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

public enum InterruptType {
  /** 0 */ case vBlank
  /** 1 */ case lcdStat
  /** 2 */ case timer
  /** 3 */ case serial
  /** 4 */ case joypad
}

/// 0xFF0F and 0xFFFF Interrupts
public class Interrupts: MemoryRegion {

  public static let ifAddress: UInt16 = 0xff0f
  public static let ieAddress: UInt16 = 0xffff

  public static let vBlankMask:  UInt8 = 1 << 0
  public static let lcdStatMask: UInt8 = 1 << 1
  public static let timerMask:   UInt8 = 1 << 2
  public static let serialMask:  UInt8 = 1 << 3
  public static let joypadMask:  UInt8 = 1 << 4

  /// Interrupt Flag
  public var `if`: UInt8 = 0x00

  /// Interrupt Enable
  public var ie: UInt8 = 0x00

  // MARK: - MemoryRegion

  public func contains(globalAddress address: UInt16) -> Bool {
    return address == Interrupts.ifAddress
        || address == Interrupts.ieAddress
  }

  public func read(globalAddress address: UInt16) -> UInt8 {
    assert(self.contains(globalAddress: address))
    switch address {
    case Interrupts.ifAddress: return self.if
    case Interrupts.ieAddress: return self.ie
    default:
      fatalError("Attempting to read invalid interrupt memory")
    }
  }

  public func write(globalAddress address: UInt16, value: UInt8) {
    assert(self.contains(globalAddress: address))
    switch address {
    case Interrupts.ifAddress: self.if = value
    case Interrupts.ieAddress: self.ie = value
    default:
      fatalError("Attempting to write invalid interrupt memory")
    }
  }

  // MARK: - Bits

  /// Is given interrupt enabled?
  public func isEnabled(_ type: InterruptType) -> Bool {
    let mask = self.getMask(type)
    return (self.ie & mask) == mask
  }

  /// Is given interrupt waiting for processing?
  public func isSet(_ type: InterruptType) -> Bool {
    let mask = self.getMask(type)
    return (self.if & mask) == mask
  }

  /// Sets to 1 flag responsible for given interrupt.
  public func request(_ type: InterruptType) {
    self.if |= self.getMask(type)
  }

  /// Resets to 0 flag responsible for given interrupt.
  public func reset(_ type: InterruptType) {
    self.if &= ~(self.getMask(type))
  }

  private func getMask(_ type: InterruptType) -> UInt8 {
    switch type {
    case .vBlank:  return Interrupts.vBlankMask
    case .lcdStat: return Interrupts.lcdStatMask
    case .timer:   return Interrupts.timerMask
    case .serial:  return Interrupts.serialMask
    case .joypad:  return Interrupts.joypadMask
    }
  }
}
