// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import SwiftBoyKit

class WriteTests: XCTestCase {

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

    for address in MemoryMap.internalRamEcho {
      let value = self.writeValue(address)
      bus.write(address, value: value)

      let ramAddress = address - 0x2000 - MemoryMap.internalRam.start
      XCTAssertEqual(value, bus.ram[ramAddress])
    }
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

// TODO: Missing IO tests (lcd + audio)
//  func test_lcdMemory() {
//    let bus = Bus()
//
//    bus.write(LcdMemory.controlAddress, value: 5)
//    XCTAssertEqual(bus.lcd.control.byte, 5)
//
//    bus.write(LcdMemory.statusAddress, value: 6)
//    XCTAssertEqual(bus.lcd.status.byte, 6)
//
//    bus.write(LcdMemory.scrollYAddress, value: 7)
//    XCTAssertEqual(bus.lcd.scrollY, 7)
//
//    bus.write(LcdMemory.scrollXAddress, value: 8)
//    XCTAssertEqual(bus.lcd.scrollX, 8)
//
//    bus.write(LcdMemory.lineAddress, value: 9)
//    XCTAssertEqual(bus.lcd.line, 0) // line should reset
//
//    bus.write(LcdMemory.lineCompareAddress, value: 10)
//    XCTAssertEqual(bus.lcd.lineCompare, 10)
//
//    bus.write(LcdMemory.windowYAddress, value: 11)
//    XCTAssertEqual(bus.lcd.windowY, 11)
//
//    bus.write(LcdMemory.windowXAddress, value: 12)
//    XCTAssertEqual(bus.lcd.windowX, 12)
//  }

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
    for address in range {
      let value = self.writeValue(address)
      bus.write(address, value: value)
    }
  }

  private func testValues(_ bus: Bus, _ range: ClosedRange<UInt16>, shouldFill data: [UInt8]) {
    for address in range {
      let value = data[address - range.start]
      let expected = self.writeValue(address)
      XCTAssertEqual(value, expected)
    }
  }

  private func writeValue(_ address: UInt16) -> UInt8 {
    return UInt8(address & 0xff)
  }
}
