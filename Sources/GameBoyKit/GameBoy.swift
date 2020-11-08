// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

public final class GameBoy {

  public let cpu: Cpu
  public let lcd: Lcd
  public let audio: Audio
  public let memory: Memory
  public let timer: GameBoyKit.Timer
  public let joypad: Joypad
  public let serialPort: SerialPort
  public let linkCable: LinkCable

  /// Number of cycles that elapsed since we started current frame.
  private var frameProgress: Int = 0

  // MARK: - Init

  public init(bootrom: Bootrom?,
              cartridge: Cartridge,
              input: GameboyInputProvider) {
    let interrupts = Interrupts()
    self.lcd = Lcd(interrupts: interrupts)
    self.audio = Audio()
    self.timer = GameBoyKit.Timer(interrupts: interrupts)
    self.joypad = Joypad(provider: input)
    self.serialPort = SerialPort()
    self.linkCable = LinkCable()

    self.memory = Memory(bootrom:    bootrom,
                         cartridge:  cartridge,
                         joypad:     self.joypad,
                         lcd:        self.lcd,
                         audio:      self.audio,
                         timer:      self.timer,
                         interrupts: interrupts,
                         serialPort: self.serialPort,
                         linkCable:  self.linkCable)

    self.cpu = Cpu(memory: self.memory, interrupts: interrupts)

    if bootrom == nil {
      self.skipToStateAfterBootrom()
    }
  }

  // swiftlint:disable:next function_body_length
  private func skipToStateAfterBootrom() {
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

  // MARK: - Tick

  public func tickFrame() {
    let cycles = Lcd.Constants.cyclesPerFrame - self.frameProgress

    self.tickCpu(cycles: cycles)

    // If we stopped at the last cycle of the current frame,
    // we need to run 1 bonus instruction to actually 'tick' it
    if self.frameProgress == Lcd.Constants.cyclesPerFrame {
      self.tickCpu(cycles: 1)
    }
  }

  internal func tickCpu(cycles totalCycles: Int = 1) {
    var remainingCycles = totalCycles

    while remainingCycles > 0 {
      let cycles = self.cpu.tick()
      remainingCycles -= cycles

      self.frameProgress += cycles
      self.frameProgress %= Lcd.Constants.cyclesPerFrame

      self.timer.tick(cycles: cycles)
      self.lcd.tick(cycles: cycles)
    }
  }
}
