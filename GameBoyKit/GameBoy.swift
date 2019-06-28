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
  public init(bootrom: Bootrom = .skip, cartridge: Cartridge) {
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
      }

      self.timer.tick(cycles: UInt8(cycles))
      self.lcd.tick(cycles: cycles)

      // TODO: Handle HALT somehow (return nil -> loop until next interrupt)
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
