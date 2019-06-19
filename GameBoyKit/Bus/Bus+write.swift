// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

extension Bus {

  public func write(_ address: UInt16, value: UInt8) {
    self.writeInternal(address, value: value)
    Debug.busDidWrite(to: address, value: value)
  }

  // swiftlint:disable:next function_body_length cyclomatic_complexity
  internal func writeInternal(_ address: UInt16, value: UInt8) {
    func write(_ region: ClosedRange<UInt16>, _ array: inout [UInt8]) {
      array[address - region.start] = value
    }

    switch address {

    // cartridge
    case MemoryMap.rom0:
      print("Attempting to write to read-only rom0 memory at: \(address.hex).")
    case MemoryMap.rom1:
      print("Attempting to write to read-only rom1 memory at: \(address.hex).")
    case MemoryMap.externalRam:
      write(MemoryMap.externalRam, &self.cartridge.ram)

    // internal
    case MemoryMap.highRam:
      write(MemoryMap.highRam, &self.highRam)
    case MemoryMap.internalRam:
      write(MemoryMap.internalRam, &self.ram)
    case MemoryMap.internalRamEcho:
      let ramAddress = self.convertEchoToRamAddress(address)
      self.ram[ramAddress - MemoryMap.internalRam.start] = value

    // video
    case MemoryMap.videoRam:
      // Technically it should nop during 'pixelTransfer'
      write(MemoryMap.videoRam, &self.lcd.videoRam)
    case MemoryMap.oam:
      // Technically it should nop during 'pixelTransfer' or 'oamSearch'
      write(MemoryMap.oam, &self.lcd.oam)
    case MemoryMap.io:
      self.writeInternalIO(address, value: value)

    // other
    case MemoryMap.notUsable:
      break
    case MemoryMap.unmapBootrom:
      fatalError("Writing to unmapBootrom (\(MemoryMap.unmapBootrom) is not yet implemented)")
      break
    case MemoryMap.interruptEnable:
      self.interruptEnable.value = value

    default:
      print("Attempting to write to unsupported memory address: \(address.hex).")
      self.unmappedMemory[address] = value
    }
  }

  // swiftlint:disable:next function_body_length cyclomatic_complexity
  private func writeInternalIO(_ address: UInt16, value: UInt8) {
    switch address {
    case MemoryMap.IO.joypad: self.joypad.value = value
    case MemoryMap.IO.sb:     self.serialPort.sb = value
    case MemoryMap.IO.sc:     self.serialPort.sc = value

    case MemoryMap.Timer.div:  self.timer.div = value
    case MemoryMap.Timer.tima: self.timer.tima = value
    case MemoryMap.Timer.tma:  self.timer.tma = value
    case MemoryMap.Timer.tac:  self.timer.tac = value

    case MemoryMap.Audio.nr10:          self.audio[address] = value
    case MemoryMap.Audio.nr11:          self.audio[address] = value
    case MemoryMap.Audio.nr12:          self.audio[address] = value
    case MemoryMap.Audio.nr13:          self.audio[address] = value
    case MemoryMap.Audio.nr14:          self.audio[address] = value
    case MemoryMap.Audio.nr21:          self.audio[address] = value
    case MemoryMap.Audio.nr22:          self.audio[address] = value
    case MemoryMap.Audio.nr23:          self.audio[address] = value
    case MemoryMap.Audio.nr24:          self.audio[address] = value
    case MemoryMap.Audio.nr30:          self.audio[address] = value
    case MemoryMap.Audio.nr31:          self.audio[address] = value
    case MemoryMap.Audio.nr32:          self.audio[address] = value
    case MemoryMap.Audio.nr33:          self.audio[address] = value
    case MemoryMap.Audio.nr34:          self.audio[address] = value
    case MemoryMap.Audio.nr41:          self.audio[address] = value
    case MemoryMap.Audio.nr42:          self.audio[address] = value
    case MemoryMap.Audio.nr43:          self.audio[address] = value
    case MemoryMap.Audio.nr44:          self.audio[address] = value
    case MemoryMap.Audio.nr50:          self.audio[address] = value
    case MemoryMap.Audio.nr51:          self.audio[address] = value
    case MemoryMap.Audio.nr52:          self.audio[address] = value
    case MemoryMap.Audio.nr3_ram_start: self.audio[address] = value
    case MemoryMap.Audio.nr3_ram_end:   self.audio[address] = value

    case MemoryMap.Lcd.control: self.lcd.control.value = value
    case MemoryMap.Lcd.status:  self.lcd.status.value = value
    case MemoryMap.Lcd.scrollY: self.lcd.scrollY = value
    case MemoryMap.Lcd.scrollX: self.lcd.scrollX = value
    case MemoryMap.Lcd.line:        self.lcd.line = value
    case MemoryMap.Lcd.lineCompare: self.lcd.lineCompare = value
    case MemoryMap.Lcd.dma:         self.dma(writeValue: value)
    case MemoryMap.Lcd.backgroundPalette: self.lcd.backgroundPalette.value = value
    case MemoryMap.Lcd.objectPalette0:    self.lcd.objectPalette0.value = value
    case MemoryMap.Lcd.objectPalette1:    self.lcd.objectPalette1.value = value
    case MemoryMap.Lcd.windowY: self.lcd.windowY = value
    case MemoryMap.Lcd.windowX: self.lcd.windowX = value

    default:
      print("Attempting to wrtie to unsupported IO memory address: \(address.hex).")
      self.unmappedMemory[address] = value
    }
  }

  private func dma(writeValue: UInt8) {
    let sourceStart = UInt16(writeValue) << 8

    for i in 0..<MemoryMap.oam.count {
      // [performance] write directly into OAM (instead of self.write)
      let sourceAddress = sourceStart + UInt16(i)
      self.lcd.oam[i] = self.read(sourceAddress)
    }
  }
}
