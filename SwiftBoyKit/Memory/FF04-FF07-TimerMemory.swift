/// FF00 -  Timer and Divider Registers
public class TimerMemory: MemoryRegion {

  public static let divAddress:  UInt16 = 0xff04
  public static let timaAddress: UInt16 = 0xff05
  public static let tmaAddress:  UInt16 = 0xff06
  public static let tacAddress:  UInt16 = 0xff07

  /// Divider - This register is incremented at rate of 16384Hz.
  /// Writing any value to this register resets it to 00h.
  var div: UInt8 = 0x00

  /// Timer counter - This timer is incremented by a clock frequency specified by the TAC register (FF07).
  /// When the value overflows then it will be reset to the value specified in TMA (FF06),
  /// and an interrupt will be requested.
  var tima: UInt8 = 0x00

  /// Timer Modulo - When the TIMA overflows, this data will be loaded.
  var tma: UInt8 = 0x00

  /// Timer Control:
  /// Bit 2    - Timer Stop;
  /// Bits 1-0 - Input Clock Select
  var tac: UInt8 = 0x00

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
    case TimerMemory.divAddress:  self.div = value
    case TimerMemory.timaAddress: self.tima = value
    case TimerMemory.tmaAddress:  self.tma = value
    case TimerMemory.tacAddress:  self.tac = value

//    case TimerMemoryAddress.div: // div should be reset to 0 on any write
//      // TODO: we should also invalidate internal counter in timer
//      self[address] = 0
    default:
      fatalError("Attempting to write invalid timer memory")
    }
  }
}
