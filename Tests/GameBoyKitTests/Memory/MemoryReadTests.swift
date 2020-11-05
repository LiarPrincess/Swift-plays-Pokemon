// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import GameBoyKit

class MemoryReadTests: XCTestCase {

  private let startValue: UInt8 = 5
  private let endValue:   UInt8 = 6

  func test_bootrom() {
    let range = MemoryMap.bootrom

    let bootrom = FakeBootromMemory()
    bootrom.data[0] = startValue
    bootrom.data[range.count - 1]   = endValue

    let memory = self.createMemory(bootrom: bootrom)
    // 'memory.hasFinishedBootrom' should be false by default

    XCTAssertEqual(memory.read(range.start), startValue)
    XCTAssertEqual(memory.read(range.end), endValue)
  }

  func test_rom0() {
    let range = MemoryMap.rom0

    let cartridge = FakeCartridgeMemory()
    cartridge.rom[0] = startValue
    cartridge.rom[range.count - 1]   = endValue

    let memory = self.createMemory(cartridge: cartridge)
    memory.bootrom = .finished

    XCTAssertEqual(memory.read(range.start), startValue)
    XCTAssertEqual(memory.read(range.end), endValue)
  }

  func test_rom1() {
    let range = MemoryMap.rom1
    let rangeStart = Int(range.start)

    let cartridge = FakeCartridgeMemory()
    cartridge.rom[rangeStart + 0] = startValue
    cartridge.rom[rangeStart + range.count - 1] = endValue

    let memory = self.createMemory(cartridge: cartridge)
    memory.bootrom = .finished

    XCTAssertEqual(memory.read(range.start), startValue)
    XCTAssertEqual(memory.read(range.end), endValue)
  }

  func test_videoRam() {
    let lcd = FakeLcd()
    let memory = self.createMemory(lcd: lcd)

    let range = MemoryMap.videoRam
    lcd.videoRam[range.start] = startValue
    lcd.videoRam[range.end]   = endValue

    XCTAssertEqual(memory.read(range.start), startValue)
    XCTAssertEqual(memory.read(range.end), endValue)
  }

  func test_externalRam() {
    let cartridge = FakeCartridgeMemory()
    let memory = self.createMemory(cartridge: cartridge)

    let range = MemoryMap.externalRam
    cartridge.ram[0] = startValue
    cartridge.ram[range.count - 1]   = endValue

    XCTAssertEqual(memory.read(range.start), startValue)
    XCTAssertEqual(memory.read(range.end), endValue)
  }

  func test_internalRam() {
    let memory = self.createMemory()

    let range = MemoryMap.internalRam
    memory.ram[0] = startValue
    memory.ram[range.count - 1]   = endValue

    XCTAssertEqual(memory.read(range.start), startValue)
    XCTAssertEqual(memory.read(range.end), endValue)
  }

  func test_internalRamEcho() {
    let memory = self.createMemory()
    let range = MemoryMap.internalRamEcho

    memory.ram[memory.ram.startIndex] = startValue
    memory.ram[memory.ram.startIndex + range.count - 1] = endValue

    XCTAssertEqual(memory.read(range.start), startValue)
    XCTAssertEqual(memory.read(range.end), endValue)
  }

  func test_oam() {
    let lcd = FakeLcd()
    let memory = self.createMemory(lcd: lcd)

    let range = MemoryMap.oam
    lcd.oam[range.start] = startValue
    lcd.oam[range.end]   = endValue

    XCTAssertEqual(memory.read(range.start), startValue)
    XCTAssertEqual(memory.read(range.end), endValue)
  }

  func test_joypadMemory() {
    let joypad = FakeJoypad()
    let memory = self.createMemory(joypad: joypad)

    joypad.value = 5
    XCTAssertEqual(memory.read(MemoryMap.IO.joypad), 5)
  }

  func test_serialPortMemory() {
    let memory = self.createMemory()

    memory.serialPort.sb = 5
    XCTAssertEqual(memory.read(MemoryMap.IO.sb), 5)

    memory.serialPort.sc = 6
    XCTAssertEqual(memory.read(MemoryMap.IO.sc), 6)
  }

  func test_timer() {
    let timer  = FakeTimerMemory()
    let memory = self.createMemory(timer: timer)

    timer.div = 4
    XCTAssertEqual(memory.read(MemoryMap.Timer.div), 4)

    timer.tima = 5
    XCTAssertEqual(memory.read(MemoryMap.Timer.tima), 5)

    timer.tma = 6
    XCTAssertEqual(memory.read(MemoryMap.Timer.tma), 6)

    timer.tac = 7
    XCTAssertEqual(memory.read(MemoryMap.Timer.tac), 7)
  }

  // swiftlint:disable:next function_body_length
  func test_lcdMemory() {
    let lcd    = FakeLcd()
    let memory = self.createMemory(lcd: lcd)

    var value: UInt8 = 0

    lcd.control = value
    XCTAssertEqual(memory.read(MemoryMap.Lcd.control), value)
    value += 1

    lcd.status = value
    XCTAssertEqual(memory.read(MemoryMap.Lcd.status), value)
    value += 1

    lcd.scrollY = value
    XCTAssertEqual(memory.read(MemoryMap.Lcd.scrollY), value)
    value += 1

    lcd.scrollX = value
    XCTAssertEqual(memory.read(MemoryMap.Lcd.scrollX), value)
    value += 1

    lcd.line = value
    XCTAssertEqual(memory.read(MemoryMap.Lcd.line), value)
    value += 1

    lcd.lineCompare = value
    XCTAssertEqual(memory.read(MemoryMap.Lcd.lineCompare), value)
    value += 1

    lcd.windowY = value
    XCTAssertEqual(memory.read(MemoryMap.Lcd.windowY), value)
    value += 1

    lcd.windowX = value
    XCTAssertEqual(memory.read(MemoryMap.Lcd.windowX), value)
    value += 1

    lcd.backgroundPalette = value
    XCTAssertEqual(memory.read(MemoryMap.Lcd.backgroundPalette), value)
    value += 1

    // 2 last bits are always 0
    lcd.spritePalette0 = value
    XCTAssertEqual(memory.read(MemoryMap.Lcd.spritePalette0), value)
    value += 1

    // 2 last bits are always 0
    lcd.spritePalette1 = value
    XCTAssertEqual(memory.read(MemoryMap.Lcd.spritePalette1), value)
    value += 1
  }

  func test_highRam() {
    let memory = self.createMemory()

    let range = MemoryMap.highRam
    memory.highRam[0] = startValue
    memory.highRam[range.count - 1]   = endValue

    XCTAssertEqual(memory.read(range.start), startValue)
    XCTAssertEqual(memory.read(range.end), endValue)
  }

  func test_interrupts() {
    let interrupts = Interrupts()
    let memory = self.createMemory(interrupts: interrupts)

    interrupts.enable = 5
    XCTAssertEqual(memory.read(MemoryMap.interruptEnable), 5)

    interrupts.flag = 6
    XCTAssertEqual(memory.read(MemoryMap.IO.interruptFlag), 6)
  }
}
