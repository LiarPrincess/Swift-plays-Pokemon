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
    bootrom.data[range.start] = startValue
    bootrom.data[range.end]   = endValue

    let memory = self.createMemory(bootrom: bootrom)
    // 'memory.hasFinishedBootrom' should be false by default

    XCTAssertEqual(memory.read(range.start), startValue)
    XCTAssertEqual(memory.read(range.end), endValue)
  }

  func test_rom0() {
    let range = MemoryMap.rom0

    let cartridge = FakeCartridgeMemory()
    cartridge.rom[range.start] = startValue
    cartridge.rom[range.end]   = endValue

    let memory = self.createMemory(cartridge: cartridge)
    memory.bootrom = .finished

    XCTAssertEqual(memory.read(range.start), startValue)
    XCTAssertEqual(memory.read(range.end), endValue)
  }

  func test_rom1() {
    let range = MemoryMap.rom1

    let cartridge = FakeCartridgeMemory()
    cartridge.rom[range.start] = startValue
    cartridge.rom[range.end]   = endValue

    let memory = self.createMemory(cartridge: cartridge)
    memory.bootrom = .finished

    XCTAssertEqual(memory.read(range.start), startValue)
    XCTAssertEqual(memory.read(range.end), endValue)
  }

  func test_videoRam() {
    let memory = self.createMemory()
    self.fill(&memory.lcd.videoRam)

    let range = MemoryMap.videoRam
    self.testStartValue(memory, range)
    self.testEndValue(memory, range)
  }

  func test_externalRam() {
    let cartridge = FakeCartridgeMemory()
    let memory = self.createMemory(cartridge: cartridge)
    self.fill(&cartridge.ram)

    let range = MemoryMap.externalRam
    self.testStartValue(memory, range)
    self.testEndValue(memory, range)
  }

  func test_internalRam() {
    let memory = self.createMemory()
    self.fill(&memory.ram)

    let range = MemoryMap.internalRam
    self.testStartValue(memory, range)
    self.testEndValue(memory, range)
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
    let memory = self.createMemory()
    self.fill(&memory.lcd.oam)

    let range = MemoryMap.oam
    self.testStartValue(memory, range)
    self.testEndValue(memory, range)
  }

  func test_joypadMemory() {
    let memory = self.createMemory()
    memory.joypad.value = 5
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
    let memory = self.createMemory()

    memory.timer.div = 5 // write will reset it to 0
    XCTAssertEqual(memory.read(MemoryMap.Timer.div), 0)

    memory.timer.tima = 5
    XCTAssertEqual(memory.read(MemoryMap.Timer.tima), 5)

    memory.timer.tma = 6
    XCTAssertEqual(memory.read(MemoryMap.Timer.tma), 6)

    memory.timer.tac = 7
    XCTAssertEqual(memory.read(MemoryMap.Timer.tac), 7)
  }

  // swiftlint:disable:next function_body_length
  func test_lcdMemory() {
    let memory = self.createMemory()
    var value: UInt8 = 0

    memory.lcd.control.value = value
    XCTAssertEqual(memory.read(MemoryMap.Lcd.control), value)
    value += 1

    memory.lcd.status.value = value
    XCTAssertEqual(memory.read(MemoryMap.Lcd.status), value)
    value += 1

    memory.lcd.scrollY = value
    XCTAssertEqual(memory.read(MemoryMap.Lcd.scrollY), value)
    value += 1

    memory.lcd.scrollX = value
    XCTAssertEqual(memory.read(MemoryMap.Lcd.scrollX), value)
    value += 1

    memory.lcd.line = value
    XCTAssertEqual(memory.read(MemoryMap.Lcd.line), 0) // reset on write
    value += 1

    memory.lcd.lineCompare = value
    XCTAssertEqual(memory.read(MemoryMap.Lcd.lineCompare), value)
    value += 1

    memory.lcd.windowY = value
    XCTAssertEqual(memory.read(MemoryMap.Lcd.windowY), value)
    value += 1

    memory.lcd.windowX = value
    XCTAssertEqual(memory.read(MemoryMap.Lcd.windowX), value)
    value += 1

    memory.lcd.backgroundColors.value = value
    XCTAssertEqual(memory.read(MemoryMap.Lcd.backgroundColors), value)
    value += 1

    // 2 last bits are always 0
    memory.lcd.objectColors0.value = value
    XCTAssertEqual(memory.read(MemoryMap.Lcd.objectColors0), value)
    value += 1

    // 2 last bits are always 0
    memory.lcd.objectColors1.value = value
    XCTAssertEqual(memory.read(MemoryMap.Lcd.objectColors1), value)
    value += 1
  }

  func test_highRam() {
    let memory = self.createMemory()
    self.fill(&memory.highRam)

    let range = MemoryMap.highRam
    self.testStartValue(memory, range)
    self.testEndValue(memory, range)
  }

  func test_interrupts() {
    let interrupts = Interrupts()
    let memory = self.createMemory(interrupts: interrupts)

    interrupts.enable = 5
    XCTAssertEqual(memory.read(MemoryMap.interruptEnable), 5)

    interrupts.flag = 6
    XCTAssertEqual(memory.read(MemoryMap.IO.interruptFlag), 6)
  }

  // MARK: - Helpers

  private func fill(_ data: inout Data) {
    data[data.startIndex]   = startValue
    data[data.endIndex - 1] = endValue
  }

  private func testStartValue(_ memory: Memory,
                              _ range:  ClosedRange<UInt16>,
                              file:     StaticString = #file,
                              line:     UInt = #line) {

    let value = memory.read(range.start)
    XCTAssertEqual(value, startValue, file: file, line: line)
  }

  private func testEndValue(_ memory: Memory,
                            _ range:  ClosedRange<UInt16>,
                            file:     StaticString = #file,
                            line:     UInt = #line) {

    let value = memory.read(range.end)
    XCTAssertEqual(value, endValue, file: file, line: line)
  }
}
