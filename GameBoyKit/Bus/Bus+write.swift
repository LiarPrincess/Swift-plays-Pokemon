// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftlint:disable function_body_length
// swiftlint:disable cyclomatic_complexity

import Foundation

extension Bus {

  internal func write(_ address: UInt16, value: UInt8) {
    func write(_ region: ClosedRange<UInt16>, _ data: inout Data) {
      data[address - region.start] = value
    }

    switch address {

    // bootrom, cartridge
    case MemoryMap.bootrom:
      if self.hasFinishedBootrom {
        print("Attempting to write to read-only rom0 at: \(address.hex).")
      } else {
        print("Attempting to write to read-only bootrom at: \(address.hex).")
      }
    case MemoryMap.rom0:
      // overlaps with bootrom, so 'case' order matters
      print("Attempting to write to read-only rom0 at: \(address.hex).")
    case MemoryMap.rom1:
      print("Attempting to write to read-only rom1 at: \(address.hex).")
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
    case MemoryMap.interruptEnable:
      self.interrupts.enable = value

    default:
      print("Attempting to write to unsupported memory address: \(address.hex).")
      self.unmappedMemory[address] = value
    }
  }

  private func writeInternalIO(_ address: UInt16, value: UInt8) {
    switch address {
    case MemoryMap.IO.joypad: self.joypad.value = value
    case MemoryMap.IO.sb:     self.serialPort.sb = value
    case MemoryMap.IO.sc:     self.serialPort.sc = value
    case MemoryMap.IO.unmapBootrom:  self.hasFinishedBootrom = true
    case MemoryMap.IO.interruptFlag: self.interrupts.flag = value

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
    case MemoryMap.Lcd.backgroundColors: self.lcd.backgroundColors.value = value
    case MemoryMap.Lcd.objectColors0:    self.lcd.objectColors0.value = value
    case MemoryMap.Lcd.objectColors1:    self.lcd.objectColors1.value = value
    case MemoryMap.Lcd.windowY: self.lcd.windowY = value
    case MemoryMap.Lcd.windowX: self.lcd.windowX = value

    default:
      let index = address - MemoryMap.io.start
      return self.ioMemory[index] = value
    }
  }

  private func dma(writeValue: UInt8) {
    // Technically not exactly correct:
    // https://github.com/Gekkio/mooneye-gb/blob/master/docs/accuracy.markdown#what-is-the-exact-cycle-by-cycle-behaviour-of-oam-dma

    let sourceStart = UInt16(writeValue) << 8

    for i in 0..<MemoryMap.oam.count {
      // [performance] write directly into OAM (instead of self.write)
      let sourceAddress = sourceStart + UInt16(i)
      self.lcd.oam[i] = self.read(sourceAddress)
    }
  }
}
