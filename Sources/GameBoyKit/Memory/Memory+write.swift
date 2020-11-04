// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftlint:disable function_body_length
// swiftlint:disable cyclomatic_complexity

import Foundation

extension Memory {

  internal func write(_ address: UInt16, value: UInt8) {
    switch address {

    // bootrom,
    case MemoryMap.bootrom:
      switch self.bootrom {
      case let .executing(bootrom): bootrom.write(address, value: value)
      case .finished:               self.cartridge.writeRom(address, value: value)
      }

    // cartridge
    case MemoryMap.rom0, MemoryMap.rom1:
      self.cartridge.writeRom(address, value: value)
    case MemoryMap.externalRam:
      self.cartridge.writeRam(address, value: value)

    // internal
    case MemoryMap.highRam:
      let index = Int(address - MemoryMap.highRam.start)
      self.highRam[index] = value
    case MemoryMap.internalRam:
      let index = Int(address - MemoryMap.internalRam.start)
      self.ram[index] = value
    case MemoryMap.internalRamEcho:
      let ramAddress = self.convertEchoToRamAddress(address)
      let index      = Int(ramAddress - MemoryMap.internalRam.start)
      self.ram[index] = value

    // video
    case MemoryMap.videoRam:
      // Technically it should nop during 'pixelTransfer'
      self.lcd.writeVideoRam(address, value: value)
    case MemoryMap.oam:
      // Technically it should nop during 'pixelTransfer' or 'oamSearch'
      self.lcd.writeOAM(address, value: value)

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
    case MemoryMap.IO.sb:
      self.linkCable.append(value)
      self.serialPort.sb = value
    case MemoryMap.IO.sc:     self.serialPort.sc = value
    case MemoryMap.IO.unmapBootrom:  self.bootrom = .finished
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

    case MemoryMap.Lcd.control: self.lcd.control = value
    case MemoryMap.Lcd.status:  self.lcd.status = value
    case MemoryMap.Lcd.scrollY: self.lcd.scrollY = value
    case MemoryMap.Lcd.scrollX: self.lcd.scrollX = value
    case MemoryMap.Lcd.line:        self.lcd.line = value
    case MemoryMap.Lcd.lineCompare: self.lcd.lineCompare = value
    case MemoryMap.Lcd.dma:         self.dma(writeValue: value)
    case MemoryMap.Lcd.backgroundPalette: self.lcd.backgroundPalette = value
    case MemoryMap.Lcd.spritePalette0:    self.lcd.spritePalette0 = value
    case MemoryMap.Lcd.spritePalette1:    self.lcd.spritePalette1 = value
    case MemoryMap.Lcd.windowY: self.lcd.windowY = value
    case MemoryMap.Lcd.windowX: self.lcd.windowX = value

    default:
      return self.unmappedMemory[address] = value
    }
  }
}
