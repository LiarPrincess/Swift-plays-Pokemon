// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

/// FF00 -  Timer and Divider Registers
public class TimerMemory: MemoryRegion {

  public static let divAddress:  UInt16 = 0xff04
  public static let timaAddress: UInt16 = 0xff05
  public static let tmaAddress:  UInt16 = 0xff06
  public static let tacAddress:  UInt16 = 0xff07

  /// Frequency at which div register should be incremented.
  private static let divFrequency: UInt = 16_384

  /// Divider - This register is incremented at rate of 16384Hz (TimerMemory.divFrequency).
  /// Writing any value to this register resets it to 00h.
  public var div: UInt8 = 0x00

  /// This property tracks progress of div
  /// (meaning that it counts from 0 to 'clockSpeed/divFrequency')
  /// and then increments div and goes back to 0.
  private var divCounter: UInt = 0

  /// Timer counter - This timer is incremented by a clock frequency specified by the TAC register (FF07).
  /// When the value overflows then it will be reset to the value specified in TMA (FF06),
  /// and an interrupt will be requested.
  public var tima: UInt8 = 0x00

  /// Timer Modulo - When the TIMA overflows, this data will be loaded.
  public var tma: UInt8 = 0x00

  /// Timer Control:
  /// Bit 2    - Timer Stop;
  /// Bits 1-0 - Input Clock Select
  public var tac: UInt8 = 0x00

  // MARK: - Memory region

  public func contains(globalAddress address: UInt16) -> Bool {
    return address >= TimerMemory.divAddress
        && address <= TimerMemory.tacAddress
  }

  public func read(globalAddress address: UInt16) -> UInt8 {
    assert(self.contains(globalAddress: address))
    switch address {
    case TimerMemory.divAddress: return self.div
    case TimerMemory.timaAddress: return self.tima
    case TimerMemory.tmaAddress: return self.tma
    case TimerMemory.tacAddress: return self.tac
    default:
      fatalError("Attempting to read invalid timer memory")
    }
  }

  public func write(globalAddress address: UInt16, value: UInt8) {
    assert(self.contains(globalAddress: address))
    switch address {
    case TimerMemory.divAddress:
      self.div = 0
      self.divCounter = 0

    case TimerMemory.timaAddress: self.tima = value
    case TimerMemory.tmaAddress:  self.tma = value
    case TimerMemory.tacAddress:  self.tac = value

    default:
      fatalError("Attempting to write invalid timer memory")
    }
  }

  // MARK: - Tick

  public func tick(cycles: UInt8) {
    self.updateDivRegister(cycles: cycles)
//    self.updateAppTimer(cycles: cycles)
  }

  // MARK: - Div timer

  private func updateDivRegister(cycles: UInt8) {
    let finalValue = Cpu.clockSpeed / TimerMemory.divFrequency

    self.divCounter += UInt(cycles)
    print("counter: \(self.divCounter)")

    if self.divCounter >= finalValue {
      self.div &+= 1
      self.divCounter -= finalValue
    }

    print("div: \(self.div), counter: \(self.divCounter), final: \(finalValue)")
  }
}
