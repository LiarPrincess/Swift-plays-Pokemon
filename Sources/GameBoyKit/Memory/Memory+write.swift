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
    case MemoryMap.bootrom where self.isRunningBootrom:
      bootrom.write(address, value: value)

    // cartridge
    case MemoryMap.rom0, MemoryMap.rom1:
      self.cartridge.writeRom(address, value: value)
    case MemoryMap.externalRam:
      self.cartridge.writeRam(address, value: value)

    // internal
    case MemoryMap.highRam:
      let index = address - MemoryMap.highRam.start
      self.highRam[index] = value
    case MemoryMap.internalRam:
      let index = address - MemoryMap.internalRam.start
      self.ram[index] = value
    case MemoryMap.internalRamEcho:
      let ramAddress = self.convertEchoToRamAddress(address)
      let index = ramAddress - MemoryMap.internalRam.start
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
      self.linkCable.write(value)
      self.serialPort.sb = value
    case MemoryMap.IO.sc:     self.serialPort.sc = value
    case MemoryMap.IO.unmapBootrom:  self.isRunningBootrom = false
    case MemoryMap.IO.interruptFlag: self.interrupts.flag = value

    case MemoryMap.Timer.div:  self.timer.div = value
    case MemoryMap.Timer.tima: self.timer.tima = value
    case MemoryMap.Timer.tma:  self.timer.tma = value
    case MemoryMap.Timer.tac:  self.timer.tac = value

    case MemoryMap.Audio.nr10: self.audio.nr10 = value
    case MemoryMap.Audio.nr11: self.audio.nr11 = value
    case MemoryMap.Audio.nr12: self.audio.nr12 = value
    case MemoryMap.Audio.nr13: self.audio.nr13 = value
    case MemoryMap.Audio.nr14: self.audio.nr14 = value
    case MemoryMap.Audio.nr21: self.audio.nr21 = value
    case MemoryMap.Audio.nr22: self.audio.nr22 = value
    case MemoryMap.Audio.nr23: self.audio.nr23 = value
    case MemoryMap.Audio.nr24: self.audio.nr24 = value
    case MemoryMap.Audio.nr30: self.audio.nr30 = value
    case MemoryMap.Audio.nr31: self.audio.nr31 = value
    case MemoryMap.Audio.nr32: self.audio.nr32 = value
    case MemoryMap.Audio.nr33: self.audio.nr33 = value
    case MemoryMap.Audio.nr34: self.audio.nr34 = value
    case MemoryMap.Audio.nr41: self.audio.nr41 = value
    case MemoryMap.Audio.nr42: self.audio.nr42 = value
    case MemoryMap.Audio.nr43: self.audio.nr43 = value
    case MemoryMap.Audio.nr44: self.audio.nr44 = value
    case MemoryMap.Audio.nr50: self.audio.nr50 = value
    case MemoryMap.Audio.nr51: self.audio.nr51 = value
    case MemoryMap.Audio.nr52: self.audio.nr52 = value
    case MemoryMap.Audio.nr3_ram_start: self.audio.nr3_ram_start = value
    case MemoryMap.Audio.nr3_ram_end:   self.audio.nr3_ram_end = value

    case MemoryMap.Lcd.control:
      self.lcd.control = LcdControl(value: value)
    case MemoryMap.Lcd.status:
      self.lcd.status = LcdStatus(value: value)
    case MemoryMap.Lcd.scrollY:
      self.lcd.scrollY = value
    case MemoryMap.Lcd.scrollX:
      self.lcd.scrollX = value
    case MemoryMap.Lcd.line:
      self.lcd.line = value
    case MemoryMap.Lcd.lineCompare:
      self.lcd.lineCompare = value
    case MemoryMap.Lcd.dma:
      self.dma(writeValue: value)
    case MemoryMap.Lcd.backgroundPalette:
      self.lcd.backgroundColorPalette = BackgroundColorPalette(value: value)
    case MemoryMap.Lcd.spritePalette0:
      self.lcd.spriteColorPalette0 = SpriteColorPalette(value: value)
    case MemoryMap.Lcd.spritePalette1:
      self.lcd.spriteColorPalette1 = SpriteColorPalette(value: value)
    case MemoryMap.Lcd.windowY:
      self.lcd.windowY = value
    case MemoryMap.Lcd.windowX:
      self.lcd.windowX = value

    default:
      return self.unmappedMemory[address] = value
    }
  }
}
