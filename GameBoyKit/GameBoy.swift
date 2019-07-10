// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

public class GameBoy {

  public static var lcdWidth:  Int { return LcdConstants.width }
  public static var lcdHeight: Int { return LcdConstants.height }

  public let cpu: Cpu
  public var lcd: Lcd { return self._lcd }
  public let memory: Memory
  public var timer:  Timer  { return self._timer }
  public var joypad: Joypad { return self._joypad }

  internal let _lcd: LcdImpl
  internal let _timer: TimerImpl
  internal let _joypad: JoypadImpl

  /// Number of cycles that elapsed since we started current frame.
  private var frameProgress: Int = 0

  public var linkCable: Data {
    return self.memory.linkCable
  }

  public init(input:     GameboyInputProvider,
              bootrom:   Bootrom,
              cartridge: Cartridge) {

    let interrupts = Interrupts()
    self._lcd = LcdImpl(interrupts: interrupts)
    self._timer = TimerImpl(interrupts: interrupts)
    self._joypad = JoypadImpl(provider: input)

    let skipBootrom = bootrom.data.isEmpty
    self.memory = Memory(bootrom:   skipBootrom ? nil : bootrom,
                         cartridge: cartridge,
                         joypad:    self._joypad,
                         lcd:       self._lcd,
                         timer:     self._timer,
                         interrupts: interrupts)

    self.cpu = Cpu(memory: self.memory, interrupts: interrupts)

    if skipBootrom {
      self.skipBootrom()
    }

    // prepare for 1st frame
    self._lcd.startFrame()
  }

  @discardableResult
  public func tickFrame() -> Framebuffer {
    let cycles = LcdConstants.cyclesPerFrame - self.frameProgress

    self.tickCpu(cycles: cycles)

    // if we stopped at the last cycle of the frame, then
    // run 1 bonus instruction to actually 'tick' it
    if self.frameProgress == LcdConstants.cyclesPerFrame {
      self.tickCpu(cycles: 1)
    }

    return self.lcd.framebuffer
  }

  internal func tickCpu(cycles totalCycles: Int = 1) {
    var remainingCycles = totalCycles

    while remainingCycles > 0 {
      let cycles = self.cpu.tick()
      remainingCycles -= cycles

      self.frameProgress += cycles
      if self.frameProgress > LcdConstants.cyclesPerFrame {
        self.frameProgress -= LcdConstants.cyclesPerFrame
        self._lcd.startFrame()
      }

      self._timer.tick(cycles: cycles)
      self._lcd.tick(cycles: cycles)
    }
  }

  // swiftlint:disable:next function_body_length
  private func skipBootrom() {
    // Source: http://bgb.bircd.org/pandocs.htm#powerupsequence

    self.cpu.registers.af = 0x01b0
    self.cpu.registers.bc = 0x0013
    self.cpu.registers.de = 0x00d8
    self.cpu.registers.hl = 0x014d

    self.cpu.pc = 0x0100
    self.cpu.sp = 0xfffe

    self.memory.write(0xff05, value: 0x00) // TIMA
    self.memory.write(0xff06, value: 0x00) // TMA
    self.memory.write(0xff07, value: 0x00) // TAC
    self.memory.write(0xff10, value: 0x80) // NR10
    self.memory.write(0xff11, value: 0xbf) // NR11
    self.memory.write(0xff12, value: 0xf3) // NR12
    self.memory.write(0xff14, value: 0xbf) // NR14
    self.memory.write(0xff16, value: 0x3f) // NR21
    self.memory.write(0xff17, value: 0x00) // NR22
    self.memory.write(0xff19, value: 0xbf) // NR24
    self.memory.write(0xff1a, value: 0x7f) // NR30
    self.memory.write(0xff1b, value: 0xff) // NR31
    self.memory.write(0xff1c, value: 0x9f) // NR32
    self.memory.write(0xff1e, value: 0xbf) // NR33
    self.memory.write(0xff20, value: 0xff) // NR41
    self.memory.write(0xff21, value: 0x00) // NR42
    self.memory.write(0xff22, value: 0x00) // NR43
    self.memory.write(0xff23, value: 0xbf) // NR30
    self.memory.write(0xff24, value: 0x77) // NR50
    self.memory.write(0xff25, value: 0xf3) // NR51
    self.memory.write(0xff26, value: 0xf1) // NR52
    self.memory.write(0xff40, value: 0x91) // LCDC
    self.memory.write(0xff42, value: 0x00) // SCY
    self.memory.write(0xff43, value: 0x00) // SCX
    self.memory.write(0xff45, value: 0x00) // LYC
    self.memory.write(0xff47, value: 0xfc) // BGP
    self.memory.write(0xff48, value: 0xff) // OBP0
    self.memory.write(0xff49, value: 0xff) // OBP1
    self.memory.write(0xff4a, value: 0x00) // WY
    self.memory.write(0xff4b, value: 0x00) // WX
    self.memory.write(0xffff, value: 0x00) // IE
  }
}
