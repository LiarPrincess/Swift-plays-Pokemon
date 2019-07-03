// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public class Debugger {

  internal var gameBoy:   GameBoy
  internal var cpu:       Cpu       { return gameBoy.cpu }
  internal var registers: Registers { return gameBoy.cpu.registers }
  internal var bus:       Bus       { return gameBoy.bus }

  private var stateBefore = DebugState()
  private var stateAfter  = DebugState()

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

    self.fill(state: &self.stateBefore)
    var remainingInstructions = instructions

    while remainingInstructions > 0 && self.cpu.pc != pc {
      if mode == .opcodes || mode == .opcodesAndWrites || mode == .full {
        self.printNextOpcode()
      }

      self.gameBoy.tickCpu(cycles: 1)
      self.fill(state: &self.stateAfter)

      if mode == .opcodesAndWrites || mode == .full {
        self.printRegiserWrites(before: self.stateBefore, after: stateAfter)
        self.printMemoryWrites(before:  self.stateBefore, after: stateAfter)
        self.printOpcodeDetails(before: self.stateBefore, after: stateAfter)
      }

      if mode == .full {
        self.printRegisterValues()
        print() // otherwise it would be too dense
      }

      self.stateBefore = self.stateAfter
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

// MARK: - Fill state

extension Debugger {

  private func fill(state: inout DebugState) {
    self.fillCpu(cpu: &state.cpu)
    self.fillIO(io: &state.io)
    self.fillTimer(timer: &state.timer)
    self.fillAudio(audio: &state.audio)
    self.fillLcd(lcd: &state.lcd)
    self.fillInterrupts(interrupts: &state.interrupts)
  }

  private func fillCpu(cpu: inout DebugCpuState) {
    cpu.a = self.gameBoy.cpu.registers.a
    cpu.b = self.gameBoy.cpu.registers.b
    cpu.c = self.gameBoy.cpu.registers.c
    cpu.d = self.gameBoy.cpu.registers.d
    cpu.e = self.gameBoy.cpu.registers.e
    cpu.h = self.gameBoy.cpu.registers.h
    cpu.l = self.gameBoy.cpu.registers.l

    cpu.zeroFlag      = self.gameBoy.cpu.registers.zeroFlag
    cpu.subtractFlag  = self.gameBoy.cpu.registers.subtractFlag
    cpu.halfCarryFlag = self.gameBoy.cpu.registers.halfCarryFlag
    cpu.carryFlag     = self.gameBoy.cpu.registers.carryFlag

    cpu.pc = self.gameBoy.cpu.pc
    cpu.sp = self.gameBoy.cpu.sp
  }

  private func fillIO(io: inout DebugIOState) {
    io.joypad = self.gameBoy.bus.read(MemoryMap.IO.joypad)
    io.sb     = self.gameBoy.bus.read(MemoryMap.IO.sb)
    io.sc     = self.gameBoy.bus.read(MemoryMap.IO.sc)
    io.unmapBootrom = self.gameBoy.bus.read(MemoryMap.IO.unmapBootrom)
  }

  private func fillTimer(timer: inout DebugTimerState) {
    timer.div  = self.gameBoy.bus.read(MemoryMap.Timer.div)
    timer.tima = self.gameBoy.bus.read(MemoryMap.Timer.tima)
    timer.tma  = self.gameBoy.bus.read(MemoryMap.Timer.tma)
    timer.tac  = self.gameBoy.bus.read(MemoryMap.Timer.tac)
  }

  private func fillAudio(audio: inout DebugAudioState) {
    audio.nr10 = self.gameBoy.bus.read(MemoryMap.Audio.nr10)
    audio.nr11 = self.gameBoy.bus.read(MemoryMap.Audio.nr11)
    audio.nr12 = self.gameBoy.bus.read(MemoryMap.Audio.nr12)
    audio.nr13 = self.gameBoy.bus.read(MemoryMap.Audio.nr13)
    audio.nr14 = self.gameBoy.bus.read(MemoryMap.Audio.nr14)
    audio.nr21 = self.gameBoy.bus.read(MemoryMap.Audio.nr21)
    audio.nr22 = self.gameBoy.bus.read(MemoryMap.Audio.nr22)
    audio.nr23 = self.gameBoy.bus.read(MemoryMap.Audio.nr23)
    audio.nr24 = self.gameBoy.bus.read(MemoryMap.Audio.nr24)
    audio.nr30 = self.gameBoy.bus.read(MemoryMap.Audio.nr30)
    audio.nr31 = self.gameBoy.bus.read(MemoryMap.Audio.nr31)
    audio.nr32 = self.gameBoy.bus.read(MemoryMap.Audio.nr32)
    audio.nr33 = self.gameBoy.bus.read(MemoryMap.Audio.nr33)
    audio.nr34 = self.gameBoy.bus.read(MemoryMap.Audio.nr34)
    audio.nr41 = self.gameBoy.bus.read(MemoryMap.Audio.nr41)
    audio.nr42 = self.gameBoy.bus.read(MemoryMap.Audio.nr42)
    audio.nr43 = self.gameBoy.bus.read(MemoryMap.Audio.nr43)
    audio.nr44 = self.gameBoy.bus.read(MemoryMap.Audio.nr44)
    audio.nr50 = self.gameBoy.bus.read(MemoryMap.Audio.nr50)
    audio.nr51 = self.gameBoy.bus.read(MemoryMap.Audio.nr51)
    audio.nr52 = self.gameBoy.bus.read(MemoryMap.Audio.nr52)
    audio.nr3_ram_start = self.gameBoy.bus.read(MemoryMap.Audio.nr3_ram_start)
    audio.nr3_ram_end   = self.gameBoy.bus.read(MemoryMap.Audio.nr3_ram_end)
  }

  private func fillLcd(lcd: inout DebugLcdState) {
    lcd.control          = self.gameBoy.bus.read(MemoryMap.Lcd.control)
    lcd.status           = self.gameBoy.bus.read(MemoryMap.Lcd.status)
    lcd.scrollY          = self.gameBoy.bus.read(MemoryMap.Lcd.scrollY)
    lcd.scrollX          = self.gameBoy.bus.read(MemoryMap.Lcd.scrollX)
    lcd.line             = self.gameBoy.bus.read(MemoryMap.Lcd.line)
    lcd.lineCompare      = self.gameBoy.bus.read(MemoryMap.Lcd.lineCompare)
    lcd.dma              = self.gameBoy.bus.read(MemoryMap.Lcd.dma)
    lcd.backgroundColors = self.gameBoy.bus.read(MemoryMap.Lcd.backgroundColors)
    lcd.objectColors0    = self.gameBoy.bus.read(MemoryMap.Lcd.objectColors0)
    lcd.objectColors1    = self.gameBoy.bus.read(MemoryMap.Lcd.objectColors1)
    lcd.windowY          = self.gameBoy.bus.read(MemoryMap.Lcd.windowY)
    lcd.windowX          = self.gameBoy.bus.read(MemoryMap.Lcd.windowX)
  }

  private func fillInterrupts(interrupts: inout DebugInterruptState) {
    interrupts.enable = self.gameBoy.bus.read(MemoryMap.interruptEnable)
    interrupts.flag   = self.gameBoy.bus.read(MemoryMap.IO.interruptFlag)
  }
}
