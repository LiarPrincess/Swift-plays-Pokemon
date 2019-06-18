// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

extension Bus {

  public func read(_ address: UInt16) -> UInt8 {
    let value = self.readInternal(address)
    Debug.busDidRead(from: address, value: value)
    return value
  }

  // swiftlint:disable:next function_body_length cyclomatic_complexity
  internal func readInternal(_ address: UInt16) -> UInt8 {
    func read(_ region: ClosedRange<UInt16>, _ array: [UInt8]) -> UInt8 {
      return array[address - region.start]
    }

    switch address {

    // cartridge
    case MemoryMap.rom0:
      return read(MemoryMap.rom0, self.cartridge.rom0)
    case MemoryMap.rom1:
      return read(MemoryMap.rom1, self.cartridge.rom1)
    case MemoryMap.externalRam:
      return read(MemoryMap.externalRam, self.cartridge.ram)

    // internal
    case MemoryMap.highRam:
      return read(MemoryMap.highRam, self.highRam)
    case MemoryMap.internalRam:
      return read(MemoryMap.internalRam, self.ram)
    case MemoryMap.internalRamEcho:
      let ramAddress = self.convertEchoToRamAddress(address)
      return self.ram[ramAddress - MemoryMap.internalRam.start]

    // video
    case MemoryMap.videoRam:
      // Technically it should return 0xff during 'pixelTransfer'
      return read(MemoryMap.videoRam, self.lcd.videoRam)
    case MemoryMap.oam:
      // Technically it should return 0xff during 'pixelTransfer' or 'oamSearch'
      return read(MemoryMap.oam, self.lcd.oam)
    case MemoryMap.io:
      return self.readInternalIO(address)

    // other
    case MemoryMap.notUsable:
      return 0
    case MemoryMap.unmapBootrom:
      return 0
    case MemoryMap.interruptEnable:
      return self.interruptEnable.value

    default:
      print("Attempting to read from unsupported memory address: \(address.hex).")
      return self.unmappedMemory[address] ?? 0
    }
  }

  // swiftlint:disable:next function_body_length cyclomatic_complexity
  private func readInternalIO(_ address: UInt16) -> UInt8 {
    switch address {
    case MemoryMap.IO.joypad: return self.joypad.value
    case MemoryMap.IO.sb:     return self.serialPort.sb
    case MemoryMap.IO.sc:     return self.serialPort.sc

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
    case MemoryMap.Lcd.backgroundPalette: return self.lcd.backgroundPalette.value
    case MemoryMap.Lcd.objectPalette0:    return self.lcd.objectPalette0.value
    case MemoryMap.Lcd.objectPalette1:    return self.lcd.objectPalette1.value
    case MemoryMap.Lcd.windowY: return self.lcd.windowY
    case MemoryMap.Lcd.windowX: return self.lcd.windowX

    default:
      print("Attempting to read from unsupported IO memory address: \(address.hex).")
      return self.unmappedMemory[address] ?? 0
    }
  }
}
