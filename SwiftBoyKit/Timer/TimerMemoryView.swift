/// Memory as viewied by timer.
internal protocol TimerMemoryView {

  /// Divider - This register is incremented at rate of 16384Hz.
  /// Writing any value to this register resets it to 00h.
  var div: UInt8 { get set }

  /// Timer counter - This timer is incremented by a clock frequency specified by the TAC register (FF07).
  /// When the value overflows then it will be reset to the value specified in TMA (FF06),
  /// and an interrupt will be requested.
  var tima: UInt8 { get set }

  /// Timer Modulo - When the TIMA overflows, this data will be loaded.
  var tma: UInt8 { get set }

  /// Timer Control:
  /// Bit 2    - Timer Stop;
  /// Bits 1-0 - Input Clock Select
  var tac: UInt8 { get set }
}

internal enum TimerMemoryAddress {
  internal static let div:  UInt16 = 0xff04
  internal static let tima: UInt16 = 0xff05
  internal static let tma:  UInt16 = 0xff06
  internal static let tac:  UInt16 = 0xff07
}

extension Memory: TimerMemoryView {

  internal var div: UInt8 {
    get { return self[TimerMemoryAddress.div] }
    set { self[TimerMemoryAddress.div] = newValue }
  }

  internal var tima: UInt8 {
    get { return self[TimerMemoryAddress.tima] }
    set { self[TimerMemoryAddress.tima] = newValue }
  }

  internal var tma: UInt8 {
    get { return self[TimerMemoryAddress.tma] }
    set { self[TimerMemoryAddress.tma] = newValue }
  }

  internal var tac: UInt8 {
    get { return self[TimerMemoryAddress.tac] }
    set { self[TimerMemoryAddress.tac] = newValue }
  }
}
