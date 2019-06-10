// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

/// FF05, FF06, FF07 - App defined timer
public class AppTimer: MemoryRegion {

  public static let timaAddress: UInt16 = 0xff05
  public static let tmaAddress:  UInt16 = 0xff06
  public static let tacAddress:  UInt16 = 0xff07

  /// Timer counter - This timer is incremented by a clock frequency specified by the TAC register (FF07).
  /// When the value overflows then it will be reset to the value specified in TMA (FF06),
  /// and an interrupt will be requested.
  public var tima: UInt8 = 0x00

  /// Timer Modulo - When the TIMA overflows, this data will be loaded.
  public var tma: UInt8 = 0x00

  /// Timer Control:
  /// Bit 2    - Timer Stop;
  /// Bits 1-0 - Input Clock Select
  public var tac: UInt8 = 0x00

  private var progress: UInt = 0

  private unowned let interrupts: Interrupts

  internal init(interrupts: Interrupts) {
    self.interrupts = interrupts
  }

  // MARK: - Memory region

  public func contains(globalAddress address: UInt16) -> Bool {
    return address >= AppTimer.timaAddress
        && address <= AppTimer.tacAddress
  }

  public func read(globalAddress address: UInt16) -> UInt8 {
    assert(self.contains(globalAddress: address))
    switch address {
    case AppTimer.timaAddress: return self.tima
    case AppTimer.tmaAddress: return self.tma
    case AppTimer.tacAddress: return self.tac
    default:
      fatalError("Attempting to read invalid timer memory")
    }
  }

  public func write(globalAddress address: UInt16, value: UInt8) {
    assert(self.contains(globalAddress: address))
    switch address {
    case AppTimer.timaAddress: // weird, but ok...
      self.tima = value

    case AppTimer.tmaAddress:
      self.tma = value

    case AppTimer.tacAddress:
      let oldPeriod = self.period
      self.tac = value

      let hasChangedPeriod = oldPeriod != self.period
      if hasChangedPeriod {
        self.progress = 0
      }

    default:
      fatalError("Attempting to write invalid timer memory")
    }
  }

  // MARK: - Tick

  public func tick(cycles: UInt8) {
    guard self.isEnabled else {
      return
    }

    self.progress += UInt(cycles)

    let period = self.period
    if self.progress >= period {
      self.progress %= period

      if self.tima == UInt8.max {
        self.tima = self.tma
        self.interrupts.request(.timer)
      } else {
        self.tima += 1
      }
    }
  }

  private var isEnabled: Bool {
    return (self.tac & 0b100) == 0b100
  }

  private var period: UInt {
    switch self.tac & 0b11 {
    case 0b00: return Cpu.clockSpeed /   4_096 // 1024
    case 0b01: return Cpu.clockSpeed / 262_144 //   16
    case 0b10: return Cpu.clockSpeed /  65_536 //   64
    case 0b11: return Cpu.clockSpeed /  16_384 //  256
    default: fatalError("Invalid timer frequency.") // What?
    }
  }
}
