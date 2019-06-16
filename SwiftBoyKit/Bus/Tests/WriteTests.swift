// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import SwiftBoyKit

class WriteTests: XCTestCase {

  func test_rom0() {
    XCTAssert(true, "'rom0' is read only")
  }

  func test_rom1() {
    XCTAssert(true, "'rom1' is read only")
  }

  func test_videoRam() {
    let bus = Bus()
    self.testContinuousRegion(bus, region: bus.videoRam)
  }

  func test_externalRam() {
    let bus = Bus()
    self.testContinuousRegion(bus, region: bus.externalRam)
  }

  func test_internalRam() {
    let bus = Bus()
    self.testContinuousRegion(bus, region: bus.internalRam)
  }

  func test_echoMemory() {
    let bus = Bus()

    bus.write(InternalRamEcho.start, value: 5)
    XCTAssertEqual(bus.internalRam.data[0], 5)

    bus.write(InternalRamEcho.end, value: 7)
    XCTAssertEqual(bus.internalRam.data[InternalRamEcho.size - 1], 7)
  }

  func test_oam() {
    let bus = Bus()
    self.testContinuousRegion(bus, region: bus.oam)
  }

  func test_joypadMemory() {
    let bus = Bus()
    bus.write(JoypadMemory.address, value: 5)
    XCTAssertEqual(bus.joypad.value, 5)
  }

  func test_serialPortMemory() {
    let bus = Bus()

    bus.write(SerialPortMemory.sbAddress, value: 5)
    XCTAssertEqual(bus.serialPort.sb, 5)

    bus.write(SerialPortMemory.scAddress, value: 6)
    XCTAssertEqual(bus.serialPort.sc, 6)
  }

  func test_lcdMemory() {
    let bus = Bus()

    bus.write(LcdMemory.controlAddress, value: 5)
    XCTAssertEqual(bus.lcd.control.byte, 5)

    bus.write(LcdMemory.statusAddress, value: 6)
    XCTAssertEqual(bus.lcd.status.byte, 6)

    bus.write(LcdMemory.scrollYAddress, value: 7)
    XCTAssertEqual(bus.lcd.scrollY, 7)

    bus.write(LcdMemory.scrollXAddress, value: 8)
    XCTAssertEqual(bus.lcd.scrollX, 8)

    bus.write(LcdMemory.lineAddress, value: 9)
    XCTAssertEqual(bus.lcd.line, 0) // line should reset

    bus.write(LcdMemory.lineCompareAddress, value: 10)
    XCTAssertEqual(bus.lcd.lineCompare, 10)

    bus.write(LcdMemory.windowYAddress, value: 11)
    XCTAssertEqual(bus.lcd.windowY, 11)

    bus.write(LcdMemory.windowXAddress, value: 12)
    XCTAssertEqual(bus.lcd.windowX, 12)
  }

  func test_divTimer() {
    let bus = Bus()
    bus.write(DivTimer.address, value: 5)
    XCTAssertEqual(bus.divTimer.value, 0) // should reset on write
  }

  func test_appTimer() {
    let bus = Bus()

    bus.write(AppTimer.timaAddress, value: 5)
    XCTAssertEqual(bus.appTimer.tima, 5)

    bus.write(AppTimer.tmaAddress, value: 6)
    XCTAssertEqual(bus.appTimer.tma, 6)

    bus.write(AppTimer.tacAddress, value: 7)
    XCTAssertEqual(bus.appTimer.tac, 7)
  }

  func test_interrupts() {
    let bus = Bus()

    bus.write(Interrupts.ifAddress, value: 5)
    XCTAssertEqual(bus.interrupts.if, 5)

    bus.write(Interrupts.ieAddress, value: 6)
    XCTAssertEqual(bus.interrupts.ie, 6)
  }

  func test_highRam() {
    let bus = Bus()
    self.testContinuousRegion(bus, region: bus.highRam)
  }

  private func testContinuousRegion<T: ContinuousMemoryRegion>(_ bus: Bus, region: T) {
    bus.write(T.start, value: 5)
    XCTAssertEqual(region.data[0], 5)

    bus.write(T.end, value: 7)
    XCTAssertEqual(region.data[T.size - 1], 7)
  }
}
