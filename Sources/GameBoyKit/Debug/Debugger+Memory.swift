// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

extension Debugger {

  // swiftlint:disable:next function_body_length
  internal func printMemoryWrites(before: DebugState, after: DebugState) {
    func printIfChanged<T: Equatable>(name: String, path: KeyPath<DebugState, T>) {
      let valueBefore = before[keyPath: path]
      let valueAfter = after[keyPath: path]

      if valueBefore != valueAfter {
        print("  > \(name) <- \(valueAfter)")
      }
    }

    printIfChanged(name: "io.joypad", path: \DebugState.io.joypad)
    printIfChanged(name: "io.sb", path: \DebugState.io.sb)
    printIfChanged(name: "io.sc", path: \DebugState.io.sc)
    printIfChanged(name: "io.unmapBootrom", path: \DebugState.io.unmapBootrom)

    printIfChanged(name: "timer.div", path: \DebugState.timer.div)
    printIfChanged(name: "timer.tima", path: \DebugState.timer.tima)
    printIfChanged(name: "timer.tma", path: \DebugState.timer.tma)
    printIfChanged(name: "timer.tac", path: \DebugState.timer.tac)

    printIfChanged(name: "audio.nr10", path: \DebugState.audio.nr10)
    printIfChanged(name: "audio.nr11", path: \DebugState.audio.nr11)
    printIfChanged(name: "audio.nr12", path: \DebugState.audio.nr12)
    printIfChanged(name: "audio.nr13", path: \DebugState.audio.nr13)
    printIfChanged(name: "audio.nr14", path: \DebugState.audio.nr14)
    printIfChanged(name: "audio.nr21", path: \DebugState.audio.nr21)
    printIfChanged(name: "audio.nr22", path: \DebugState.audio.nr22)
    printIfChanged(name: "audio.nr23", path: \DebugState.audio.nr23)
    printIfChanged(name: "audio.nr24", path: \DebugState.audio.nr24)
    printIfChanged(name: "audio.nr30", path: \DebugState.audio.nr30)
    printIfChanged(name: "audio.nr31", path: \DebugState.audio.nr31)
    printIfChanged(name: "audio.nr32", path: \DebugState.audio.nr32)
    printIfChanged(name: "audio.nr33", path: \DebugState.audio.nr33)
    printIfChanged(name: "audio.nr34", path: \DebugState.audio.nr34)
    printIfChanged(name: "audio.nr41", path: \DebugState.audio.nr41)
    printIfChanged(name: "audio.nr42", path: \DebugState.audio.nr42)
    printIfChanged(name: "audio.nr43", path: \DebugState.audio.nr43)
    printIfChanged(name: "audio.nr44", path: \DebugState.audio.nr44)
    printIfChanged(name: "audio.nr50", path: \DebugState.audio.nr50)
    printIfChanged(name: "audio.nr51", path: \DebugState.audio.nr51)
    printIfChanged(name: "audio.nr52", path: \DebugState.audio.nr52)
    printIfChanged(name: "audio.nr3_ram_start", path: \DebugState.audio.nr3_ram_start)
    printIfChanged(name: "audio.nr3_ram_end", path: \DebugState.audio.nr3_ram_end)

    printIfChanged(name: "lcd.control", path: \DebugState.lcd.control)
    printIfChanged(name: "lcd.status", path: \DebugState.lcd.status)
    printIfChanged(name: "lcd.scrollY", path: \DebugState.lcd.scrollY)
    printIfChanged(name: "lcd.scrollX", path: \DebugState.lcd.scrollX)
    printIfChanged(name: "lcd.line", path: \DebugState.lcd.line)
    printIfChanged(name: "lcd.lineCompare", path: \DebugState.lcd.lineCompare)
    printIfChanged(name: "lcd.dma", path: \DebugState.lcd.dma)

    printIfChanged(name: "lcd.backgroundPalette", path: \DebugState.lcd.backgroundPalette)
    printIfChanged(name: "lcd.spritePalette0", path: \DebugState.lcd.spritePalette0)
    printIfChanged(name: "lcd.spritePalette1", path: \DebugState.lcd.spritePalette1)
    printIfChanged(name: "lcd.windowY", path: \DebugState.lcd.windowY)
    printIfChanged(name: "lcd.windowX", path: \DebugState.lcd.windowX)

    printIfChanged(name: "interrupts.enable", path: \DebugState.interrupts.enable)
    printIfChanged(name: "interrupts.flag", path: \DebugState.interrupts.flag)
  }
}
