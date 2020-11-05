// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import GameBoyKit

class MemoryWriteTests: XCTestCase {

  private let startValue: UInt8 = 5
  private let endValue:   UInt8 = 6

  func test_bootrom() {
    let range = MemoryMap.bootrom

    let bootrom = FakeBootromMemory()
    let cartridge = FakeCartridgeMemory()
    let memory = self.createMemory(bootrom: bootrom, cartridge: cartridge)

    // 'memory.hasFinishedBootrom' should be false by default

    memory.write(range.start, value: startValue)
    XCTAssertEqual(bootrom.data.first, startValue)
    XCTAssertEqual(cartridge.rom[MemoryMap.rom0.start], 0)

    memory.write(range.end, value: endValue)
    XCTAssertEqual(bootrom.data.last, endValue)
    XCTAssertEqual(cartridge.rom[MemoryMap.rom0.end], 0)
  }

  func test_rom0() {
    let range = MemoryMap.rom0

    let cartridge = FakeCartridgeMemory()
    let memory = self.createMemory(cartridge: cartridge)

    memory.bootrom = .finished

    memory.write(range.start, value: startValue)
    XCTAssertEqual(cartridge.rom[MemoryMap.rom0.start], startValue)

    memory.write(range.end, value: endValue)
    XCTAssertEqual(cartridge.rom[MemoryMap.rom0.end], endValue)
  }

  func test_rom1() {
    let range = MemoryMap.rom1

    let cartridge = FakeCartridgeMemory()
    let memory = self.createMemory(cartridge: cartridge)

    memory.write(range.start, value: startValue)
    XCTAssertEqual(cartridge.rom[MemoryMap.rom1.start], startValue)

    memory.write(range.end, value: endValue)
    XCTAssertEqual(cartridge.rom[MemoryMap.rom1.end], endValue)
  }

  func test_videoRam() {
    let lcd = FakeLcd()
    let memory = self.createMemory(lcd: lcd)

    let range = MemoryMap.videoRam
    memory.write(range.start, value: startValue)
    memory.write(range.end, value: endValue)

    XCTAssertEqual(lcd.videoRam[range.start], startValue)
    XCTAssertEqual(lcd.videoRam[range.end], endValue)
  }

  func test_externalRam() {
    let cartridge = FakeCartridgeMemory()
    let memory = self.createMemory(cartridge: cartridge)

    let range = MemoryMap.externalRam
    memory.write(range.start, value: startValue)
    memory.write(range.end, value: endValue)

    XCTAssertEqual(cartridge.ram[0], startValue)
    XCTAssertEqual(cartridge.ram[range.count - 1], endValue)
  }

  func test_internalRam() {
    let memory = self.createMemory()

    let range = MemoryMap.internalRam
    memory.write(range.start, value: startValue)
    memory.write(range.end, value: endValue)

    XCTAssertEqual(memory.ram[0], startValue)
    XCTAssertEqual(memory.ram[range.count - 1], endValue)
  }

  func test_echoMemory() {
    let memory = self.createMemory()
    let range = MemoryMap.internalRamEcho

    memory.write(range.start, value:  startValue)
    memory.write(range.end,   value:  endValue)

    XCTAssertEqual(memory.ram[0],  startValue)
    XCTAssertEqual(memory.ram[range.count - 1], endValue)
  }

  func test_oam() {
    let lcd = FakeLcd()
    let memory = self.createMemory(lcd: lcd)

    let range = MemoryMap.oam
    memory.write(range.start, value: startValue)
    memory.write(range.end, value: endValue)

    XCTAssertEqual(lcd.oam[range.start], startValue)
    XCTAssertEqual(lcd.oam[range.end], endValue)
  }

  func test_joypadMemory() {
    let memory = self.createMemory()
    memory.write(MemoryMap.IO.joypad, value: 5)
    XCTAssertEqual(memory.joypad.value, 5)
  }

  func test_serialPortMemory() {
    let memory = self.createMemory()

    memory.write(MemoryMap.IO.sb, value: 5)
    XCTAssertEqual(memory.serialPort.sb, 5)

    memory.write(MemoryMap.IO.sc, value: 6)
    XCTAssertEqual(memory.serialPort.sc, 6)
  }

  func test_timer() {
    let timer  = FakeTimerMemory()
    let memory = self.createMemory(timer: timer)

    memory.write(MemoryMap.Timer.div, value: 4)
    XCTAssertEqual(timer.div, 4)

    memory.write(MemoryMap.Timer.tima, value: 5)
    XCTAssertEqual(timer.tima, 5)

    memory.write(MemoryMap.Timer.tma, value: 6)
    XCTAssertEqual(timer.tma, 6)

    memory.write(MemoryMap.Timer.tac, value: 7)
    XCTAssertEqual(timer.tac, 7)
  }

  // swiftlint:disable:next function_body_length
  func test_lcdMemory() {
    let lcd    = FakeLcd()
    let memory = self.createMemory(lcd: lcd)

    var value: UInt8 = 5

    memory.write(MemoryMap.Lcd.control, value: value)
    XCTAssertEqual(lcd.control.value, value)
    value += 1

    memory.write(MemoryMap.Lcd.status, value: value)
    XCTAssertEqual(lcd.status.value, value)
    value += 1

    memory.write(MemoryMap.Lcd.scrollY, value: value)
    XCTAssertEqual(lcd.scrollY, value)
    value += 1

    memory.write(MemoryMap.Lcd.scrollX, value: value)
    XCTAssertEqual(lcd.scrollX, value)
    value += 1

    memory.write(MemoryMap.Lcd.line, value: value)
    XCTAssertEqual(lcd.line, value) // reset on write
    value += 1

    memory.write(MemoryMap.Lcd.lineCompare, value: value)
    XCTAssertEqual(lcd.lineCompare, value)
    value += 1

    memory.write(MemoryMap.Lcd.windowY, value: value)
    XCTAssertEqual(lcd.windowY, value)
    value += 1

    memory.write(MemoryMap.Lcd.windowX, value: value)
    XCTAssertEqual(lcd.windowX, value)
    value += 1

    memory.write(MemoryMap.Lcd.backgroundPalette, value: value)
    XCTAssertEqual(lcd.backgroundColorPalette.value, value)
    value += 1

    // 2 last bits are always 0
    memory.write(MemoryMap.Lcd.spritePalette0, value: value)
    XCTAssertEqual(lcd.spriteColorPalette0.value, value)
    value += 1

    // 2 last bits are always 0
    memory.write(MemoryMap.Lcd.spritePalette1, value: value)
    XCTAssertEqual(lcd.spriteColorPalette1.value, value)
    value += 1
  }

  func test_highRam() {
    let memory = self.createMemory()

    let range = MemoryMap.highRam
    memory.write(range.start, value: startValue)
    memory.write(range.end, value: endValue)

    XCTAssertEqual(memory.highRam[0], startValue)
    XCTAssertEqual(memory.highRam[range.count - 1], endValue)
  }

  func test_interrupts() {
    let interrupts = Interrupts()
    let memory = self.createMemory(interrupts: interrupts)

    memory.write(MemoryMap.interruptEnable, value: 5)
    memory.write(MemoryMap.IO.interruptFlag, value: 6)

    XCTAssertEqual(interrupts.enable, 5)
    XCTAssertEqual(interrupts.flag, 6)
  }
}
