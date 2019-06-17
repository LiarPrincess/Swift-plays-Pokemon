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

    case MemoryMap.IO.div:  return self.timer.div
    case MemoryMap.IO.tima: return self.timer.tima
    case MemoryMap.IO.tma:  return self.timer.tma
    case MemoryMap.IO.tac:  return self.timer.tac

    case MemoryMap.IO.interruptFlag: return 0

      // audio

    case MemoryMap.IO.lcdControl: return 0
    case MemoryMap.IO.lcdStatus: return 0
    case MemoryMap.IO.lcdScrollY: return 0
    case MemoryMap.IO.lcdScrollX: return 0
    case MemoryMap.IO.lcdLine: return 0
    case MemoryMap.IO.lcdLineCompare: return 0
    case MemoryMap.IO.dma: return 0
    case MemoryMap.IO.lcdBackgroundPalette: return 0
    case MemoryMap.IO.lcdObjectPalette0: return 0
    case MemoryMap.IO.lcdObjectPalette1: return 0
    case MemoryMap.IO.lcdWindowY: return 0
    case MemoryMap.IO.lcdWindowX: return 0

    default:
      print("Attempting to read from unsupported IO memory address: \(address.hex).")
      return self.unmappedMemory[address] ?? 0
    }
  }
}
