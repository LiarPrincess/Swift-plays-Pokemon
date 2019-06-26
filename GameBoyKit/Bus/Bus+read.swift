// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftlint:disable function_body_length
// swiftlint:disable cyclomatic_complexity

import Foundation

extension Bus {

  /// Read from any address in memory.
  public func read(_ address: UInt16) -> UInt8 {
    switch address {

    // bootrom
    case MemoryMap.bootrom:
      return self.hasFinishedBootrom ?
        self.cartridge.readRom(address) :
        self.bootrom.read(address)

    // cartridge
    case MemoryMap.rom0, MemoryMap.rom1:
      return self.cartridge.readRom(address)
    case MemoryMap.externalRam:
      return self.cartridge.readRam(address)

    // internal
    case MemoryMap.highRam:
      return self.highRam[address - MemoryMap.highRam.start]
    case MemoryMap.internalRam:
      return self.ram[address - MemoryMap.internalRam.start]
    case MemoryMap.internalRamEcho:
      let ramAddress = self.convertEchoToRamAddress(address)
      return self.ram[ramAddress - MemoryMap.internalRam.start]

    // video
    case MemoryMap.videoRam:
      // Technically it should return 0xff during 'pixelTransfer'
      return self.lcd.videoRam[address - MemoryMap.videoRam.start]
    case MemoryMap.oam:
      // Technically it should return 0xff during 'pixelTransfer' or 'oamSearch'
      return self.lcd.oam[address - MemoryMap.oam.start]
    case MemoryMap.io:
      return self.readInternalIO(address)

    // other
    case MemoryMap.notUsable:
      return 0
    case MemoryMap.interruptEnable:
      return self.interrupts.enable

    default:
      print("Attempting to read from unsupported memory address: \(address.hex).")
      return self.unmappedMemory[address] ?? 0
    }
  }

  private func readInternalIO(_ address: UInt16) -> UInt8 {
    switch address {
    case MemoryMap.IO.joypad: return self.joypad.value
    case MemoryMap.IO.sb:     return self.serialPort.sb
    case MemoryMap.IO.sc:     return self.serialPort.sc
    case MemoryMap.IO.unmapBootrom:  return self.unmapBootrom
    case MemoryMap.IO.interruptFlag: return self.interrupts.flag

    case MemoryMap.Timer.div:  return self.timer.div
    case MemoryMap.Timer.tima: return self.timer.tima
    case MemoryMap.Timer.tma:  return self.timer.tma
    case MemoryMap.Timer.tac:  return self.timer.tac

    case MemoryMap.Audio.nr10:          return self.audio[address] ?? 0
    case MemoryMap.Audio.nr11:          return self.audio[address] ?? 0
    case MemoryMap.Audio.nr12:          return self.audio[address] ?? 0
    case MemoryMap.Audio.nr13:          return self.audio[address] ?? 0
    case MemoryMap.Audio.nr14:          return self.audio[address] ?? 0
    case MemoryMap.Audio.nr21:          return self.audio[address] ?? 0
    case MemoryMap.Audio.nr22:          return self.audio[address] ?? 0
    case MemoryMap.Audio.nr23:          return self.audio[address] ?? 0
    case MemoryMap.Audio.nr24:          return self.audio[address] ?? 0
    case MemoryMap.Audio.nr30:          return self.audio[address] ?? 0
    case MemoryMap.Audio.nr31:          return self.audio[address] ?? 0
    case MemoryMap.Audio.nr32:          return self.audio[address] ?? 0
    case MemoryMap.Audio.nr33:          return self.audio[address] ?? 0
    case MemoryMap.Audio.nr34:          return self.audio[address] ?? 0
    case MemoryMap.Audio.nr41:          return self.audio[address] ?? 0
    case MemoryMap.Audio.nr42:          return self.audio[address] ?? 0
    case MemoryMap.Audio.nr43:          return self.audio[address] ?? 0
    case MemoryMap.Audio.nr44:          return self.audio[address] ?? 0
    case MemoryMap.Audio.nr50:          return self.audio[address] ?? 0
    case MemoryMap.Audio.nr51:          return self.audio[address] ?? 0
    case MemoryMap.Audio.nr52:          return self.audio[address] ?? 0
    case MemoryMap.Audio.nr3_ram_start: return self.audio[address] ?? 0
    case MemoryMap.Audio.nr3_ram_end:   return self.audio[address] ?? 0

    case MemoryMap.Lcd.control: return self.lcd.control.value
    case MemoryMap.Lcd.status:  return self.lcd.status.value
    case MemoryMap.Lcd.scrollY: return self.lcd.scrollY
    case MemoryMap.Lcd.scrollX: return self.lcd.scrollX
    case MemoryMap.Lcd.line:        return self.lcd.line
    case MemoryMap.Lcd.lineCompare: return self.lcd.lineCompare
    case MemoryMap.Lcd.dma:         return 0
    case MemoryMap.Lcd.backgroundColors: return self.lcd.backgroundColors.value
    case MemoryMap.Lcd.objectColors0:    return self.lcd.objectColors0.value
    case MemoryMap.Lcd.objectColors1:    return self.lcd.objectColors1.value
    case MemoryMap.Lcd.windowY: return self.lcd.windowY
    case MemoryMap.Lcd.windowX: return self.lcd.windowX

    default:
      let index = address - MemoryMap.io.start
      return self.ioMemory[index]
    }
  }
}
