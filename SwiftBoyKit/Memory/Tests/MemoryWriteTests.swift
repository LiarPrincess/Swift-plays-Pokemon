// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import SwiftBoyKit

class MemoryWriteTests: XCTestCase {

  func test_rom0() {
    XCTAssert(true, "'rom0' is read only")
  }

  func test_rom1() {
    XCTAssert(true, "'rom1' is read only")
  }

  func test_videoRam() {
    let memory = Memory()
    self.testContinuousRegion(in: memory, region: memory.videoRam)
  }

  func test_externalRam() {
    let memory = Memory()
    self.testContinuousRegion(in: memory, region: memory.externalRam)
  }

  func test_internalRam() {
    let memory = Memory()
    self.testContinuousRegion(in: memory, region: memory.internalRam)
  }

  func test_echoMemory() {
    let memory = Memory()

    memory.write(InternalRamEcho.start, value: 5)
    XCTAssertEqual(memory.internalRam.data[0], 5)

    memory.write(InternalRamEcho.end, value: 7)
    XCTAssertEqual(memory.internalRam.data[InternalRamEcho.size - 1], 7)
  }

  func test_oam() {
    let memory = Memory()
    self.testContinuousRegion(in: memory, region: memory.oam)
  }

  func test_joypadMemory() {
    let memory = Memory()
    memory.write(JoypadMemory.address, value: 5)
    XCTAssertEqual(memory.joypad.value, 5)
  }

  func test_serialPortMemory() {
    let memory = Memory()

    memory.write(SerialPortMemory.sbAddress, value: 5)
    XCTAssertEqual(memory.serialPort.sb, 5)

    memory.write(SerialPortMemory.scAddress, value: 6)
    XCTAssertEqual(memory.serialPort.sc, 6)
  }

  func test_lcdMemory() {
    let memory = Memory()

    memory.write(LcdMemory.controlAddress, value: 5)
    XCTAssertEqual(memory.lcd.control.byte, 5)

    memory.write(LcdMemory.statusAddress, value: 6)
    XCTAssertEqual(memory.lcd.status.byte, 6)

    memory.write(LcdMemory.scrollYAddress, value: 7)
    XCTAssertEqual(memory.lcd.scrollY, 7)

    memory.write(LcdMemory.scrollXAddress, value: 8)
    XCTAssertEqual(memory.lcd.scrollX, 8)

    memory.write(LcdMemory.lineAddress, value: 9)
    XCTAssertEqual(memory.lcd.line, 0) // line should reset

    memory.write(LcdMemory.lineCompareAddress, value: 10)
    XCTAssertEqual(memory.lcd.lineCompare, 10)

    memory.write(LcdMemory.windowYAddress, value: 11)
    XCTAssertEqual(memory.lcd.windowY, 11)

    memory.write(LcdMemory.windowXAddress, value: 12)
    XCTAssertEqual(memory.lcd.windowX, 12)
  }

  func test_divTimer() {
    let memory = Memory()
    memory.write(DivTimer.address, value: 5)
    XCTAssertEqual(memory.divTimer.value, 0) // should reset on write
  }

  func test_appTimer() {
    let memory = Memory()

    memory.write(AppTimer.timaAddress, value: 5)
    XCTAssertEqual(memory.appTimer.tima, 5)

    memory.write(AppTimer.tmaAddress, value: 6)
    XCTAssertEqual(memory.appTimer.tma, 6)

    memory.write(AppTimer.tacAddress, value: 7)
    XCTAssertEqual(memory.appTimer.tac, 7)
  }

  func test_interrupts() {
    let memory = Memory()

    memory.write(Interrupts.ifAddress, value: 5)
    XCTAssertEqual(memory.interrupts.if, 5)

    memory.write(Interrupts.ieAddress, value: 6)
    XCTAssertEqual(memory.interrupts.ie, 6)
  }

  func test_highRam() {
    let memory = Memory()
    self.testContinuousRegion(in: memory, region: memory.highRam)
  }

  private func testContinuousRegion<T: ContinuousMemoryRegion>(in memory: Memory, region: T) {
    memory.write(T.start, value: 5)
    XCTAssertEqual(region.data[0], 5)

    memory.write(T.end, value: 7)
    XCTAssertEqual(region.data[T.size - 1], 7)
  }
}
