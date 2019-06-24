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

  public init(bootrom: Bootrom = .skip) {
    self.lcd = Lcd()
    self.timer = Timer()
    self.joypad = Joypad()

    let dataSize = MemoryMap.rom0.count + MemoryMap.rom1.count
    let cartridge = Cartridge(data: Data(count: dataSize))

    self.bus = Bus(bootrom:   bootrom,
                   cartridge: cartridge,
                   joypad:    self.joypad,
                   lcd:       self.lcd,
                   timer:     self.timer)

    self.cpu = Cpu(bus: self.bus)
  }

  @discardableResult
  public func tickFrame() -> Framebuffer {
    let lineCount = UInt32(Lcd.totalLineCount)
    let cyclesPerLine = UInt32(Lcd.cyclesPerLine)
    self.tickCpu(cycles: lineCount * cyclesPerLine)
    return self.lcd.framebuffer
  }

  internal func tickCpu(cycles totalCycles: UInt32 = 1) {
    var remainingCycles = Int64(totalCycles) // so we can go < 0

    while remainingCycles > 0 {
      let cycles = self.cpu.tick()
      self.timer.tick(cycles: cycles)
      self.lcd.tick(cycles: cycles)

      // TODO: Handle HALT somehow (return nil -> loop until next interrupt)

      remainingCycles -= Int64(cycles)
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
