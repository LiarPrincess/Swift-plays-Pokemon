// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

extension Debugger {

  internal func printMemoryWrites(before: DebugState, after: DebugState) {
    self.printIOWrites(before:    before.io,    after: after.io)
    self.printTimerWrites(before: before.timer, after: after.timer)
    self.printAudioWrites(before: before.audio, after: after.audio)
    self.printLcdWrites(before:   before.lcd,   after: after.lcd)
    self.printInterruptWrites(before: before.interrupts, after: after.interrupts)
  }

  private func printIOWrites(before b: DebugIOState,
                             after  a: DebugIOState) {

    if b.joypad != a.joypad { print("  > io.joypad <- \(a.joypad)") }
    if b.sb     != a.sb     { print("  > io.sb <- \(a.sb)") }
    if b.sc     != a.sc     { print("  > io.sc <- \(a.sc)") }

    if b.unmapBootrom != a.unmapBootrom {
      print("  > io.unmapBootrom <- \(a.unmapBootrom)")
    }
  }

  private func printTimerWrites(before b: DebugTimerState,
                                after  a: DebugTimerState) {

    if b.div  != a.div  { print("  > timer.div <- \(a.div)") }
    if b.tima != a.tima { print("  > timer.tima <- \(a.tima)") }
    if b.tma  != a.tma  { print("  > timer.tma <- \(a.tma)") }
    if b.tac  != a.tac  { print("  > timer.tac <- \(a.tac)") }
  }

  // swiftlint:disable:next cyclomatic_complexity
  private func printAudioWrites(before b: DebugAudioState,
                                after  a: DebugAudioState) {

    if b.nr10 != a.nr10 { print("  > audio.nr10 <- \(a.nr10)") }
    if b.nr11 != a.nr11 { print("  > audio.nr11 <- \(a.nr11)") }
    if b.nr12 != a.nr12 { print("  > audio.nr12 <- \(a.nr12)") }
    if b.nr13 != a.nr13 { print("  > audio.nr13 <- \(a.nr13)") }
    if b.nr14 != a.nr14 { print("  > audio.nr14 <- \(a.nr14)") }
    if b.nr21 != a.nr21 { print("  > audio.nr21 <- \(a.nr21)") }
    if b.nr22 != a.nr22 { print("  > audio.nr22 <- \(a.nr22)") }
    if b.nr23 != a.nr23 { print("  > audio.nr23 <- \(a.nr23)") }
    if b.nr24 != a.nr24 { print("  > audio.nr24 <- \(a.nr24)") }
    if b.nr30 != a.nr30 { print("  > audio.nr30 <- \(a.nr30)") }
    if b.nr31 != a.nr31 { print("  > audio.nr31 <- \(a.nr31)") }
    if b.nr32 != a.nr32 { print("  > audio.nr32 <- \(a.nr32)") }
    if b.nr33 != a.nr33 { print("  > audio.nr33 <- \(a.nr33)") }
    if b.nr34 != a.nr34 { print("  > audio.nr34 <- \(a.nr34)") }
    if b.nr41 != a.nr41 { print("  > audio.nr41 <- \(a.nr41)") }
    if b.nr42 != a.nr42 { print("  > audio.nr42 <- \(a.nr42)") }
    if b.nr43 != a.nr43 { print("  > audio.nr43 <- \(a.nr43)") }
    if b.nr44 != a.nr44 { print("  > audio.nr44 <- \(a.nr44)") }
    if b.nr50 != a.nr50 { print("  > audio.nr50 <- \(a.nr50)") }
    if b.nr51 != a.nr51 { print("  > audio.nr51 <- \(a.nr51)") }
    if b.nr52 != a.nr52 { print("  > audio.nr52 <- \(a.nr52)") }

    if b.nr3_ram_start != a.nr3_ram_start {
      print("  > audio.nr3_ram_start <- \(a.nr3_ram_start)")
    }
    if b.nr3_ram_end != a.nr3_ram_end {
      print("  > audio.nr3_ram_end <- \(a.nr3_ram_end)")
    }
  }

  // swiftlint:disable:next cyclomatic_complexity
  private func printLcdWrites(before b: DebugLcdState,
                              after  a: DebugLcdState) {

    if b.control     != a.control     { print("  > lcd.control <- \(a.control)") }
    if b.status      != a.status      { print("  > lcd.status <- \(a.status)") }
    if b.scrollY     != a.scrollY     { print("  > lcd.scrollY <- \(a.scrollY)") }
    if b.scrollX     != a.scrollX     { print("  > lcd.scrollX <- \(a.scrollX)") }
    if b.line        != a.line        { print("  > lcd.line <- \(a.line)") }
    if b.lineCompare != a.lineCompare { print("  > lcd.lineCompare <- \(a.lineCompare)") }
    if b.dma         != a.dma         { print("  > lcd.dma <- \(a.dma)") }

    if b.backgroundColors != a.backgroundColors {
      print("  > lcd.backgroundColors <- \(a.backgroundColors)")
    }
    if b.objectColors0 != a.objectColors0 {
      print("  > lcd.objectColors0 <- \(a.objectColors0)")
    }
    if b.objectColors1 != a.objectColors1 {
      print("  > lcd.objectColors1 <- \(a.objectColors1)")
    }

    if b.windowY != a.windowY { print("  > lcd.windowY <- \(a.windowY)") }
    if b.windowX != a.windowX { print("  > lcd.windowX <- \(a.windowX)") }
  }

  private func printInterruptWrites(before b: DebugInterruptState,
                                    after  a: DebugInterruptState) {

    if b.enable != a.enable { print("  > inter.enable <- \(a.enable)") }
    if b.flag   != a.flag   { print("  > inter.flag <- \(a.flag)") }
  }
}
