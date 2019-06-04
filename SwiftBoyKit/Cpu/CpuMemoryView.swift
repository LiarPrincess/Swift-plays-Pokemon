/// Memory as viewied by CPU.
internal protocol CpuMemoryView {
  func read(_ address: UInt16) -> UInt8
  func write(_ address: UInt16, value: UInt8)
}

extension Memory: CpuMemoryView { }
