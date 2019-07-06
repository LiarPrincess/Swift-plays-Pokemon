// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

internal enum BootromState {
  case executing(BootromMemory)
  case finished
}

public class Memory: CpuAddressableMemory {

  internal let lcd: LcdMemory
  internal let timer: Timer
  internal let joypad: Joypad
  internal let serialPort: SerialPort
  internal let interrupts: Interrupts

  internal var bootrom: BootromState
  internal let cartridge: CartridgeMemory

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

  internal var audio = [UInt16:UInt8]()

  internal init(bootrom:    BootromMemory?,
                cartridge:  CartridgeMemory,
                joypad:     Joypad,
                lcd:        LcdMemory,
                timer:      Timer,
                interrupts: Interrupts) {

    self.lcd = lcd
    self.timer = timer
    self.joypad = joypad
    self.serialPort = SerialPort()
    self.interrupts = interrupts

    // swiftlint:disable:next force_unwrapping
    self.bootrom = bootrom != nil ? .executing(bootrom!) : .finished
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