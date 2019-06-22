// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftlint:disable force_unwrapping

public class Debugger {

  private var mode: DebugMode

  internal var gameBoy: GameBoy? = nil
  internal var cpu:       Cpu       { return gameBoy!.cpu }
  internal var registers: Registers { return gameBoy!.cpu.registers }
  internal var bus:       Bus       { return gameBoy!.bus }

  public init(mode: DebugMode) {
    self.mode = mode
  }

  public func attach(_ gameBoy: GameBoy) {
    self.gameBoy = gameBoy
  }

  public func run(mode:         DebugMode = .none,
                  cycles:       Int64     = Int64.max,
                  instructions: Int64     = Int64.max,
                  lastPC:       UInt16    = UInt16.max) {

    guard self.gameBoy != nil else {
      print("No emulator attached!")
      return
    }

    var remainingCycles = cycles
    var remainingInstructions = instructions

    var stateBefore = GameBoyState()
    var stateAfter  = GameBoyState()

    while remainingCycles >= 0 && remainingInstructions > 0 && self.cpu.pc != lastPC {
      if mode == .opcodes || mode == .opcodesAndWrites || mode == .full {
        self.printNextOpcode()
      }

      self.gameBoy!.save(to: &stateBefore)
      let cycles = self.cpu.tick()
      self.gameBoy!.save(to: &stateAfter)

      if mode == .opcodesAndWrites || mode == .full {
        self.printRegiserWrites(before: stateBefore, after: stateAfter)
        // memory writes
        self.printOpcodeDetails(before: stateBefore, after: stateAfter)
      }

      if mode == .full {
        self.printRegisterValues()
      }

      if mode == .opcodesAndWrites || mode == .full {
        print()
      }

      remainingInstructions -= 1
      remainingCycles -= Int64(cycles)
    }
  }
}
