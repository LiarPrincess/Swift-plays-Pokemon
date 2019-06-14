// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

public enum DebugMode {
  case none
  case full
  case onlyOpcodes
  case onlyMemoryWrites
}

internal class Debug {
  internal static var mode: DebugMode = .none

  internal static unowned var emulator: Emulator!
  internal static var cpu:       Cpu       { return emulator.cpu }
  internal static var registers: Registers { return cpu.registers }
  internal static var memory:    Memory    { return emulator.memory }

  internal static func printSeparator() {
    print()
    print("---------------------")
    print()
  }
}
