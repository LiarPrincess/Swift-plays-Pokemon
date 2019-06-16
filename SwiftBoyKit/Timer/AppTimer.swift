// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

internal class AppTimer {

  internal private(set) var tima: UInt8 = 0x00
  internal private(set) var tma:  UInt8 = 0x00
  internal private(set) var tac:  UInt8 = 0x00

  internal private(set) var hasInterrupt: Bool = false

  private var progress: UInt = 0

  internal func read(globalAddress address: UInt16) -> UInt8 {
    switch address {
    case Timer.timaAddress: return self.tima
    case Timer.tmaAddress: return self.tma
    case Timer.tacAddress: return self.tac
    default:
      fatalError("Attempting to read invalid app timer memory")
    }
  }

  internal func write(globalAddress address: UInt16, value: UInt8) {
    switch address {
    case Timer.timaAddress: // weird, but ok...
      self.tima = value

    case Timer.tmaAddress:
      self.tma = value

    case Timer.tacAddress:
      let oldPeriod = self.period
      self.tac = value

      let hasChangedPeriod = oldPeriod != self.period
      if hasChangedPeriod {
        self.progress = 0
      }

    default:
      fatalError("Attempting to write invalid app timer memory")
    }
  }

  // MARK: - Interrupts

  internal func clearInterrupt() {
    self.hasInterrupt = false
  }

  // MARK: - Tick

  internal func tick(cycles: UInt8) {
    guard self.isEnabled else {
      return
    }

    self.progress += UInt(cycles)

    let period = self.period
    if self.progress >= period {
      self.progress %= period

      if self.tima == UInt8.max {
        self.tima = self.tma
        self.hasInterrupt = true
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
