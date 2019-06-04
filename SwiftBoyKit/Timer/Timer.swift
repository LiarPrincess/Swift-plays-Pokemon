public class Timer {

  /// Div register should increment every 256 (clockSpeed / 16384) ticks
  private var divCounter: UInt8 = 0

  private var memory: TimerMemoryView

  init(memory: TimerMemoryView) {
    self.memory = memory
  }

  public func tick(cycles: UInt8) {
    self.updateDivRegister()
  }

  private func updateDivRegister() {
    let (newValue, overflow) = self.divCounter.addingReportingOverflow(1)
    self.divCounter = newValue

    if overflow {
      self.memory.div &+= 1
    }
  }
}
