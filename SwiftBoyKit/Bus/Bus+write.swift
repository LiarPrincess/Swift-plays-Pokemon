// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

extension Bus {

  public func write(_ address: UInt16, value: UInt8) {
    self.writeInternal(address, value: value)
    Debug.busDidWrite(to: address, value: value)
  }

  // swiftlint:disable:next cyclomatic_complexity
  internal func writeInternal(_ address: UInt16, value: UInt8) {
    func write(_ region: ClosedRange<UInt16>, _ array: inout [UInt8]) {
      array[address - region.start] = value
    }

    switch address {
    case MemoryMap.rom0:
      print("Attempting to wrtie to read-only rom0 memory at: \(address.hex).")
    case MemoryMap.rom1:
      print("Attempting to wrtie to read-only rom1 memory at: \(address.hex).")
    case MemoryMap.externalRam:
      write(MemoryMap.externalRam, &self.cartridge.ram)

    case MemoryMap.highRam: write(MemoryMap.highRam, &self.highRam)
    case MemoryMap.internalRam: write(MemoryMap.internalRam, &self.ram)
    case MemoryMap.internalRamEcho:
      let ramAddress = self.convertEchoToRamAddress(address)
      self.ram[ramAddress - MemoryMap.internalRam.start] = value

    case MemoryMap.videoRam: write(MemoryMap.videoRam, &self.lcd.videoRam)
    case MemoryMap.oam: write(MemoryMap.oam, &self.lcd.oam)
    case MemoryMap.io: self.writeInternalIO(address, value: value)

    case MemoryMap.notUsable: break
    case MemoryMap.unmapBootrom: break
    case MemoryMap.interruptEnable: self.interruptEnable.value = value

    default:
      print("Attempting to write to unsupported memory address: \(address.hex).")
      self.unmappedMemory[address] = value
    }
  }

  // swiftlint:disable:next cyclomatic_complexity
  private func writeInternalIO(_ address: UInt16, value: UInt8) {
    switch address {
    case MemoryMap.IO.joypad: self.joypad.value = value
    case MemoryMap.IO.sb: self.serialPort.sb = value
    case MemoryMap.IO.sc: self.serialPort.sc = value

    case MemoryMap.Timer.div:  self.timer.div = value
    case MemoryMap.Timer.tima: self.timer.tima = value
    case MemoryMap.Timer.tma:  self.timer.tma = value
    case MemoryMap.Timer.tac:  self.timer.tac = value

    // audio

//    case MemoryMap.Lcd.control: return 0
//    case MemoryMap.Lcd.status: return 0
//    case MemoryMap.Lcd.scrollY: return 0
//    case MemoryMap.Lcd.scrollX: return 0
//    case MemoryMap.Lcd.line: return 0
//    case MemoryMap.Lcd.lineCompare: return 0
    case MemoryMap.Lcd.dma: self.dma(writeValue: value)
//    case MemoryMap.Lcd.backgroundPalette: return 0
//    case MemoryMap.Lcd.objectPalette0: return 0
//    case MemoryMap.Lcd.objectPalette1: return 0
//    case MemoryMap.Lcd.windowY: return 0
//    case MemoryMap.Lcd.windowX: return 0

    default:
      print("Attempting to wrtie to unsupported IO memory address: \(address.hex).")
      self.unmappedMemory[address] = value
    }
  }

  private func dma(writeValue: UInt8) {
    let sourceStart = UInt16(writeValue) << 8

    for i in 0..<MemoryMap.oam.count {
      // for performance we are going to directly write to OAM
      // (instead of using self.write)

      let sourceAddress = sourceStart + UInt16(i)
      self.lcd.oam[i] = self.read(sourceAddress)
    }
  }
}
