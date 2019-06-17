// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import SwiftBoyKit

class WriteTests: XCTestCase {

  let startValue: UInt8 = 5
  let endValue:   UInt8 = 6

  /// 'rom0' is read only
  func test_rom0() {
    let bus = Bus()
    let range = MemoryMap.rom0

    bus.write(range.start, value: 5)
    XCTAssertEqual(bus.cartridge.rom0.first, 0)

    bus.write(range.end, value: 6)
    XCTAssertEqual(bus.cartridge.rom0.last, 0)
  }

  /// 'rom1' is read only
  func test_rom1() {
    let bus = Bus()
    let range = MemoryMap.rom1

    bus.write(range.start, value: 5)
    XCTAssertEqual(bus.cartridge.rom1.first, 0)

    bus.write(range.end, value: 6)
    XCTAssertEqual(bus.cartridge.rom1.last, 0)
  }

  func test_videoRam() {
    let bus = Bus()
    self.write(bus, MemoryMap.videoRam)
    self.testValues(bus, MemoryMap.videoRam, shouldFill: bus.lcd.videoRam)
  }

  func test_externalRam() {
    let bus = Bus()
    self.write(bus, MemoryMap.externalRam)
    self.testValues(bus, MemoryMap.externalRam, shouldFill: bus.cartridge.ram)
  }

  func test_internalRam() {
    let bus = Bus()
    self.write(bus, MemoryMap.internalRam)
    self.testValues(bus, MemoryMap.internalRam, shouldFill: bus.ram)
  }

  func test_echoMemory() {
    let bus = Bus()
    let range = MemoryMap.internalRamEcho

    bus.write(range.start, value: startValue)
    bus.write(range.end,   value: endValue)

    XCTAssertEqual(bus.ram[0], startValue)
    XCTAssertEqual(bus.ram[range.count - 1], endValue)
  }

  func test_oam() {
    let bus = Bus()
    self.write(bus, MemoryMap.oam)
    self.testValues(bus, MemoryMap.oam, shouldFill: bus.lcd.oam)
  }

  func test_joypadMemory() {
    let bus = Bus()
    bus.write(MemoryMap.IO.joypad, value: 5)
    XCTAssertEqual(bus.joypad.value, 5)
  }

  func test_serialPortMemory() {
    let bus = Bus()

    bus.write(MemoryMap.IO.sb, value: 5)
    XCTAssertEqual(bus.serialPort.sb, 5)

    bus.write(MemoryMap.IO.sc, value: 6)
    XCTAssertEqual(bus.serialPort.sc, 6)
  }

  func test_timer() {
    let bus = Bus()

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
    let bus = Bus()
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

    bus.write(MemoryMap.Lcd.backgroundPalette, value: value)
    XCTAssertEqual(bus.lcd.backgroundPalette.value, value)
    value += 1

    // 2 last bits are always 0
    bus.write(MemoryMap.Lcd.objectPalette0, value: value)
    XCTAssertEqual(bus.lcd.objectPalette0.value, value & 0xfc)
    value += 1

    // 2 last bits are always 0
    bus.write(MemoryMap.Lcd.objectPalette1, value: value)
    XCTAssertEqual(bus.lcd.objectPalette1.value, value & 0xfc)
    value += 1
  }

  func test_highRam() {
    let bus = Bus()
    self.write(bus, MemoryMap.highRam)
    self.testValues(bus, MemoryMap.highRam, shouldFill: bus.highRam)
  }

  func test_interrupts() {
    let bus = Bus()
    bus.write(MemoryMap.interruptEnable, value: 6)
    XCTAssertEqual(bus.interruptEnable.value, 6)
  }

  // MARK: - Helpers

  private func write(_ bus: Bus, _ range: ClosedRange<UInt16>) {
    // use this if you have time (~0.3s):
    // for address in range {
    //   let value = self.writeValue(address)
    //   bus.write(address, value: value)
    // }

    bus.write(range.start, value: startValue)
    bus.write(range.end,   value: endValue)
  }

  private func testValues(_ bus: Bus, _ range: ClosedRange<UInt16>, shouldFill data: [UInt8]) {
    // use this if you have time (~0.3s):
    // for address in range {
    //   let value = data[address - range.start]
    //   let expected = self.writeValue(address)
    //   XCTAssertEqual(value, expected)
    // }

    XCTAssertEqual(data[data.startIndex], startValue)
    XCTAssertEqual(data[data.endIndex - 1], endValue)
  }

  private func writeValue(_ address: UInt16) -> UInt8 {
    return UInt8(address & 0xff)
  }
}
