// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

/// FF04 - Divider register;
/// FF05, FF06, FF07 - App defined timer
public class Timer {

  private let interrupts: Interrupts

  internal init(interrupts: Interrupts) {
    self.interrupts = interrupts
  }

  // MARK: - Tick

  internal func tick(cycles: Int) {
    self.tickDiv(cycles: cycles)
    self.tickTima(cycles: cycles)
  }

  // MARK: - Div

  /// Frequency at which div register should be incremented.
  public static let divFrequency: Int = 16_384

  /// FF04 - DIV - Divider Register.
  /// This register is incremented at rate of 16384Hz.
  /// Writing any value to this register resets it to 00h.
  public internal(set) var div: UInt8 {
    get { return self.divValue }
    set {
      self.divValue = 0
      self.divProgress = 0
    }
  }

  private var divValue: UInt8 = 0
  private var divProgress: Int = 0

  private func tickDiv(cycles: Int) {
    let max = Cpu.clockSpeed / Timer.divFrequency // 256

    self.divProgress += cycles

    if self.divProgress >= max {
      self.divValue &+= 1
      self.divProgress %= max
    }
  }

  // MARK: - Tima timer

  /// FF05 - TIMA - Timer counter.
  /// This timer is incremented by a clock frequency specified by the TAC
  /// register (FF07). When the value overflows then it will be reset to the
  /// value specified in TMA (FF06), and an interrupt will be requested.
  public internal(set) var tima: UInt8 = 0x00

  /// FF06 - TMA - Timer Modulo.
  /// When the TIMA overflows, this data will be loaded.
  public internal(set) var tma: UInt8 = 0x00

  /// FF07 - TAC - Timer Control.
  /// Bit 2 - stop timer, bits 1 and 0 - select clock
  public internal(set) var tac: UInt8 = 0x00 {
    didSet {
      let oldPeriod = self.getPeriod(tac: oldValue)
      let newPeriod = self.getPeriod(tac: self.tac)

      if oldPeriod != newPeriod {
        self.timaProgress = 0
      }
    }
  }

  private var timaProgress: Int = 0

  private func tickTima(cycles: Int) {
    guard self.isCustomEnabled else {
      return
    }

    self.timaProgress += cycles

    let period = self.getPeriod(tac: self.tac)
    if self.timaProgress >= period {
      // instruction may take even 24 cycles (call_a16), so if we have:
      // progress: 12
      // cycles:   24 -> new progress 36
      // min period 16 -> 2 tima increments with 4 cycles remaining

      let timaIncrement = self.timaProgress / period
      self.timaProgress %= period

      let timaMax = Int(UInt8.max)
      let newTima = Int(self.tima) + timaIncrement

      if newTima <= timaMax {
        self.tima = UInt8(newTima)
      } else {
        let diff = newTima - timaMax

        self.tima = self.tma + UInt8(diff)
        self.interrupts.timer = true
      }
    }
  }

  private var isCustomEnabled: Bool {
    return (self.tac & 0b100) == 0b100
  }

  private func getPeriod(tac: UInt8) -> Int {
    switch tac & 0b11 {
    case 0b00: return Cpu.clockSpeed /   4_096 // 1024
    case 0b01: return Cpu.clockSpeed / 262_144 //   16
    case 0b10: return Cpu.clockSpeed /  65_536 //   64
    case 0b11: return Cpu.clockSpeed /  16_384 //  256
    default: fatalError("Invalid timer frequency.") // ?
    }
  }
}
