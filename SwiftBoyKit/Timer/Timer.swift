// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

//// TODO: Test timer
//public class Timer {
//
//  /// Div register should increment every 'clockSpeed/16384' cycles
//  /// This property tracks progress (meaning that it counts from 0 to 'clockSpeed/16384').
//  private var divCounter: UInt8 = 0
//
//  // TODO: Let memory reset timer.divCounter (http://www.codeslinger.co.uk/pages/projects/gameboy/timers.html)
//  private var previousDiv: UInt8 = 0
//
//  private var appCounterTarget: UInt16 = 0
//  private var appCounter:       UInt16 = 0
//
//  private var isEnabled: Bool {
//    return (self.memory.tac & 0b100) == 0b100
//  }
//
//  private var period: UInt16 {
//    switch self.memory.tac & 0b11 {
//    case 0b00: return UInt16(Cpu.clockSpeed /   4_096) // 1024
//    case 0b01: return UInt16(Cpu.clockSpeed / 262_144) //   16
//    case 0b10: return UInt16(Cpu.clockSpeed /  65_536) //   64
//    case 0b11: return UInt16(Cpu.clockSpeed /  16_384) //  256
//    default: fatalError("Invalid timer frequency.") // No way this is going to happen
//    }
//  }
//
//  private var memory: TimerMemoryView
//
//  internal init(memory: TimerMemoryView) {
//    self.memory = memory
//  }
//
//  public func tick(cycles: UInt8) {
//    self.updateDivRegister(cycles: cycles)
//    self.updateAppTimer(cycles: cycles)
//  }
//
//  // MARK: - Div timer
//
//  private func updateDivRegister(cycles: UInt8) {
//    let hasWrittenToDiv = self.previousDiv != self.memory.div
//    if hasWrittenToDiv {
//      self.divCounter = 0
//    }
//
//    let (newValue, overflow) = self.divCounter.addingReportingOverflow(cycles)
//    self.divCounter = newValue
//
//    if overflow {
//      self.memory.div &+= 1
//    }
//
//    self.previousDiv = self.memory.div
//  }
//
//  // MARK: - App timer
//
//  private func updateAppTimer(cycles: UInt8) {
//    guard self.isEnabled else {
//      return
//    }
//
//    let newTarget = self.period
//    if self.appCounterTarget != newTarget {
//      self.resetAppTimer()
//    }
//
//    self.appCounter += UInt16(cycles)
//    if self.appCounter < self.appCounterTarget {
//      return
//    }
//
//    self.resetAppTimer()
//
//    let tima = self.memory.tima
//    if tima == UInt8.max {
//      self.memory.tima = self.memory.tma
//      // RequestInterupt(2)
//    } else {
//      self.memory.tima = tima + 1
//    }
//  }
//
//  private func resetAppTimer() {
//    self.appCounter = 0
//    self.appCounterTarget = self.period
//  }
//}
