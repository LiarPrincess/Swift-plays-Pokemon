// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

/// FF04 - Divider register;
/// FF05, FF06, FF07 - App defined timer
public protocol Timer: AnyObject {

  /// FF04 - DIV - Divider Register.
  /// This register is incremented at rate of 16384Hz.
  /// Writing any value to this register resets it to 00h.
  var div: UInt8 { get set }

  /// FF05 - TIMA - Timer counter.
  /// This timer is incremented by a clock frequency specified by the TAC
  /// register (FF07). When the value overflows then it will be reset to the
  /// value specified in TMA (FF06), and an interrupt will be requested.
  var tima: UInt8 { get set }

  /// FF06 - TMA - Timer Modulo.
  /// When the TIMA overflows, this data will be loaded.
  var tma: UInt8 { get set }

  /// FF07 - TAC - Timer Control.
  /// Bit 2 - stop timer, bits 1 and 0 - select clock
  var tac: UInt8 { get set }

  // TODO: To remove
  func tick(cycles: Int)
}
