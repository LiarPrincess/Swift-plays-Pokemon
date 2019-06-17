// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

public class Bus {

  private let lcd: Lcd
  private let timer: Timer
  private let cartridge: Cartridge
  private let interruptEnable: InterruptEnable

  /// C000-CFFF 4KB Work RAM Bank 0 (WRAM)
  /// D000-DFFF 4KB Work RAM Bank 1 (WRAM) (switchable bank 1-7 in CGB Mode)
  private var ram = [UInt8](memoryRange: MemoryMap.internalRam)

  /// FF80-FFFE High RAM (HRAM)
  private var highRam = [UInt8](memoryRange: MemoryMap.highRam)

  internal init(cartridge: Cartridge, lcd: Lcd, timer: Timer) {
    self.lcd = lcd
    self.timer = timer
    self.cartridge = cartridge
    self.interruptEnable = InterruptEnable()
  }

  // MARK: - Read

  public func read(_ address: UInt16) -> UInt8 {
    let value = self.readInternal(address)
//    Debug.memoryDidRead(from: address, region: region, value: value)
    return value
  }

  // swiftlint:disable:next cyclomatic_complexity
  internal func readInternal(_ address: UInt16) -> UInt8 {
    func read(_ region: ClosedRange<UInt16>, _ array: [UInt8]) -> UInt8 {
      return array[address - region.lowerBound]
    }

    switch address {
    case MemoryMap.rom0: return read(MemoryMap.rom0, self.cartridge.rom0)
    case MemoryMap.rom1: return read(MemoryMap.rom1, self.cartridge.rom1)
    case MemoryMap.externalRam: return read(MemoryMap.externalRam, self.cartridge.ram)

    case MemoryMap.highRam: return read(MemoryMap.highRam, self.highRam)
    case MemoryMap.internalRam: return read(MemoryMap.internalRam, self.ram)
    case MemoryMap.internalRamEcho:
      let ramAddress = self.convertEchoToRamAddress(address)
      return self.ram[ramAddress - MemoryMap.internalRam.lowerBound]

    case MemoryMap.videoRam: return read(MemoryMap.videoRam, self.lcd.videoRam)
    case MemoryMap.oam: return read(MemoryMap.oam, self.lcd.oam)
    case MemoryMap.io: return self.readInternalIO(address)

    case MemoryMap.notUsable: return 0
    case MemoryMap.unmapBootrom: return 0
    case MemoryMap.interruptEnable: return self.interruptEnable.value
    default:
      fatalError("Attempting to read from unsupported memory address: \(address.hex).")
    }
  }

  // swiftlint:disable:next cyclomatic_complexity
  private func readInternalIO(_ address: UInt16) -> UInt8 {
    switch address {
    case MemoryMap.IO.joypad: return 0

    case MemoryMap.IO.sb: return 0
    case MemoryMap.IO.sc: return 0

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
      fatalError("Attempting to read from unsupported IO memory address: \(address.hex).")
    }
  }

  // MARK: - Write

  public func write(_ address: UInt16, value: UInt8) {
    self.writeInternal(address, value: value)
  }

  internal func writeInternal(_ address: UInt16, value: UInt8) {
    fatalError("Attempting to write to unsupported memory address: \(address.hex).")
  }

  private func dma(writeValue: UInt8) {
    //    let sourceAddress = UInt16(writeValue) << 8

    // move it to Oam class?
    //    for i in 0..<Oam.count {
    //      let value = self.read(sourceAddress + i)
    //      self.write(Oam.start + i, value: value)
    //    }
  }

  // MARK: - Echo

  private func convertEchoToRamAddress(_ address: UInt16) -> UInt16 {
    return address - 0x2000
  }

  // MARK: - Interrupts

  internal func isInterruptRequested(type: InterruptType) -> Bool {
    switch type {
    case .vBlank:  return self.interruptEnable.vBlank  && false
    case .lcdStat: return self.interruptEnable.lcdStat && false
    case .timer:   return self.interruptEnable.timer   && self.timer.hasInterrupt
    case .serial:  return self.interruptEnable.serial  && false
    case .joypad:  return self.interruptEnable.joypad  && false
    }
  }

  internal func clearInterrupt(type: InterruptType) {
    switch type {
    case .vBlank: break
    case .lcdStat: break
    case .timer: self.timer.clearInterrupt()
    case .serial: break
    case .joypad: break
    }
  }
}
