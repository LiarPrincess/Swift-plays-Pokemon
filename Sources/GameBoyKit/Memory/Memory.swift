// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

public final class Memory: CpuMemory {

  internal enum BootromState {
    case executing(BootromMemory)
    case finished
  }

  internal let lcd: LcdMemory
  internal let audio: AudioMemory
  internal let timer: TimerMemory
  internal let joypad: JoypadMemory
  internal let interrupts: Interrupts
  internal let serialPort: SerialPort
  internal let linkCable: LinkCable

  internal var bootrom: BootromState
  internal var cartridge: CartridgeMemory

  /// C000-CFFF 4KB Work RAM Bank 0 (WRAM)
  /// D000-DFFF 4KB Work RAM Bank 1 (WRAM) (switchable bank 1-7 in CGB Mode)
  internal lazy var ram = MemoryBuffer(region: MemoryMap.internalRam)

  /// FF80-FFFE High RAM (HRAM)
  internal lazy var highRam = MemoryBuffer(region: MemoryMap.highRam)

  /// Catch'em all for any invalid read/write
  internal var unmappedMemory = [UInt16:UInt8]()

  internal init(bootrom:    BootromState,
                cartridge:  CartridgeMemory,
                joypad:     JoypadMemory,
                lcd:        LcdMemory,
                audio:      AudioMemory,
                timer:      TimerMemory,
                interrupts: Interrupts,
                serialPort: SerialPort,
                linkCable:  LinkCable) {
    self.bootrom = bootrom
    self.cartridge = cartridge
    self.joypad = joypad
    self.lcd = lcd
    self.audio = audio
    self.timer = timer
    self.interrupts = interrupts
    self.serialPort = serialPort
    self.linkCable = linkCable
  }

  deinit {
    self.ram.deallocate()
    self.highRam.deallocate()
  }

  // MARK: - Helpers

  internal func dma(writeValue: UInt8) {
    // Technically not exactly correct:
    // https://github.com/Gekkio/mooneye-gb/blob/master/docs/accuracy.markdown
    // -> What is the exact cycle-by-cycle behaviour of OAM DMA?

    let sourceStart = UInt16(writeValue) << 8

    for i in 0..<UInt16(MemoryMap.oam.count) {
      let sourceAddress = sourceStart + UInt16(i)
      let value = self.read(sourceAddress)

      let oamAddress = MemoryMap.oam.start + i
      self.lcd.writeOAM(oamAddress, value: value)
    }
  }

  internal func convertEchoToRamAddress(_ address: UInt16) -> UInt16 {
    return address - 0x2000
  }
}
