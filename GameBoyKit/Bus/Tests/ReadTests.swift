// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import GameBoyKit

class ReadTests: XCTestCase {

  func test_rom0() {
    let bus = Bus()
    self.fill(&bus.cartridge.rom0)
    self.testReads(bus, MemoryMap.rom0, shouldEqual: bus.cartridge.rom0)
  }

  func test_rom1() {
    let bus = Bus()
    self.fill(&bus.cartridge.rom1)
    self.testReads(bus, MemoryMap.rom1, shouldEqual: bus.cartridge.rom1)
  }

  func test_videoRam() {
    let bus = Bus()
    self.fill(&bus.lcd.videoRam)
    self.testReads(bus, MemoryMap.videoRam, shouldEqual: bus.lcd.videoRam)
  }

  func test_externalRam() {
    let bus = Bus()
    self.fill(&bus.cartridge.ram)
    self.testReads(bus, MemoryMap.videoRam, shouldEqual: bus.lcd.videoRam)
  }

  func test_internalkRam() {
    let bus = Bus()
    self.fill(&bus.ram)
    self.testReads(bus, MemoryMap.internalRam, shouldEqual: bus.ram)
  }

  func test_internalRamEcho() {
    let bus = Bus()
    let range = MemoryMap.internalRamEcho

    bus.ram[bus.ram.startIndex] = 5
    bus.ram[bus.ram.endIndex - 1] = 6

    let startValue = bus.read(range.start)
    XCTAssertEqual(startValue, bus.ram[0])

    let endValue = bus.read(range.end)
    XCTAssertEqual(endValue, bus.ram[range.count - 1])
  }

  func test_oam() {
    let bus = Bus()
    self.fill(&bus.lcd.oam)
    self.testReads(bus, MemoryMap.oam, shouldEqual: bus.lcd.oam)
  }

  func test_joypadMemory() {
    let bus = Bus()
    bus.joypad.value = 5
    XCTAssertEqual(bus.read(MemoryMap.IO.joypad), 5)
  }

  func test_serialPortMemory() {
    let bus = Bus()

    bus.serialPort.sb = 5
    XCTAssertEqual(bus.read(MemoryMap.IO.sb), 5)

    bus.serialPort.sc = 6
    XCTAssertEqual(bus.read(MemoryMap.IO.sc), 6)
  }

  func test_timer() {
    let bus = Bus()

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
    let bus = Bus()
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
    let bus = Bus()
    self.fill(&bus.highRam)
    self.testReads(bus, MemoryMap.highRam, shouldEqual: bus.highRam)
  }

  func test_interrupts() {
    let bus = Bus()
    bus.interruptEnable.value = 6
    XCTAssertEqual(bus.read(MemoryMap.interruptEnable), 6)
  }

  // MARK: - Helpers

  private func fill(_ data: inout Data) {
    // use this if you have time (~0.3s):
    // for i in 0..<data.count {
    //   data[i] = UInt8(i & 0xff)
    // }

    data[data.startIndex] = 5
    data[data.endIndex - 1] = 6
  }

  private func testReads(_ bus: Bus, _ range: ClosedRange<UInt16>, shouldEqual data: Data) {
    // use this if you have time (~0.3s):
    // for address in range {
    //   let value = bus.read(address)
    //   XCTAssertEqual(value, data[address - range.start])
    // }

    let startValue = bus.read(range.start)
    XCTAssertEqual(startValue, data[data.startIndex])

    let endValue = bus.read(range.end)
    XCTAssertEqual(endValue, data[data.endIndex - 1])
  }
}
