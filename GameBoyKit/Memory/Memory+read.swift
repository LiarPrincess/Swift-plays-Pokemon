// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftlint:disable function_body_length
// swiftlint:disable cyclomatic_complexity

import Foundation

private let defaultValue: UInt8 = 0xff

extension Memory {

  /// Read from any address in memory.
  public func read(_ address: UInt16) -> UInt8 {
    switch address {

    // bootrom
    case MemoryMap.bootrom:
      switch self.bootrom {
      case let .executing(bootrom): return bootrom.read(address)
      case .finished:               return self.cartridge.readRom(address)
      }

    // cartridge
    case MemoryMap.rom0, MemoryMap.rom1:
      return self.cartridge.readRom(address)
    case MemoryMap.externalRam:
      return self.cartridge.readRam(address)

    // internal
    case MemoryMap.highRam:
      let index = Int(address - MemoryMap.highRam.start)
      return self.highRam[index]
    case MemoryMap.internalRam:
      let index = Int(address - MemoryMap.internalRam.start)
      return self.ram[index]
    case MemoryMap.internalRamEcho:
      let ramAddress = self.convertEchoToRamAddress(address)
      let index      = Int(ramAddress - MemoryMap.internalRam.start)
      return self.ram[index]

    // video
    case MemoryMap.videoRam:
      // Technically it should return 0xff during 'pixelTransfer'
      return self.lcd.readVideoRam(address)
    case MemoryMap.oam:
      // Technically it should return 0xff during 'pixelTransfer' or 'oamSearch'
      return self.lcd.readOAM(address)
    case MemoryMap.io:
      return self.readInternalIO(address)

    // other
    case MemoryMap.notUsable:
      return defaultValue
    case MemoryMap.interruptEnable:
      return self.interrupts.enable

    default:
      print("Attempting to read from unsupported memory address: \(address.hex).")
      return self.unmappedMemory[address] ?? defaultValue
    }
  }

  private func readInternalIO(_ address: UInt16) -> UInt8 {
    switch address {
    case MemoryMap.IO.joypad: return self.joypad.value
    case MemoryMap.IO.sb:     return self.serialPort.sb
    case MemoryMap.IO.sc:     return self.serialPort.sc
    case MemoryMap.IO.unmapBootrom:  return defaultValue
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
    case MemoryMap.Lcd.dma:         return defaultValue
    case MemoryMap.Lcd.backgroundColors: return self.lcd.backgroundPalette.value
    case MemoryMap.Lcd.objectColors0:    return self.lcd.spritePalette0.value
    case MemoryMap.Lcd.objectColors1:    return self.lcd.spritePalette1.value
    case MemoryMap.Lcd.windowY: return self.lcd.windowY
    case MemoryMap.Lcd.windowX: return self.lcd.windowX

    default:
      return self.unmappedMemory[address] ?? defaultValue
    }
  }
}
