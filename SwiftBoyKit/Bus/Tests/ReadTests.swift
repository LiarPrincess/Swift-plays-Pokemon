// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import SwiftBoyKit

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
    self.fill(&bus.ram)
    self.testReads(bus, MemoryMap.internalRamEcho, shouldEqual: bus.ram)
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

// TODO: Missing IO tests (lcd + audio)
//  func test_lcdMemory() {
//    let bus = Bus()
//
//    bus.lcd.control.byte = 5
//    XCTAssertEqual(bus.read(LcdMemory.controlAddress), 5)
//
//    bus.lcd.status.byte = 6
//    XCTAssertEqual(bus.read(LcdMemory.statusAddress), 6)
//
//    bus.lcd.scrollY = 7
//    XCTAssertEqual(bus.read(LcdMemory.scrollYAddress), 7)
//
//    bus.lcd.scrollX = 8
//    XCTAssertEqual(bus.read(LcdMemory.scrollXAddress), 8)
//
//    bus.lcd.line = 9
//    XCTAssertEqual(bus.read(LcdMemory.lineAddress), 9)
//
//    bus.lcd.lineCompare = 10
//    XCTAssertEqual(bus.read(LcdMemory.lineCompareAddress), 10)
//
//    bus.lcd.windowY = 11
//    XCTAssertEqual(bus.read(LcdMemory.windowYAddress), 11)
//
//    bus.lcd.windowX = 12
//    XCTAssertEqual(bus.read(LcdMemory.windowXAddress), 12)
//  }

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

  private func fill(_ data: inout [UInt8]) {
    for i in 0..<data.count {
      data[i] = UInt8(i & 0xff)
    }
  }

  private func testReads(_ bus: Bus, _ range: ClosedRange<UInt16>, shouldEqual data: [UInt8]) {
    for address in range {
      let value = bus.read(address)
      XCTAssertEqual(value, data[address - range.start])
    }
  }
}
