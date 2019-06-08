// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

/// FF04 - Divider register
public class DivTimer: MemoryRegion {

  public static let address: UInt16 = 0xff04

  /// Frequency at which div register should be incremented.
  private static let frequency: UInt = 16_384

  /// Divider - This register is incremented at rate of 16384Hz.
  /// Writing any value to this register resets it to 00h.
  public var value: UInt8 = 0x00

  private var progress: UInt = 0

  // MARK: - Memory region

  public func contains(globalAddress address: UInt16) -> Bool {
    return address == DivTimer.address
  }

  public func read(globalAddress address: UInt16) -> UInt8 {
    assert(self.contains(globalAddress: address))
    return self.value
  }

  public func write(globalAddress address: UInt16, value: UInt8) {
    assert(self.contains(globalAddress: address))
    self.value = 0
    self.progress = 0
  }

  // MARK: - Tick

  public func tick(cycles: UInt8) {
    let max = Cpu.clockSpeed / DivTimer.frequency

    self.progress += UInt(cycles)

    if self.progress >= max {
      self.value &+= 1
      self.progress %= max
    }
  }
}
