// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import GameBoyKit

class BusWriteTests: XCTestCase {

  private let startValue: UInt8 = 5
  private let endValue:   UInt8 = 6

  func test_bootrom() {
    let range = MemoryMap.bootrom

    let bootrom = FakeBusBootrom()
    let cartridge = FakeBusCartridge()
    let bus = self.createBus(bootrom: bootrom, cartridge: cartridge)

    // 'bus.hasFinishedBootrom' should be false by default

    bus.write(range.start, value: startValue)
    XCTAssertEqual(bootrom.data.first, startValue)
    XCTAssertEqual(cartridge.rom[MemoryMap.rom0.start], 0)

    bus.write(range.end, value: endValue)
    XCTAssertEqual(bootrom.data.last, endValue)
    XCTAssertEqual(cartridge.rom[MemoryMap.rom0.end], 0)
  }

  func test_rom0() {
    let range = MemoryMap.rom0

    let cartridge = FakeBusCartridge()
    let bus = self.createBus(cartridge: cartridge)

    bus.hasFinishedBootrom = true

    bus.write(range.start, value: startValue)
    XCTAssertEqual(cartridge.rom[MemoryMap.rom0.start], startValue)

    bus.write(range.end, value: endValue)
    XCTAssertEqual(cartridge.rom[MemoryMap.rom0.end], endValue)
  }

  func test_rom1() {
    let range = MemoryMap.rom1

    let cartridge = FakeBusCartridge()
    let bus = self.createBus(cartridge: cartridge)

    bus.write(range.start, value: startValue)
    XCTAssertEqual(cartridge.rom[MemoryMap.rom1.start], startValue)

    bus.write(range.end, value: endValue)
    XCTAssertEqual(cartridge.rom[MemoryMap.rom1.end], endValue)
  }

  func test_videoRam() {
    let bus = self.createBus()
    self.write(bus, MemoryMap.videoRam)

    let data = bus.lcd.videoRam
    self.testStartValue(data)
    self.testEndValue(data)
  }

  func test_externalRam() {
    let cartridge = FakeBusCartridge()
    let bus = self.createBus(cartridge: cartridge)

    self.write(bus, MemoryMap.externalRam)

    self.testStartValue(cartridge.ram)
    self.testEndValue(cartridge.ram)
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

    bus.write(range.start, value:  startValue)
    bus.write(range.end,   value:  endValue)

    XCTAssertEqual(bus.ram[0],  startValue)
    XCTAssertEqual(bus.ram[range.count - 1], endValue)
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
    let interrupts = Interrupts()
    let bus = self.createBus(interrupts: interrupts)

    bus.write(MemoryMap.interruptEnable, value: 5)
    bus.write(MemoryMap.IO.interruptFlag, value: 6)

    XCTAssertEqual(interrupts.enable, 5)
    XCTAssertEqual(interrupts.flag, 6)
  }

  // MARK: - Helpers

  private func write(_ bus: Bus, _ range: ClosedRange<UInt16>) {
    bus.write(range.start, value:  startValue)
    bus.write(range.end,   value:  endValue)
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
