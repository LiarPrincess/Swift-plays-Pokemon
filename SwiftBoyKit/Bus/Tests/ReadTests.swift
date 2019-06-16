//// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//// If a copy of the MPL was not distributed with this file,
//// You can obtain one at http://mozilla.org/MPL/2.0/.
//
//import XCTest
//@testable import SwiftBoyKit
//
//class ReadTests: XCTestCase {
//
//  func test_rom0() {
//    let bus = Bus()
//    self.testContinuousRegion(bus, region: bus.rom0)
//  }
//
//  func test_rom1() {
//    let bus = Bus()
//    self.testContinuousRegion(bus, region: bus.rom1)
//  }
//
//  func test_videoRam() {
//    let bus = Bus()
//    self.testContinuousRegion(bus, region: bus.videoRam)
//  }
//
//  func test_externalRam() {
//    let bus = Bus()
//    self.testContinuousRegion(bus, region: bus.externalRam)
//  }
//
//  func test_internalkRam() {
//    let bus = Bus()
//    self.testContinuousRegion(bus, region: bus.internalRam)
//  }
//
//  func test_internalRamEcho() {
//    let bus = Bus()
//
//    bus.internalRam.data[0] = 5
//    XCTAssertEqual(bus.read(InternalRamEcho.start), 5)
//
//    bus.internalRam.data[InternalRamEcho.size - 1] = 7
//    XCTAssertEqual(bus.read(InternalRamEcho.end), 7)
//  }
//
//  func test_oam() {
//    let bus = Bus()
//    self.testContinuousRegion(bus, region: bus.oam)
//  }
//
//  func test_joypadMemory() {
//    let bus = Bus()
//    bus.joypad.value = 5
//    XCTAssertEqual(bus.read(JoypadMemory.address), 5)
//  }
//
//  func test_serialPortMemory() {
//    let bus = Bus()
//
//    bus.serialPort.sb = 5
//    XCTAssertEqual(bus.read(SerialPortMemory.sbAddress), 5)
//
//    bus.serialPort.sc = 6
//    XCTAssertEqual(bus.read(SerialPortMemory.scAddress), 6)
//  }
//
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
//
//  // TODO: Merge bus/read write tests (as below)
//  func test_timer() {
//    let timer = Timer()
//    let bus = Bus(timer: timer)
//
//    timer.write(globalAddress: SwiftBoyKit.Timer.divAddress, value: 5)
//    XCTAssertEqual(bus.read(SwiftBoyKit.Timer.divAddress), 0) // should reset on write
//
//    timer.write(globalAddress: SwiftBoyKit.Timer.timaAddress, value: 5)
//    XCTAssertEqual(bus.read(SwiftBoyKit.Timer.timaAddress), 5)
//
//    timer.write(globalAddress: SwiftBoyKit.Timer.tmaAddress, value: 6)
//    XCTAssertEqual(bus.read(SwiftBoyKit.Timer.tmaAddress), 6)
//
//    timer.write(globalAddress: SwiftBoyKit.Timer.tacAddress, value: 7)
//    XCTAssertEqual(bus.read(SwiftBoyKit.Timer.tacAddress), 7)
//  }
//
//  func test_interrupts() {
//    let bus = Bus()
//
//    bus.interrupts.if = 5
//    XCTAssertEqual(bus.read(Interrupts.ifAddress), 5)
//
//    bus.interrupts.ie = 6
//    XCTAssertEqual(bus.read(Interrupts.ieAddress), 6)
//  }
//
//  func test_highRam() {
//    let bus = Bus()
//    self.testContinuousRegion(bus, region: bus.highRam)
//  }
//
//  private func testContinuousRegion<T: ContinuousMemoryRegion>(_ bus: Bus, region: T) {
//    region.data[0] = 5
//    XCTAssertEqual(bus.read(T.start), 5)
//
//    region.data[T.size - 1] = 7
//    XCTAssertEqual(bus.read(T.end), 7)
//  }
//}
