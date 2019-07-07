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
  internal lazy var ram: UnsafeMutableBufferPointer<UInt8> = {
    UnsafeMutableBufferPointer<UInt8>.allocate(capacity: MemoryMap.internalRam.count)
  }()

  /// FF80-FFFE High RAM (HRAM)
  internal lazy var highRam: UnsafeMutableBufferPointer<UInt8> = {
    UnsafeMutableBufferPointer<UInt8>.allocate(capacity: MemoryMap.highRam.count)
  }()

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
