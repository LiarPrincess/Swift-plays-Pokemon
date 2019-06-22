// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

private let mode:  DebugMode = .none
private let minPc: UInt16    = 0x0060 // start debugging only after this pc

internal enum Debug {

  internal static var fInitialState: Bool { return global && mode != .none }

  internal static var fRegisterWrites: Bool { return global && mode == .full }
  internal static var fOpcode:         Bool { return global && mode != .none }
  internal static var fOpcodeDetails:  Bool { return global && mode == .full }

  internal static var fMemoryReads:  Bool { return global && mode == .full }
  internal static var fMemoryWrites: Bool { return global && (mode == .full) }

  private static var isPastMinPc = false

  private static var global: Bool {
    guard gameBoy != nil else { return false } // for example unit tests

    isPastMinPc ||= cpu.pc == minPc
    return isPastMinPc
  }

  internal static var gameBoy:   GameBoy!
  internal static var cpu:       Cpu       { return gameBoy.cpu }
  internal static var registers: Registers { return cpu.registers }
  internal static var bus:       Bus       { return gameBoy.bus }

  internal static func printSeparator() {
    print()
    print("---------------------")
    print()
  }
}
