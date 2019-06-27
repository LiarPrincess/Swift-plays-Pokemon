// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public class Debugger {

  internal var gameBoy:   GameBoy
  internal var cpu:       Cpu       { return gameBoy.cpu }
  internal var registers: Registers { return gameBoy.cpu.registers }
  internal var bus:       Bus       { return gameBoy.bus }

  private var stateBefore = GameBoyState()
  private var stateAfter  = GameBoyState()

  public init(gameBoy: GameBoy) {
    self.gameBoy = gameBoy
  }

  public func run(mode:         DebugMode = .none,
                  instructions: Int64     = .max,
                  untilPC pc:   UInt16    = .max) {

    if mode == .none {
      self.runDebugNone(instructions: instructions, untilPC: pc)
      return
    }

    var remainingInstructions = instructions

    while remainingInstructions > 0 && self.cpu.pc != pc {
      if mode == .opcodes || mode == .opcodesAndWrites || mode == .full {
        self.printNextOpcode()
      }

      self.gameBoy.save(to: &self.stateBefore)
      self.gameBoy.tickCpu(cycles: 1)
      self.gameBoy.save(to: &self.stateAfter)

      if mode == .opcodesAndWrites || mode == .full {
        self.printRegiserWrites(before: self.stateBefore, after: stateAfter)
        self.printMemoryWrites(before: self.stateBefore, after: stateAfter)
        self.printOpcodeDetails(before: self.stateBefore, after: stateAfter)
      }

      if mode == .full {
        self.printRegisterValues()
        print()
      }

      remainingInstructions -= 1
    }
  }

  // Waaaaay faster than normal debug
  private func runDebugNone(instructions: Int64  = .max,
                            untilPC pc:   UInt16 = .max) {

    var remainingInstructions = instructions

    while remainingInstructions > 0 && self.cpu.pc != pc {
      self.gameBoy.tickCpu(cycles: 1)
      remainingInstructions -= 1
    }
  }
}
