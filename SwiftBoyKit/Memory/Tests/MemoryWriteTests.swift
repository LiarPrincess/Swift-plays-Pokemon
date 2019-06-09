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

  func test_workRam() {
    let memory = Memory()
    self.testContinuousRegion(in: memory, region: memory.workRam)
  }

  func test_echoMemory() {
    let memory = Memory()
    let dataRegion = memory.workRam

    memory.write(EchoMemory.start, value: 5)
    XCTAssertEqual(dataRegion.data[0], 5)

    memory.write(EchoMemory.end, value: 7)
    XCTAssertEqual(dataRegion.data[EchoMemory.size - 1], 7)
  }

  func test_oam() {
    let memory = Memory()
    self.testContinuousRegion(in: memory, region: memory.oam)
  }

  func test_ioPorts() {
    // TODO: add 'ioPorts' write tests
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
    self.testContinuousRegion(in: memory, region: memory.lcd)
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
