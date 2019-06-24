// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import GameBoyKit

class WriteTests: XCTestCase {

  private static let startValue: UInt8 = 5
  private static let endValue:   UInt8 = 6

  /// 'bootrom' is read only
  func test_bootrom() {
    let bus = self.createBus()
    let range = MemoryMap.bootrom

    // 'bus.hasFinishedBootrom' should be false by default

    bus.write(range.start, value: 5)
    XCTAssertEqual(bus.bootrom.data.first, 0)
    XCTAssertEqual(bus.cartridge.rom0.first, 0)

    bus.write(range.end, value: 6)
    XCTAssertEqual(bus.bootrom.data.last, 0)
    XCTAssertEqual(bus.cartridge.rom0.last, 0)
  }

  /// 'rom0' is read only
  func test_rom0() {
    let bus = self.createBus()
    let range = MemoryMap.rom0

    bus.hasFinishedBootrom = true

    bus.write(range.start, value: 5)
    XCTAssertEqual(bus.cartridge.rom0.first, 0)

    bus.write(range.end, value: 6)
    XCTAssertEqual(bus.cartridge.rom0.last, 0)
  }

  /// 'rom1' is read only
  func test_rom1() {
    let bus = self.createBus()
    let range = MemoryMap.rom1

    bus.write(range.start, value: 5)
    XCTAssertEqual(bus.cartridge.rom1.first, 0)

    bus.write(range.end, value: 6)
    XCTAssertEqual(bus.cartridge.rom1.last, 0)
  }

  func test_videoRam() {
    let bus = self.createBus()
    self.write(bus, MemoryMap.videoRam)

    let data = bus.lcd.videoRam
    self.testStartValue(data)
    self.testEndValue(data)
  }

  func test_externalRam() {
    let bus = self.createBus()
    self.write(bus, MemoryMap.externalRam)

    let data = bus.cartridge.ram
    self.testStartValue(data)
    self.testEndValue(data)
  }

  func test_internalRam() {
    let bus = self.createBus()
    self.write(bus, MemoryMap.internalRam)

    let data = bus.ram
    self.testStartValue(data)
    self.testEndValue(data)
  }

  func test_echoMemory() {
    let bus = self.createBus()
    let range = MemoryMap.internalRamEcho

    bus.write(range.start, value: WriteTests.startValue)
    bus.write(range.end,   value: WriteTests.endValue)

    XCTAssertEqual(bus.ram[0], WriteTests.startValue)
    XCTAssertEqual(bus.ram[range.count - 1], WriteTests.endValue)
  }

  func test_oam() {
    let bus = self.createBus()
    self.write(bus, MemoryMap.oam)

    let data = bus.lcd.oam
    self.testStartValue(data)
    self.testEndValue(data)
  }

  func test_joypadMemory() {
    let bus = self.createBus()
    bus.write(MemoryMap.IO.joypad, value: 5)
    XCTAssertEqual(bus.joypad.value, 5)
  }

  func test_serialPortMemory() {
    let bus = self.createBus()

    bus.write(MemoryMap.IO.sb, value: 5)
    XCTAssertEqual(bus.serialPort.sb, 5)

    bus.write(MemoryMap.IO.sc, value: 6)
    XCTAssertEqual(bus.serialPort.sc, 6)
  }

  func test_timer() {
    let bus = self.createBus()

    bus.write(MemoryMap.Timer.div, value: 4)
    XCTAssertEqual(bus.timer.div, 0) // should reset on write

    bus.write(MemoryMap.Timer.tima, value: 5)
    XCTAssertEqual(bus.timer.tima, 5)

    bus.write(MemoryMap.Timer.tma, value: 6)
    XCTAssertEqual(bus.timer.tma, 6)

    bus.write(MemoryMap.Timer.tac, value: 7)
    XCTAssertEqual(bus.timer.tac, 7)
  }

  // swiftlint:disable:next function_body_length
  func test_lcdMemory() {
    let bus = self.createBus()
    var value: UInt8 = 5

    bus.write(MemoryMap.Lcd.control, value: value)
    XCTAssertEqual(bus.lcd.control.value, value)
    value += 1

    bus.write(MemoryMap.Lcd.status, value: value)
    XCTAssertEqual(bus.lcd.status.value, value)
    value += 1

    bus.write(MemoryMap.Lcd.scrollY, value: value)
    XCTAssertEqual(bus.lcd.scrollY, value)
    value += 1

    bus.write(MemoryMap.Lcd.scrollX, value: value)
    XCTAssertEqual(bus.lcd.scrollX, value)
    value += 1

    bus.write(MemoryMap.Lcd.line, value: value)
    XCTAssertEqual(bus.lcd.line, value)
    value += 1

    bus.write(MemoryMap.Lcd.lineCompare, value: value)
    XCTAssertEqual(bus.lcd.lineCompare, value)
    value += 1

    bus.write(MemoryMap.Lcd.windowY, value: value)
    XCTAssertEqual(bus.lcd.windowY, value)
    value += 1

    bus.write(MemoryMap.Lcd.windowX, value: value)
    XCTAssertEqual(bus.lcd.windowX, value)
    value += 1

    bus.write(MemoryMap.Lcd.backgroundColors, value: value)
    XCTAssertEqual(bus.lcd.backgroundColors.value, value)
    value += 1

    // 2 last bits are always 0
    bus.write(MemoryMap.Lcd.objectColors0, value: value)
    XCTAssertEqual(bus.lcd.objectColors0.value, value & 0xfc)
    value += 1

    // 2 last bits are always 0
    bus.write(MemoryMap.Lcd.objectColors1, value: value)
    XCTAssertEqual(bus.lcd.objectColors1.value, value & 0xfc)
    value += 1
  }

  func test_highRam() {
    let bus = self.createBus()
    self.write(bus, MemoryMap.highRam)

    let data = bus.highRam
    self.testStartValue(data)
    self.testEndValue(data)
  }

  func test_interrupts() {
    let bus = self.createBus()
    bus.write(MemoryMap.interruptEnable, value: 6)
    XCTAssertEqual(bus.interruptEnable.value, 6)
  }

  // MARK: - Helpers

  private func write(_ bus: Bus, _ range: ClosedRange<UInt16>) {
    bus.write(range.start, value: WriteTests.startValue)
    bus.write(range.end,   value: WriteTests.endValue)
  }

  private func testStartValue(_ data: Data,
                              file:   StaticString = #file,
                              line:   UInt = #line) {

    let value = data[data.startIndex]
    XCTAssertEqual(value, WriteTests.startValue, file: file, line: line)
  }

  private func testEndValue(_ data: Data,
                            file:   StaticString = #file,
                            line:   UInt = #line) {

    let value = data[data.endIndex - 1]
    XCTAssertEqual(value, WriteTests.endValue, file: file, line: line)
  }
}
