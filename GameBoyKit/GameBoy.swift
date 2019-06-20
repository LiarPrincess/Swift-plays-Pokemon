// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// TODO: Access control + final
// TODO: State after boot should be the same as (bottom): http://www.codeslinger.co.uk/pages/projects/gameboy/hardware.html
public class GameBoy {

  public let cpu: Cpu
  public let lcd: Lcd
  public let bus: Bus
  public let timer: Timer
  public let joypad: Joypad
  public let cartridge: Cartridge

  public init() {
    self.lcd = Lcd()
    self.timer = Timer()
    self.joypad = Joypad()
    self.cartridge = .bootrom

    self.bus = Bus(cartridge: self.cartridge,
                   joypad: self.joypad,
                   lcd: self.lcd,
                   timer: self.timer)

    self.cpu = Cpu(bus: self.bus)

    // in debug we support only 1 emulator (the last one created)
    Debug.gameBoy = self
  }

  public func tickFrame() {
    // Technically not exactly correct (see: 'The Ultimate Game Boy Talk' 54:20),
    // but I LOVE the simplicity of it (we ignore STAT during read/write anyway).
    // Source: https://github.com/Baekalfen/PyBoy

    let vBlankEnd = Lcd.height + LcdTimings.vBlankLineCount

    guard self.lcd.control.isLcdEnabled else {
      // self.window.blank_screen() // self.lcd.clear()
      self.lcd.setMode(.vBlank)
      self.lcd.resetLine()

      for _ in 0..<vBlankEnd {
        self.tickCpu(cycles: LcdTimings.lineLength)
      }

      return
    }

    for line in 0..<Lcd.height {
      self.lcd.startLine(line)

      self.lcd.setMode(.oamSearch)
      self.tickCpu(cycles: LcdTimings.oamSearchLength)

      self.lcd.setMode(.pixelTransfer)
      self.tickCpu(cycles: LcdTimings.pixelTransferLength)
      self.lcd.drawLine()

      self.lcd.setMode(.hBlank)
      self.tickCpu(cycles: LcdTimings.hBlankLength)
    }

    // self.window.render_screen(self.lcd)

    for line in Lcd.height..<vBlankEnd {
      self.lcd.setMode(.vBlank)
      self.lcd.startLine(line)
      self.tickCpu(cycles: LcdTimings.lineLength)
    }
  }

  private func tickCpu(cycles totalCycles: UInt16) {
    var remainingCycles = totalCycles
    while remainingCycles > 0 {
      let cycles = self.cpu.tick()
      self.timer.tick(cycles: cycles)

      // TODO: Handle HALT somehow (return nil -> loop until next interrupt)

      remainingCycles -= UInt16(cycles)
    }
  }

  public func run(maxCycles: UInt16? = nil, lastPC: UInt16? = nil) {
    Debug.emulatorWillStart()

    let maxCycles = maxCycles ?? UInt16.max
    let lastPC  = lastPC ?? UInt16.max

    var brakepoint = false
    while self.cpu.cycle <= maxCycles && self.cpu.pc != lastPC {
      // ------------
      brakepoint = brakepoint || self.cpu.pc == 0x0039
      if brakepoint { // conditional brakepoint in lldb slows down code (by a lot)
        _ = 5
      }
      // ------------

      let cycles = self.cpu.tick()
      self.timer.tick(cycles: cycles)
//      self.ppu.update(cycles: cycles)
    }

    print("Finished:")
    print("  cycle: cpu: \(self.cpu.cycle.hex) max: \(maxCycles.hex) -> \(self.cpu.cycle > maxCycles)")
    print("  pc:    cpu: \(self.cpu.pc.hex) max: \(lastPC.hex) -> \(self.cpu.pc == lastPC)")

    self.lcd.dump()
  }
}
