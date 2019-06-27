// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

public class Bus {

  internal let lcd: Lcd
  internal let timer: Timer
  internal let joypad: Joypad
  internal let serialPort: SerialPort
  internal let interrupts: Interrupts

  internal let bootrom: BusBootrom
  internal let cartridge: BusCartridge

  /// C000-CFFF 4KB Work RAM Bank 0 (WRAM)
  /// D000-DFFF 4KB Work RAM Bank 1 (WRAM) (switchable bank 1-7 in CGB Mode)
  internal lazy var ram = Data(memoryRange: MemoryMap.internalRam)

  /// FF00-FF7F I/O Ports (just in case game wants to write to unmapped address)
  internal lazy var ioMemory = Data(memoryRange: MemoryMap.io)

  /// FF80-FFFE High RAM (HRAM)
  internal lazy var highRam = Data(memoryRange: MemoryMap.highRam)

  /// FF01 - SB - Data send using serial transfer
  internal var linkCable = Data()

  /// Catch'em all for any invalid read/write
  internal var unmappedMemory = [UInt16:UInt8]()

  /// TODO: Catch'em all for audio read/write
  internal var audio = [UInt16:UInt8]()

  /// If > 0 then we have finished bootrom.
  internal var unmapBootrom: UInt8 = 0

  internal var hasFinishedBootrom: Bool { return self.unmapBootrom > 0 }

  internal init(bootrom:    BusBootrom,
                cartridge:  BusCartridge,
                joypad:     Joypad,
                lcd:        Lcd,
                timer:      Timer,
                interrupts: Interrupts) {

    self.lcd = lcd
    self.timer = timer
    self.joypad = joypad
    self.serialPort = SerialPort()
    self.interrupts = interrupts

    self.bootrom = bootrom
    self.cartridge = cartridge
  }

  // MARK: - Helpers

  internal func dma(writeValue: UInt8) {
    // Technically not exactly correct:
    // https://github.com/Gekkio/mooneye-gb/blob/master/docs/accuracy.markdown
    // -> What is the exact cycle-by-cycle behaviour of OAM DMA?

    let sourceStart = UInt16(writeValue) << 8

    for i in 0..<MemoryMap.oam.count {
      // [performance] write directly into OAM (instead of self.write)
      let sourceAddress = sourceStart + UInt16(i)
      self.lcd.oam[i] = self.read(sourceAddress)
    }
  }

  internal func convertEchoToRamAddress(_ address: UInt16) -> UInt16 {
    return address - 0x2000
  }
}

// MARK: - Restorable

extension Bus: Restorable {
  internal func save(to state: inout GameBoyState) {
    state.bus.ram = self.ram
    state.bus.ioMemory = self.ioMemory
    state.bus.highRam = self.highRam
    state.bus.audio = self.audio
    state.bus.unmappedMemory = self.unmappedMemory
    state.bus.unmapBootrom = self.unmapBootrom
  }

  internal func load(from state: GameBoyState) {
    self.ram = state.bus.ram
    self.ioMemory = state.bus.ioMemory
    self.highRam = state.bus.highRam
    self.audio = state.bus.audio
    self.unmappedMemory = state.bus.unmappedMemory
    self.unmapBootrom = state.bus.unmapBootrom
  }
}
