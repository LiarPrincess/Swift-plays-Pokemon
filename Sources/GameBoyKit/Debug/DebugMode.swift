// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public enum DebugMode {

  /// Print nothing
  case none

  /// Print only executed opcodes
  case opcodes

  /// Print only executed opcodes
  case opcodesAndWrites

  /// Print everything
  case full
}
