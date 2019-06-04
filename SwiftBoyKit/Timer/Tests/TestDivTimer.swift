import XCTest
@testable import SwiftBoyKit

class TestDivTimer: XCTestCase {

  func test_divIncrement() {
    let memory = TestTimerMemory()
    let timer = Timer(memory: memory)

    for _ in 0..<0xff {
      timer.tick(cycles: 4)
      XCTAssertEqual(memory.div, 0)
    }

    timer.tick(cycles: 4) // 256 tick
    XCTAssertEqual(memory.div, 1)
  }

  func test_divOverflow() {
    let memory = TestTimerMemory()
    let timer = Timer(memory: memory)

    // next tick will overflow
    memory.div = 0xff

    for _ in 0..<0xff {
      timer.tick(cycles: 4)
      XCTAssertEqual(memory.div, 0xff)
    }

    timer.tick(cycles: 4) // 256 tick
    XCTAssertEqual(memory.div, 0)
  }
}
