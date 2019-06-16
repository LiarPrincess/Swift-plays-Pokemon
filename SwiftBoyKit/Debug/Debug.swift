// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

private enum DebugMode {
  case none
  case full
  case opcodes
  case memoryWrites
}

private let mode:  DebugMode = .none
private let minPc: UInt16    = 0x0060 // start debugging only after this pc

internal enum Debug {

  internal static var fInitialState: Bool { return global && mode != .none }

  internal static var fRegisterWrites: Bool { return global && mode == .full }
  internal static var fOpcode:         Bool { return global && mode != .none }
  internal static var fOpcodeDetails:  Bool { return global && mode == .full }

  internal static var fMemoryReads:  Bool { return global && mode == .full }
  internal static var fMemoryWrites: Bool { return global && (mode == .full || mode == .memoryWrites) }

  private static var isPastMinPc = false

  private static var global: Bool {
    guard emulator != nil else { return false } // for example unit tests

    isPastMinPc = isPastMinPc || cpu.pc == minPc
    return isPastMinPc
  }

  internal static var emulator: Emulator!
  internal static var cpu:       Cpu       { return emulator.cpu }
  internal static var registers: Registers { return cpu.registers }
  internal static var bus:       Bus       { return emulator.bus }

  internal static func printSeparator() {
    print()
    print("---------------------")
    print()
  }
}
