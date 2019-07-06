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
    let memory = self.createMemory()
    self.write(memory, MemoryMap.videoRam)

    let data = memory.lcd.videoRam
    self.testStartValue(data)
    self.testEndValue(data)
  }

  func test_externalRam() {
    let cartridge = FakeCartridgeMemory()
    let memory = self.createMemory(cartridge: cartridge)

    self.write(memory, MemoryMap.externalRam)

    self.testStartValue(cartridge.ram)
    self.testEndValue(cartridge.ram)
  }

  func test_internalRam() {
    let memory = self.createMemory()
    self.write(memory, MemoryMap.internalRam)

    let data = memory.ram
    self.testStartValue(data)
    self.testEndValue(data)
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
    let memory = self.createMemory()
    self.write(memory, MemoryMap.oam)

    let data = memory.lcd.oam
    self.testStartValue(data)
    self.testEndValue(data)
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
    let memory = self.createMemory()

    memory.write(MemoryMap.Timer.div, value: 4)
    XCTAssertEqual(memory.timer.div, 0) // should reset on write

    memory.write(MemoryMap.Timer.tima, value: 5)
    XCTAssertEqual(memory.timer.tima, 5)

    memory.write(MemoryMap.Timer.tma, value: 6)
    XCTAssertEqual(memory.timer.tma, 6)

    memory.write(MemoryMap.Timer.tac, value: 7)
    XCTAssertEqual(memory.timer.tac, 7)
  }

  // swiftlint:disable:next function_body_length
  func test_lcdMemory() {
    let memory = self.createMemory()
    var value: UInt8 = 5

    memory.write(MemoryMap.Lcd.control, value: value)
    XCTAssertEqual(memory.lcd.control.value, value)
    value += 1

    memory.write(MemoryMap.Lcd.status, value: value)
    XCTAssertEqual(memory.lcd.status.value, value)
    value += 1

    memory.write(MemoryMap.Lcd.scrollY, value: value)
    XCTAssertEqual(memory.lcd.scrollY, value)
    value += 1

    memory.write(MemoryMap.Lcd.scrollX, value: value)
    XCTAssertEqual(memory.lcd.scrollX, value)
    value += 1

    memory.write(MemoryMap.Lcd.line, value: value)
    XCTAssertEqual(memory.lcd.line, value) // reset on write
    value += 1

    memory.write(MemoryMap.Lcd.lineCompare, value: value)
    XCTAssertEqual(memory.lcd.lineCompare, value)
    value += 1

    memory.write(MemoryMap.Lcd.windowY, value: value)
    XCTAssertEqual(memory.lcd.windowY, value)
    value += 1

    memory.write(MemoryMap.Lcd.windowX, value: value)
    XCTAssertEqual(memory.lcd.windowX, value)
    value += 1

    memory.write(MemoryMap.Lcd.backgroundColors, value: value)
    XCTAssertEqual(memory.lcd.backgroundColors.value, value)
    value += 1

    // 2 last bits are always 0
    memory.write(MemoryMap.Lcd.objectColors0, value: value)
    XCTAssertEqual(memory.lcd.objectColors0.value, value)
    value += 1

    // 2 last bits are always 0
    memory.write(MemoryMap.Lcd.objectColors1, value: value)
    XCTAssertEqual(memory.lcd.objectColors1.value, value)
    value += 1
  }

  func test_highRam() {
    let memory = self.createMemory()
    self.write(memory, MemoryMap.highRam)

    let data = memory.highRam
    self.testStartValue(data)
    self.testEndValue(data)
  }

  func test_interrupts() {
    let interrupts = Interrupts()
    let memory = self.createMemory(interrupts: interrupts)

    memory.write(MemoryMap.interruptEnable, value: 5)
    memory.write(MemoryMap.IO.interruptFlag, value: 6)

    XCTAssertEqual(interrupts.enable, 5)
    XCTAssertEqual(interrupts.flag, 6)
  }

  // MARK: - Helpers

  private func write(_ memory: Memory, _ range: ClosedRange<UInt16>) {
    memory.write(range.start, value:  startValue)
    memory.write(range.end,   value:  endValue)
  }

  private func testStartValue(_ data: Data,
                              file:   StaticString = #file,
                              line:   UInt = #line) {

    let value = data[data.startIndex]
    XCTAssertEqual(value,  startValue, file: file, line: line)
  }

  private func testEndValue(_ data: Data,
                            file:   StaticString = #file,
                            line:   UInt = #line) {

    let value = data[data.endIndex - 1]
    XCTAssertEqual(value,  endValue, file: file, line: line)
  }
}
