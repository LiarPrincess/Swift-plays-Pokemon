// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import GameBoyKit

class BusReadTests: XCTestCase {

  private let startValue: UInt8 = 5
  private let endValue:   UInt8 = 6

  func test_bootrom() {
    let range = MemoryMap.bootrom

    let bootrom = FakeBusBootrom()
    bootrom.data[range.start] = startValue
    bootrom.data[range.end]   = endValue

    let bus = self.createBus(bootrom: bootrom)
    // 'bus.hasFinishedBootrom' should be false by default

    XCTAssertEqual(bus.read(range.start), startValue)
    XCTAssertEqual(bus.read(range.end), endValue)
  }

  func test_rom0() {
    let range = MemoryMap.rom0

    let cartridge = FakeBusCartridge()
    cartridge.rom[range.start] = startValue
    cartridge.rom[range.end]   = endValue

    let bus = self.createBus(cartridge: cartridge)
    bus.unmapBootrom = 0x01

    XCTAssertEqual(bus.read(range.start), startValue)
    XCTAssertEqual(bus.read(range.end), endValue)
  }

  func test_rom1() {
    let range = MemoryMap.rom1

    let cartridge = FakeBusCartridge()
    cartridge.rom[range.start] = startValue
    cartridge.rom[range.end]   = endValue

    let bus = self.createBus(cartridge: cartridge)
    bus.unmapBootrom = 0x01

    XCTAssertEqual(bus.read(range.start), startValue)
    XCTAssertEqual(bus.read(range.end), endValue)
  }

  func test_videoRam() {
    let bus = self.createBus()
    self.fill(&bus.lcd.videoRam)

    let range = MemoryMap.videoRam
    self.testStartValue(bus, range)
    self.testEndValue(bus, range)
  }

  func test_externalRam() {
    let cartridge = FakeBusCartridge()
    let bus = self.createBus(cartridge: cartridge)
    self.fill(&cartridge.ram)

    let range = MemoryMap.externalRam
    self.testStartValue(bus, range)
    self.testEndValue(bus, range)
  }

  func test_internalRam() {
    let bus = self.createBus()
    self.fill(&bus.ram)

    let range = MemoryMap.internalRam
    self.testStartValue(bus, range)
    self.testEndValue(bus, range)
  }

  func test_internalRamEcho() {
    let bus = self.createBus()
    let range = MemoryMap.internalRamEcho

    bus.ram[bus.ram.startIndex] = startValue
    bus.ram[bus.ram.startIndex + range.count - 1] = endValue

    XCTAssertEqual(bus.read(range.start), startValue)
    XCTAssertEqual(bus.read(range.end), endValue)
  }

  func test_oam() {
    let bus = self.createBus()
    self.fill(&bus.lcd.oam)

    let range = MemoryMap.oam
    self.testStartValue(bus, range)
    self.testEndValue(bus, range)
  }

  func test_joypadMemory() {
    let bus = self.createBus()
    bus.joypad.value = 5
    XCTAssertEqual(bus.read(MemoryMap.IO.joypad), 5)
  }

  func test_serialPortMemory() {
    let bus = self.createBus()

    bus.serialPort.sb = 5
    XCTAssertEqual(bus.read(MemoryMap.IO.sb), 5)

    bus.serialPort.sc = 6
    XCTAssertEqual(bus.read(MemoryMap.IO.sc), 6)
  }

  func test_timer() {
    let bus = self.createBus()

    bus.timer.div = 5 // write will reset it to 0
    XCTAssertEqual(bus.read(MemoryMap.Timer.div), 0)

    bus.timer.tima = 5
    XCTAssertEqual(bus.read(MemoryMap.Timer.tima), 5)

    bus.timer.tma = 6
    XCTAssertEqual(bus.read(MemoryMap.Timer.tma), 6)

    bus.timer.tac = 7
    XCTAssertEqual(bus.read(MemoryMap.Timer.tac), 7)
  }

  // swiftlint:disable:next function_body_length
  func test_lcdMemory() {
    let bus = self.createBus()
    var value: UInt8 = 0

    bus.lcd.control.value = value
    XCTAssertEqual(bus.read(MemoryMap.Lcd.control), value)
    value += 1

    bus.lcd.status.value = value
    XCTAssertEqual(bus.read(MemoryMap.Lcd.status), value)
    value += 1

    bus.lcd.scrollY = value
    XCTAssertEqual(bus.read(MemoryMap.Lcd.scrollY), value)
    value += 1

    bus.lcd.scrollX = value
    XCTAssertEqual(bus.read(MemoryMap.Lcd.scrollX), value)
    value += 1

    bus.lcd.line = value
    XCTAssertEqual(bus.read(MemoryMap.Lcd.line), value)
    value += 1

    bus.lcd.lineCompare = value
    XCTAssertEqual(bus.read(MemoryMap.Lcd.lineCompare), value)
    value += 1

    bus.lcd.windowY = value
    XCTAssertEqual(bus.read(MemoryMap.Lcd.windowY), value)
    value += 1

    bus.lcd.windowX = value
    XCTAssertEqual(bus.read(MemoryMap.Lcd.windowX), value)
    value += 1

    bus.lcd.backgroundColors.value = value
    XCTAssertEqual(bus.read(MemoryMap.Lcd.backgroundColors), value)
    value += 1

    // 2 last bits are always 0
    bus.lcd.objectColors0.value = value
    XCTAssertEqual(bus.read(MemoryMap.Lcd.objectColors0), value & 0xfc)
    value += 1

    // 2 last bits are always 0
    bus.lcd.objectColors1.value = value
    XCTAssertEqual(bus.read(MemoryMap.Lcd.objectColors1), value & 0xfc)
    value += 1
  }

  func test_highRam() {
    let bus = self.createBus()
    self.fill(&bus.highRam)

    let range = MemoryMap.highRam
    self.testStartValue(bus, range)
    self.testEndValue(bus, range)
  }

  func test_interrupts() {
    let interrupts = Interrupts()
    let bus = self.createBus(interrupts: interrupts)

    interrupts.enable = 5
    XCTAssertEqual(bus.read(MemoryMap.interruptEnable), 5)

    interrupts.flag = 6
    XCTAssertEqual(bus.read(MemoryMap.IO.interruptFlag), 6)
  }

  // MARK: - Helpers

  private func fill(_ data: inout Data) {
    data[data.startIndex]   = startValue
    data[data.endIndex - 1] = endValue
  }

  private func testStartValue(_ bus:   Bus,
                              _ range: ClosedRange<UInt16>,
                              file:    StaticString = #file,
                              line:    UInt = #line) {

    let value = bus.read(range.start)
    XCTAssertEqual(value, startValue, file: file, line: line)
  }

  private func testEndValue(_ bus:   Bus,
                            _ range: ClosedRange<UInt16>,
                            file:    StaticString = #file,
                            line:    UInt = #line) {

    let value = bus.read(range.end)
    XCTAssertEqual(value, endValue, file: file, line: line)
  }
}
