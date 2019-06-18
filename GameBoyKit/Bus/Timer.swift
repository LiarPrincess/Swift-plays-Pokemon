// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

/// FF04 - Divider register;
/// FF05, FF06, FF07 - App defined timer
public class Timer {

  // MARK: - Tick

  internal func tick(cycles: UInt8) {
    self.tickDiv(cycles: cycles)
    self.tickTima(cycles: cycles)
  }

  // MARK: - Div

  /// Frequency at which div register should be incremented.
  public static let divFrequency: UInt = 16_384

  /// Divider - This register is incremented at rate of 16384Hz.
  /// Writing any value to this register resets it to 00h.
  public internal(set) var div: UInt8 {
    get { return self.divValue }
    set {
      self.divValue = 0
      self.divProgress = 0
    }
  }

  private var divValue: UInt8 = 0
  private var divProgress: UInt = 0

  private func tickDiv(cycles: UInt8) {
    let max = Cpu.clockSpeed / Timer.divFrequency // 256

    self.divProgress += UInt(cycles)

    if self.divProgress >= max {
      self.divValue &+= 1
      self.divProgress %= max
    }
  }

  // MARK: - Tima timer

  /// Timer counter - This timer is incremented by a clock frequency specified by the TAC register (FF07).
  /// When the value overflows then it will be reset to the value specified in TMA (FF06),
  /// and an interrupt will be requested.
  public internal(set) var tima: UInt8 = 0x00

  /// Timer Modulo - When the TIMA overflows, this data will be loaded.
  public internal(set) var tma: UInt8 = 0x00

  /// Timer Control:
  /// Bit 2    - Timer Stop;
  /// Bits 1-0 - Input Clock Select
  public internal(set) var tac: UInt8 = 0x00 {
    didSet {
      let oldPeriod = self.getPeriod(tac: oldValue)
      let newPeriod = self.getPeriod(tac: self.tac)

      if oldPeriod != newPeriod {
        self.timaProgress = 0
      }
    }
  }

  /// Flag instead of 0xFF0F.
  public internal(set) var hasInterrupt: Bool = false

  private var timaProgress: UInt = 0

  private func tickTima(cycles: UInt8) {
    guard self.isCustomEnabled else {
      return
    }

    self.timaProgress += UInt(cycles)

    let period = self.getPeriod(tac: self.tac)
    if self.timaProgress >= period {
      self.timaProgress %= period

      if self.tima == UInt8.max {
        self.tima = self.tma
        self.hasInterrupt = true
      } else {
        self.tima += 1
      }
    }
  }

  private var isCustomEnabled: Bool {
    return (self.tac & 0b100) == 0b100
  }

  private func getPeriod(tac: UInt8) -> UInt {
    switch tac & 0b11 {
    case 0b00: return Cpu.clockSpeed /   4_096 // 1024
    case 0b01: return Cpu.clockSpeed / 262_144 //   16
    case 0b10: return Cpu.clockSpeed /  65_536 //   64
    case 0b11: return Cpu.clockSpeed /  16_384 //  256
    default: fatalError("Invalid timer frequency.") // ?
    }
  }
}
