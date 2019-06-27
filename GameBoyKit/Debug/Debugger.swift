// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public class Debugger {

  internal var gameBoy:   GameBoy
  internal var cpu:       Cpu       { return gameBoy.cpu }
  internal var registers: Registers { return gameBoy.cpu.registers }
  internal var bus:       Bus       { return gameBoy.bus }

  public init(gameBoy: GameBoy) {
    self.gameBoy = gameBoy
  }

  public func run(mode:         DebugMode = .none,
                  instructions: Int64     = Int64.max,
                  lastPC:       UInt16    = UInt16.max) {

    if mode == .none {
      self.runDebugNone(instructions: instructions, lastPC: lastPC)
      return
    }

    var stateBefore = GameBoyState()
    var stateAfter  = GameBoyState()
    var remainingInstructions = instructions

    while remainingInstructions > 0 && self.cpu.pc != lastPC {
      if mode == .opcodes || mode == .opcodesAndWrites || mode == .full {
        self.printNextOpcode()
      }

      self.gameBoy.save(to: &stateBefore)
      self.gameBoy.tickCpu(cycles: 1)
      self.gameBoy.save(to: &stateAfter)

      if mode == .opcodesAndWrites || mode == .full {
        self.printRegiserWrites(before: stateBefore, after: stateAfter)
        self.printMemoryWrites(before: stateBefore, after: stateAfter)
        self.printOpcodeDetails(before: stateBefore, after: stateAfter)
      }

      if mode == .full {
        self.printRegisterValues()
        print()
      }

      remainingInstructions -= 1
    }
  }

  // Waaaaay faster than normal debug
  private func runDebugNone(instructions: Int64     = Int64.max,
                            lastPC:       UInt16    = UInt16.max) {

    var remainingInstructions = instructions

    while remainingInstructions > 0 && self.cpu.pc != lastPC {
      self.gameBoy.tickCpu(cycles: 1)
      remainingInstructions -= 1
    }
  }
}
