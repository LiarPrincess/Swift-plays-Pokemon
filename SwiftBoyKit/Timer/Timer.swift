// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

public class Timer: MemoryRegion {

  public static let divAddress:  UInt16 = 0xff04
  public static let timaAddress: UInt16 = 0xff05
  public static let tmaAddress:  UInt16 = 0xff06
  public static let tacAddress:  UInt16 = 0xff07

  /// FF04 - Divider register
  private let divTimer = DivTimer()

  /// FF05, FF06, FF07 - App defined timer
  private let appTimer = AppTimer()

  // MARK: - Getters

  /// Divider - This register is incremented at rate of 16384Hz.
  /// Writing any value to this register resets it to 00h.
  public var div: UInt8 { return self.divTimer.value }

  /// Timer counter - This timer is incremented by a clock frequency specified by the TAC register (FF07).
  /// When the value overflows then it will be reset to the value specified in TMA (FF06),
  /// and an interrupt will be requested.
  public var tima: UInt8 { return self.appTimer.tima }

  /// Timer Modulo - When the TIMA overflows, this data will be loaded.
  public var tma: UInt8 { return self.appTimer.tma }

  /// Timer Control:
  /// Bit 2    - Timer Stop;
  /// Bits 1-0 - Input Clock Select
  public var tac: UInt8 { return self.appTimer.tac }

  /// Flag instead of 0xFF0F.
  public var hasInterrupt: Bool { return self.appTimer.hasInterrupt }

  // MARK: - MemoryRegion

  internal func contains(globalAddress address: UInt16) -> Bool {
    return Timer.divAddress <= address && address <= Timer.tacAddress
  }

  internal func read(globalAddress address: UInt16) -> UInt8 {
    switch address {
    case Timer.divAddress: return self.divTimer.read()
    case Timer.timaAddress,
         Timer.tmaAddress,
         Timer.tacAddress: return self.appTimer.read(globalAddress: address)
    default:
      fatalError("Attempting to read from memory that does not belong to timer (\(address.hex)).")
    }
  }

  internal func write(globalAddress address: UInt16, value: UInt8) {
    switch address {
    case Timer.divAddress: self.divTimer.write()
    case Timer.timaAddress,
         Timer.tmaAddress,
         Timer.tacAddress: self.appTimer.write(globalAddress: address, value: value)
    default:
      fatalError("Attempting to write to memory that does not belong to timer (\(address.hex)).")
    }
  }

  // MARK: - Interrupts

  internal func clearInterrupt() {
    self.appTimer.clearInterrupt()
  }

  // MARK: - Tick

  internal func tick(cycles: UInt8) {
    self.divTimer.tick(cycles: cycles)
    self.appTimer.tick(cycles: cycles)
  }
}
