// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import SwiftBoyKit

class TestMemoryReads: XCTestCase {

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

  func test_workRam() {
    let memory = Memory()
    self.testContinuousRegion(in: memory, region: memory.workRam)
  }

  func test_echoMemory() {
    let memory = Memory()
    let dataRegion = memory.workRam

    dataRegion.data[0] = 5
    XCTAssertEqual(memory.read(EchoMemory.start), 5)

    dataRegion.data[EchoMemory.size - 1] = 7
    XCTAssertEqual(memory.read(EchoMemory.end), 7)
  }

  func test_oam() {
    let memory = Memory()
    self.testContinuousRegion(in: memory, region: memory.oam)
  }

  func test_ioPorts() {
    // TODO: add 'ioPorts' read tests
  }

  func test_joypadMemory() {
    let memory = Memory()
    memory.joypadMemory.value = 5
    XCTAssertEqual(memory.read(JoypadMemory.address), 5)
  }

  func test_serialPortMemory() {
    let memory = Memory()

    memory.serialPortMemory.sb = 5
    XCTAssertEqual(memory.read(SerialPortMemory.sbAddress), 5)

    memory.serialPortMemory.sc = 6
    XCTAssertEqual(memory.read(SerialPortMemory.scAddress), 6)
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

  func test_interruptMemory() {
    let memory = Memory()

    memory.interruptMemory.if = 5
    XCTAssertEqual(memory.read(InterruptMemory.ifAddress), 5)

    memory.interruptMemory.ie = 6
    XCTAssertEqual(memory.read(InterruptMemory.ieAddress), 6)
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
