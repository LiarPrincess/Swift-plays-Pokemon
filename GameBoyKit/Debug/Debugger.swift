// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public class Debugger {

  internal var gameBoy: GameBoy? = nil
  internal var cpu:       Cpu       { return gameBoy!.cpu }
  internal var registers: Registers { return gameBoy!.cpu.registers }
  internal var bus:       Bus       { return gameBoy!.bus }

  private var mode: DebugMode
  private var isPrintEnabled:    Bool { return gameBoy != nil }
  private var isPrintingOpcodes: Bool { return isPrintEnabled && (mode == .opcodes || mode == .full) }
  private var isPrintingDetails: Bool { return isPrintEnabled && mode == .full }

  public init(mode: DebugMode) {
    self.mode = mode
  }

  public func attach(_ gameBoy: GameBoy) {
    // debugger should be always weak
  }

  public func run(cycles: UInt64? = nil, lastPC: UInt16? = nil) {
    var remainingCycles = cycles ?? UInt64.max
    let lastPC          = lastPC ?? UInt16.max

    while remainingCycles >= 0 && self.cpu.pc != lastPC {
      if self.isPrintingOpcodes {
        self.printNextOpcode()
      }

      let cycles = self.cpu.tick()

      if self.isPrintingDetails {

        self.printSeparator()
      }

      remainingCycles -= UInt64(cycles)
    }
  }

  private func printSeparator() {
    print()
    print("---------------------")
    print()
  }
}
