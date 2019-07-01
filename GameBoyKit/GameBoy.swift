// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

public class GameBoy {

  public let cpu: Cpu
  public let lcd: Lcd
  public let bus: Bus
  public let timer: Timer
  public let joypad: Joypad

  /// Number of cycles that elapsed since we started current frame.
  private var frameProgress: Int = 0

  public var linkCable: Data {
    return self.bus.linkCable
  }

  // swiftlint:disable:next function_default_parameter_at_end
  public init(bootrom: Bootrom? = nil, cartridge: Cartridge) {
    let interrupts = Interrupts()
    self.lcd = Lcd(interrupts: interrupts)
    self.timer = Timer(interrupts: interrupts)
    self.joypad = Joypad()

    self.bus = Bus(bootrom:   bootrom,
                   cartridge: cartridge,
                   joypad:    self.joypad,
                   lcd:       self.lcd,
                   timer:     self.timer,
                   interrupts: interrupts)

    self.cpu = Cpu(bus: self.bus, interrupts: interrupts)

    if bootrom == nil {
      self.skipBootrom()
    }

    // prepare for 1st frame
    self.lcd.startFrame()
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
        self.lcd.startFrame()
        print("--- Starting frame ---")
      }

      self.timer.tick(cycles: UInt8(cycles))
      self.lcd.tick(cycles: cycles)

      // TODO: Handle HALT somehow (return nil -> loop until next interrupt)
    }
  }

  private func skipBootrom() {
    // Source: http://bgb.bircd.org/pandocs.htm#powerupsequence

    self.cpu.registers.af = 0x01b0
    self.cpu.registers.bc = 0x0013
    self.cpu.registers.de = 0x00d8
    self.cpu.registers.hl = 0x014d

    self.cpu.pc = 0x0100
    self.cpu.sp = 0xfffe

    self.bus.write(0xff05, value: 0x00) // TIMA
    self.bus.write(0xff06, value: 0x00) // TMA
    self.bus.write(0xff07, value: 0x00) // TAC
    self.bus.write(0xff10, value: 0x80) // NR10
    self.bus.write(0xff11, value: 0xbf) // NR11
    self.bus.write(0xff12, value: 0xf3) // NR12
    self.bus.write(0xff14, value: 0xbf) // NR14
    self.bus.write(0xff16, value: 0x3f) // NR21
    self.bus.write(0xff17, value: 0x00) // NR22
    self.bus.write(0xff19, value: 0xbf) // NR24
    self.bus.write(0xff1a, value: 0x7f) // NR30
    self.bus.write(0xff1b, value: 0xff) // NR31
    self.bus.write(0xff1c, value: 0x9f) // NR32
    self.bus.write(0xff1e, value: 0xbf) // NR33
    self.bus.write(0xff20, value: 0xff) // NR41
    self.bus.write(0xff21, value: 0x00) // NR42
    self.bus.write(0xff22, value: 0x00) // NR43
    self.bus.write(0xff23, value: 0xbf) // NR30
    self.bus.write(0xff24, value: 0x77) // NR50
    self.bus.write(0xff25, value: 0xf3) // NR51
    self.bus.write(0xff26, value: 0xf1) // NR52
    self.bus.write(0xff40, value: 0x91) // LCDC
    self.bus.write(0xff42, value: 0x00) // SCY
    self.bus.write(0xff43, value: 0x00) // SCX
    self.bus.write(0xff45, value: 0x00) // LYC
    self.bus.write(0xff47, value: 0xfc) // BGP
    self.bus.write(0xff48, value: 0xff) // OBP0
    self.bus.write(0xff49, value: 0xff) // OBP1
    self.bus.write(0xff4a, value: 0x00) // WY
    self.bus.write(0xff4b, value: 0x00) // WX
    self.bus.write(0xffff, value: 0x00) // IE
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
