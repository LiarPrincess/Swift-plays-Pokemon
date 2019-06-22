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
                   joypad:    self.joypad,
                   lcd:       self.lcd,
                   timer:     self.timer)

    self.cpu = Cpu(bus: self.bus)
  }

  @discardableResult
  public func tickFrame() -> Framebuffer {
    // Technically not exactly correct (see: 'The Ultimate Game Boy Talk' 54:20),
    // but I LOVE the simplicity of it (we ignore STAT during read/write anyway).
    // Source: https://github.com/Baekalfen/PyBoy

    let vBlankEnd = Lcd.height + LcdTimings.vBlankLineCount

    guard self.lcd.control.isLcdEnabled else {
      self.lcd.setMode(.vBlank)
      self.lcd.clear()

      for _ in 0..<vBlankEnd {
        self.tickCpu(cycles: LcdTimings.lineLength)
      }

      return self.lcd.framebuffer
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

    self.lcd.setMode(.vBlank)
    for line in Lcd.height..<vBlankEnd {
      self.lcd.startLine(line)
      self.tickCpu(cycles: LcdTimings.lineLength)
    }

    return self.lcd.framebuffer
  }

  private func tickCpu(cycles totalCycles: UInt16 = 1) {
    var remainingCycles = Int32(totalCycles) // so we can go < 0

    while remainingCycles > 0 {
      let cycles = self.cpu.tick()
      self.timer.tick(cycles: cycles)

      // TODO: Handle HALT somehow (return nil -> loop until next interrupt)

      remainingCycles -= Int32(cycles)
    }
  }
}

// MARK: - Restorable

extension GameBoy: Restorable {
  internal func save(to state: inout GameBoyState) {
    self.cpu.save(to: &state)
  }

  internal func load(from state: GameBoyState) {
    self.cpu.load(from: state)
  }
}
