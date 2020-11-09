// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public final class Debugger {

  public enum Mode {
    /// Print nothing
    case none
    /// Print only executed opcodes
    case opcodes
    /// Print only executed opcodes and memory writes
    case opcodesAndWrites
    /// Print everything
    case full
  }

  internal var gameBoy: GameBoy
  internal var cpu: Cpu { return self.gameBoy.cpu }
  internal var memory: Memory { return self.gameBoy.memory }
  internal var lcd: Lcd { return self.gameBoy.lcd }

  public init(gameBoy: GameBoy) {
    self.gameBoy = gameBoy
  }

  // MARK: - Run

  public func run(mode: Mode,
                  instructions: Int64 = .max,
                  untilPC pc: UInt16 = .max)
  {
    if mode == .none {
      self.runDebugNone(instructions: instructions, untilPC: pc)
      return
    }

    var stateBefore = self.captureState()
    var remainingInstructions = instructions

    while remainingInstructions > 0 && self.cpu.pc != pc {
      if mode == .opcodes || mode == .opcodesAndWrites || mode == .full {
        self.printNextOpcode()
      }

      self.gameBoy.tickCpu(cycles: 1)
      let stateAfter = self.captureState()

      if mode == .opcodesAndWrites || mode == .full {
        self.printRegiserWrites(before: stateBefore, after: stateAfter)
        self.printMemoryWrites(before: stateBefore, after: stateAfter)
        self.printExecutedOpcodeDetails(before: stateBefore, after: stateAfter)
      }

      if mode == .full {
        self.dumpCpuState()
        print() // otherwise it would be too dense
      }

      stateBefore = stateAfter
      remainingInstructions -= 1
    }
  }

  // Waaaaay faster than normal debug
  private func runDebugNone(instructions: Int64 = .max,
                            untilPC pc: UInt16 = .max)
  {
    var remainingInstructions = instructions

    while remainingInstructions > 0 && self.cpu.pc != pc {
      self.gameBoy.tickCpu(cycles: 1)
      remainingInstructions -= 1
    }
  }
}

// MARK: - Fill state

// swiftformat:disable consecutiveSpaces

extension Debugger {

  private func captureState() -> DebugState {
    return DebugState(
      cpu: self.captureCpuState(),
      io:  self.captureIOState(),
      timer: self.captureTimerState(),
      audio: self.captureAudioState(),
      lcd:   self.captureLcdState(),
      interrupts: self.captureInterruptsState()
    )
  }

  private func captureCpuState() -> DebugState.Cpu {
    return DebugState.Cpu(
      a: self.cpu.registers.a,
      b: self.cpu.registers.b,
      c: self.cpu.registers.c,
      d: self.cpu.registers.d,
      e: self.cpu.registers.e,
      h: self.cpu.registers.h,
      l: self.cpu.registers.l,
      zeroFlag:      self.cpu.registers.zeroFlag,
      subtractFlag:  self.cpu.registers.subtractFlag,
      halfCarryFlag: self.cpu.registers.halfCarryFlag,
      carryFlag:     self.cpu.registers.carryFlag,
      pc: self.cpu.pc,
      sp: self.cpu.sp
    )
  }

  private func captureIOState() -> DebugState.IO {
    return DebugState.IO(
      joypad: self.memory.read(MemoryMap.IO.joypad),
      sb: self.memory.read(MemoryMap.IO.sb),
      sc: self.memory.read(MemoryMap.IO.sc),
      unmapBootrom: self.memory.read(MemoryMap.IO.unmapBootrom)
    )
  }

  private func captureTimerState() -> DebugState.Timer {
    return DebugState.Timer(
      div: self.memory.read(MemoryMap.Timer.div),
      tima: self.memory.read(MemoryMap.Timer.tima),
      tma: self.memory.read(MemoryMap.Timer.tma),
      tac: self.memory.read(MemoryMap.Timer.tac)
    )
  }

  private func captureAudioState() -> DebugState.Audio {
    return DebugState.Audio(
      nr10: self.memory.read(MemoryMap.Audio.nr10),
      nr11: self.memory.read(MemoryMap.Audio.nr11),
      nr12: self.memory.read(MemoryMap.Audio.nr12),
      nr13: self.memory.read(MemoryMap.Audio.nr13),
      nr14: self.memory.read(MemoryMap.Audio.nr14),
      nr21: self.memory.read(MemoryMap.Audio.nr21),
      nr22: self.memory.read(MemoryMap.Audio.nr22),
      nr23: self.memory.read(MemoryMap.Audio.nr23),
      nr24: self.memory.read(MemoryMap.Audio.nr24),
      nr30: self.memory.read(MemoryMap.Audio.nr30),
      nr31: self.memory.read(MemoryMap.Audio.nr31),
      nr32: self.memory.read(MemoryMap.Audio.nr32),
      nr33: self.memory.read(MemoryMap.Audio.nr33),
      nr34: self.memory.read(MemoryMap.Audio.nr34),
      nr41: self.memory.read(MemoryMap.Audio.nr41),
      nr42: self.memory.read(MemoryMap.Audio.nr42),
      nr43: self.memory.read(MemoryMap.Audio.nr43),
      nr44: self.memory.read(MemoryMap.Audio.nr44),
      nr50: self.memory.read(MemoryMap.Audio.nr50),
      nr51: self.memory.read(MemoryMap.Audio.nr51),
      nr52: self.memory.read(MemoryMap.Audio.nr52),
      nr3_ram_start: self.memory.read(MemoryMap.Audio.nr3_ram_start),
      nr3_ram_end:   self.memory.read(MemoryMap.Audio.nr3_ram_end)
    )
  }

  private func captureLcdState() -> DebugState.Lcd {
    return DebugState.Lcd(
      control: self.memory.read(MemoryMap.Lcd.control),
      status:  self.memory.read(MemoryMap.Lcd.status),
      scrollY: self.memory.read(MemoryMap.Lcd.scrollY),
      scrollX: self.memory.read(MemoryMap.Lcd.scrollX),
      line:    self.memory.read(MemoryMap.Lcd.line),
      lineCompare: self.memory.read(MemoryMap.Lcd.lineCompare),
      dma:         self.memory.read(MemoryMap.Lcd.dma),
      backgroundPalette: self.memory.read(MemoryMap.Lcd.backgroundPalette),
      spritePalette0:    self.memory.read(MemoryMap.Lcd.spritePalette0),
      spritePalette1:    self.memory.read(MemoryMap.Lcd.spritePalette1),
      windowY: self.memory.read(MemoryMap.Lcd.windowY),
      windowX: self.memory.read(MemoryMap.Lcd.windowX)
    )
  }

  private func captureInterruptsState() -> DebugState.Interrupts {
    return DebugState.Interrupts(
      enable: self.memory.read(MemoryMap.interruptEnable),
      flag: self.memory.read(MemoryMap.IO.interruptFlag)
    )
  }
}
