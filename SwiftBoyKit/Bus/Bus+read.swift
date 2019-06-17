// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

extension Bus {

  public func read(_ address: UInt16) -> UInt8 {
    let value = self.readInternal(address)
    Debug.busDidRead(from: address, value: value)
    return value
  }

  // swiftlint:disable:next cyclomatic_complexity
  internal func readInternal(_ address: UInt16) -> UInt8 {
    func read(_ region: ClosedRange<UInt16>, _ array: [UInt8]) -> UInt8 {
      return array[address - region.start]
    }

    switch address {
    case MemoryMap.rom0: return read(MemoryMap.rom0, self.cartridge.rom0)
    case MemoryMap.rom1: return read(MemoryMap.rom1, self.cartridge.rom1)
    case MemoryMap.externalRam: return read(MemoryMap.externalRam, self.cartridge.ram)

    case MemoryMap.highRam: return read(MemoryMap.highRam, self.highRam)
    case MemoryMap.internalRam: return read(MemoryMap.internalRam, self.ram)
    case MemoryMap.internalRamEcho:
      let ramAddress = self.convertEchoToRamAddress(address)
      return self.ram[ramAddress - MemoryMap.internalRam.start]

    case MemoryMap.videoRam: return read(MemoryMap.videoRam, self.lcd.videoRam)
    case MemoryMap.oam: return read(MemoryMap.oam, self.lcd.oam)
    case MemoryMap.io: return self.readInternalIO(address)

    case MemoryMap.notUsable: return 0
    case MemoryMap.unmapBootrom: return 0
    case MemoryMap.interruptEnable: return self.interruptEnable.value

    default:
      print("Attempting to read from unsupported memory address: \(address.hex).")
      return self.unmappedMemory[address] ?? 0
    }
  }

  // swiftlint:disable:next cyclomatic_complexity
  private func readInternalIO(_ address: UInt16) -> UInt8 {
    switch address {
    case MemoryMap.IO.joypad: return self.joypad.value
    case MemoryMap.IO.sb: return self.serialPort.sb
    case MemoryMap.IO.sc: return self.serialPort.sc

    case MemoryMap.Timer.div:  return self.timer.div
    case MemoryMap.Timer.tima: return self.timer.tima
    case MemoryMap.Timer.tma:  return self.timer.tma
    case MemoryMap.Timer.tac:  return self.timer.tac

    // audio

    case MemoryMap.Lcd.control: return self.lcd.control.value
    case MemoryMap.Lcd.status:  return self.lcd.status.value
    case MemoryMap.Lcd.scrollY: return self.lcd.scrollY
    case MemoryMap.Lcd.scrollX: return self.lcd.scrollX
    case MemoryMap.Lcd.line:        return self.lcd.line
    case MemoryMap.Lcd.lineCompare: return self.lcd.lineCompare
    case MemoryMap.Lcd.dma: return 0
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
