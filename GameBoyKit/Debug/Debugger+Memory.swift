// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

extension Debugger {

  internal func printMemoryWrites(before: GameBoyState, after: GameBoyState) {
    self.printLcdWrites(b: before.lcd, a: after.lcd)
    self.printBusWrites(b: before.bus, a: after.bus)
    self.printCartridgeWrites(b: before.cartridge, a: after.cartridge)
  }

  private func printLcdWrites(b: LcdState, a: LcdState) {
    if b.control != a.control { print("  > lcd.control <- \(a.control)") }
    if b.status  != a.status  { print("  > lcd.status: \(b.status) -> \(a.status)") }

    if b.scrollY != a.scrollY { print("  > lcd.scrollY: \(b.scrollY) -> \(a.scrollY)") }
    if b.scrollX != a.scrollX { print("  > lcd.scrollX: \(b.scrollX) -> \(a.scrollX)") }

    if b.line        != a.line        { print("  > lcd.line: \(b.line) -> \(a.line)") }
    if b.lineCompare != a.lineCompare { print("  > lcd.lineCompare: \(b.lineCompare) -> \(a.lineCompare)") }

    if b.windowY != a.windowY { print("  > lcd.windowY: \(b.windowY) -> \(a.windowY)") }
    if b.windowX != a.windowX { print("  > lcd.windowX: \(b.windowX) -> \(a.windowX)") }

    if b.backgroundColors != a.backgroundColors { print("  > lcd.backgroundColors: \(b.backgroundColors) -> \(a.backgroundColors)") }
    if b.objectColors0    != a.objectColors0    { print("  > lcd.objectColors0: \(b.objectColors0) -> \(a.objectColors0)") }
    if b.objectColors1    != a.objectColors1    { print("  > lcd.objectColors1: \(b.objectColors1) -> \(a.objectColors1)") }

    if b.frameProgress != a.frameProgress { print("  > lcd.frameProgress: \(b.frameProgress) -> \(a.frameProgress)") }

    self.printWrites(memory: MemoryMap.videoRam, b: b.videoRam, a: a.videoRam)
    self.printWrites(memory: MemoryMap.oam, b: b.oam, a: a.oam)
  }

  private func printBusWrites(b: BusState, a: BusState) {
    self.printWrites(memory: MemoryMap.internalRam, b: b.ram, a: a.ram)
    self.printWrites(memory: MemoryMap.io, b: b.ioMemory, a: a.ioMemory)
    self.printWrites(memory: MemoryMap.highRam, b: b.highRam, a: a.highRam)

    self.printWrites(b: b.audio, a: a.audio)
    self.printWrites(b: b.unmappedMemory, a: a.unmappedMemory)
    if b.unmapBootrom != a.unmapBootrom { print("  > bus.unmapBootrom <- \(a.unmapBootrom)") }
  }

  private func printCartridgeWrites(b: CartridgeState, a: CartridgeState) {
    for (bb, ab) in zip(b.ramBanks, a.ramBanks) {
      self.printWrites(memory: MemoryMap.externalRam, b: bb, a: ab)
    }
  }

  private func printWrites(memory memoryRange: ClosedRange<UInt16>, b: Data, a: Data) {
    for address in memoryRange {
      let index = address - memoryRange.start
      let bv = b[index]
      let av = a[index]

      if bv != av { print("  > memory \(address.hex): \(bv) -> \(av)") }
    }
  }

  private func printWrites(b: [UInt16:UInt8], a: [UInt16:UInt8]) {
    var addresses = Set<UInt16>()
    b.keys.forEach { addresses.insert($0) }
    a.keys.forEach { addresses.insert($0) }

    for address in addresses {
      let bv = b[address]
      let av = a[address]
      if bv != av { print("  > memory \(address.hex): \(bv ?? 0) -> \(av ?? 0)") }
    }
  }
}
