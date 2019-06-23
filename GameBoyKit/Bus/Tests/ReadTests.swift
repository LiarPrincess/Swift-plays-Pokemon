// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import GameBoyKit

class ReadTests: XCTestCase {

  private static let startValue: UInt8 = 5
  private static let endValue:   UInt8 = 6

  func test_bootrom() {
    let range = MemoryMap.rom0

    var data = Data(count: MemoryMap.rom0.count)
    data[range.start] = ReadTests.startValue
    data[range.end]   = ReadTests.endValue

    let bootrom = Bootrom(data: data)
    let bus = self.createBus(bootrom: bootrom)
    // 'bus.hasFinishedBootrom' should be false by default

    XCTAssertEqual(bus.read(range.start), ReadTests.startValue)
    XCTAssertEqual(bus.read(range.end), ReadTests.endValue)
  }

  func test_rom0() {
    let range = MemoryMap.rom0

    let dataSize = MemoryMap.rom0.count + MemoryMap.rom1.count
    var data = Data(count: dataSize)
    data[range.start] = ReadTests.startValue
    data[range.end]   = ReadTests.endValue

    let cartridge = Cartridge(data: data)
    let bus = self.createBus(cartridge: cartridge)
    bus.hasFinishedBootrom = true

    XCTAssertEqual(bus.read(range.start), ReadTests.startValue)
    XCTAssertEqual(bus.read(range.end), ReadTests.endValue)
  }

  func test_rom1() {
    let range = MemoryMap.rom1

    let dataSize = MemoryMap.rom0.count + MemoryMap.rom1.count
    var data = Data(count: dataSize)
    data[range.start] = ReadTests.startValue
    data[range.end]   = ReadTests.endValue

    let cartridge = Cartridge(data: data)
    let bus = self.createBus(cartridge: cartridge)
    bus.hasFinishedBootrom = true

    XCTAssertEqual(bus.read(range.start), ReadTests.startValue)
    XCTAssertEqual(bus.read(range.end), ReadTests.endValue)
  }

  func test_videoRam() {
    let bus = self.createBus()
    self.fill(&bus.lcd.videoRam)

    let range = MemoryMap.videoRam
    self.testStartValue(bus, range)
    self.testEndValue(bus, range)
  }

  func test_externalRam() {
    let bus = self.createBus()
    self.fill(&bus.cartridge.ram)

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

    bus.ram[bus.ram.startIndex] = ReadTests.startValue
    bus.ram[bus.ram.startIndex + range.count - 1] = ReadTests.endValue

    XCTAssertEqual(bus.read(range.start), ReadTests.startValue)
    XCTAssertEqual(bus.read(range.end), ReadTests.endValue)
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
    let bus = self.createBus()
    bus.interruptEnable.value = 6
    XCTAssertEqual(bus.read(MemoryMap.interruptEnable), 6)
  }

  // MARK: - Helpers

  private func fill(_ data: inout Data) {
    data[data.startIndex]   = ReadTests.startValue
    data[data.endIndex - 1] = ReadTests.endValue
  }

  private func testStartValue(_ bus:   Bus,
                              _ range: ClosedRange<UInt16>,
                              file:    StaticString = #file,
                              line:    UInt = #line) {

    let value = bus.read(range.start)
    XCTAssertEqual(value, ReadTests.startValue, file: file, line: line)
  }

  private func testEndValue(_ bus:   Bus,
                            _ range: ClosedRange<UInt16>,
                            file:    StaticString = #file,
                            line:    UInt = #line) {

    let value = bus.read(range.end)
    XCTAssertEqual(value, ReadTests.endValue, file: file, line: line)
  }
}
