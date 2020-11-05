// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

/// FF04 - Divider register;
/// FF05, FF06, FF07 - App defined timer
internal protocol TimerMemory: AnyObject {

  /// FF04 - DIV - Divider Register.
  var div: UInt8 { get set }

  /// FF05 - TIMA - Timer counter.
  var tima: UInt8 { get set }

  /// FF06 - TMA - Timer Modulo.
  var tma: UInt8 { get set }

  /// FF07 - TAC - Timer Control.
  var tac: UInt8 { get set }
}
