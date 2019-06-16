// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import SwiftBoyKit

class MemoryReadTests: XCTestCase {

  func test_rom0() {
    let memory = Memory()
    self.testContinuousRegion(in: memory, region: memory.rom0)
  }

  func test_rom1() {
    let memory = Memory()
    self.testContinuousRegion(in: memory, region: memory.rom1)
  }

  func test_videoRam() {
    let memory = Memory()
    self.testContinuousRegion(in: memory, region: memory.videoRam)
  }

  func test_externalRam() {
    let memory = Memory()
    self.testContinuousRegion(in: memory, region: memory.externalRam)
  }

  func test_internalkRam() {
    let memory = Memory()
    self.testContinuousRegion(in: memory, region: memory.internalRam)
  }

  func test_internalRamEcho() {
    let memory = Memory()

    memory.internalRam.data[0] = 5
    XCTAssertEqual(memory.read(InternalRamEcho.start), 5)

    memory.internalRam.data[InternalRamEcho.size - 1] = 7
    XCTAssertEqual(memory.read(InternalRamEcho.end), 7)
  }

  func test_oam() {
    let memory = Memory()
    self.testContinuousRegion(in: memory, region: memory.oam)
  }

  func test_joypadMemory() {
    let memory = Memory()
    memory.joypad.value = 5
    XCTAssertEqual(memory.read(JoypadMemory.address), 5)
  }

  func test_serialPortMemory() {
    let memory = Memory()

    memory.serialPort.sb = 5
    XCTAssertEqual(memory.read(SerialPortMemory.sbAddress), 5)

    memory.serialPort.sc = 6
    XCTAssertEqual(memory.read(SerialPortMemory.scAddress), 6)
  }

  func test_lcdMemory() {
    let memory = Memory()

    memory.lcd.control.byte = 5
    XCTAssertEqual(memory.read(LcdMemory.controlAddress), 5)

    memory.lcd.status.byte = 6
    XCTAssertEqual(memory.read(LcdMemory.statusAddress), 6)

    memory.lcd.scrollY = 7
    XCTAssertEqual(memory.read(LcdMemory.scrollYAddress), 7)

    memory.lcd.scrollX = 8
    XCTAssertEqual(memory.read(LcdMemory.scrollXAddress), 8)

    memory.lcd.line = 9
    XCTAssertEqual(memory.read(LcdMemory.lineAddress), 9)

    memory.lcd.lineCompare = 10
    XCTAssertEqual(memory.read(LcdMemory.lineCompareAddress), 10)

    memory.lcd.windowY = 11
    XCTAssertEqual(memory.read(LcdMemory.windowYAddress), 11)

    memory.lcd.windowX = 12
    XCTAssertEqual(memory.read(LcdMemory.windowXAddress), 12)
  }

  func test_divTimer() {
    let memory = Memory()
    memory.divTimer.value = 5
    XCTAssertEqual(memory.read(DivTimer.address), 5)
  }

  func test_appTimer() {
    let memory = Memory()

    memory.appTimer.tima = 5
    XCTAssertEqual(memory.read(AppTimer.timaAddress), 5)

    memory.appTimer.tma = 6
    XCTAssertEqual(memory.read(AppTimer.tmaAddress), 6)

    memory.appTimer.tac = 7
    XCTAssertEqual(memory.read(AppTimer.tacAddress), 7)
  }

  func test_interrupts() {
    let memory = Memory()

    memory.interrupts.if = 5
    XCTAssertEqual(memory.read(Interrupts.ifAddress), 5)

    memory.interrupts.ie = 6
    XCTAssertEqual(memory.read(Interrupts.ieAddress), 6)
  }

  func test_highRam() {
    let memory = Memory()
    self.testContinuousRegion(in: memory, region: memory.highRam)
  }

  private func testContinuousRegion<T: ContinuousMemoryRegion>(in memory: Memory, region: T) {
    region.data[0] = 5
    XCTAssertEqual(memory.read(T.start), 5)

    region.data[T.size - 1] = 7
    XCTAssertEqual(memory.read(T.end), 7)
  }
}
