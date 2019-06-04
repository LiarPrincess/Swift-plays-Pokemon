@testable import SwiftBoyKit

class FakeCpuMemory: CpuMemoryView {

  var data = [UInt8](repeating: 0, count: 0x10000)

  func read(_ address: UInt16) -> UInt8 {
    return self.data[address]
  }

  func write(_ address: UInt16, value: UInt8) {
    self.data[address] = value
  }
}
