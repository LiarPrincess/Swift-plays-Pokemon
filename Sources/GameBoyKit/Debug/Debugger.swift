// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public class Debugger {

  internal var gameBoy:   GameBoy
  internal var cpu:       Cpu    { return gameBoy.cpu }
  internal var memory:    Memory { return gameBoy.memory }
  internal var lcd:       LcdImpl { return gameBoy._lcd }

  private var stateBefore = DebugState()
  private var stateAfter  = DebugState()

  public init(gameBoy: GameBoy) {
    self.gameBoy = gameBoy
  }

  // MARK: - Run

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

  // MARK: - Dump lcd

  public func dumpLcdProperties() {
    self.lcd.dumpProperties()
  }

  public func dumpTileIndices(_ map: TileMap) {
    self.lcd.dumpTileIndices(map)
  }

  public func dumpTileData(_ data: TileData) {
    self.lcd.dumpTileData(data)
  }

  public func dumpBackground(_ map: TileMap, _ data: TileData) {
    self.lcd.dumpBackground(map, data)
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
    cpu.a = self.cpu.registers.a
    cpu.b = self.cpu.registers.b
    cpu.c = self.cpu.registers.c
    cpu.d = self.cpu.registers.d
    cpu.e = self.cpu.registers.e
    cpu.h = self.cpu.registers.h
    cpu.l = self.cpu.registers.l

    cpu.zeroFlag      = self.cpu.registers.zeroFlag
    cpu.subtractFlag  = self.cpu.registers.subtractFlag
    cpu.halfCarryFlag = self.cpu.registers.halfCarryFlag
    cpu.carryFlag     = self.cpu.registers.carryFlag

    cpu.pc = self.cpu.pc
    cpu.sp = self.cpu.sp
  }

  private func fillIO(io: inout DebugIOState) {
    io.joypad = self.memory.read(MemoryMap.IO.joypad)
    io.sb     = self.memory.read(MemoryMap.IO.sb)
    io.sc     = self.memory.read(MemoryMap.IO.sc)
    io.unmapBootrom = self.memory.read(MemoryMap.IO.unmapBootrom)
  }

  private func fillTimer(timer: inout DebugTimerState) {
    timer.div  = self.memory.read(MemoryMap.Timer.div)
    timer.tima = self.memory.read(MemoryMap.Timer.tima)
    timer.tma  = self.memory.read(MemoryMap.Timer.tma)
    timer.tac  = self.memory.read(MemoryMap.Timer.tac)
  }

  private func fillAudio(audio: inout DebugAudioState) {
    audio.nr10 = self.memory.read(MemoryMap.Audio.nr10)
    audio.nr11 = self.memory.read(MemoryMap.Audio.nr11)
    audio.nr12 = self.memory.read(MemoryMap.Audio.nr12)
    audio.nr13 = self.memory.read(MemoryMap.Audio.nr13)
    audio.nr14 = self.memory.read(MemoryMap.Audio.nr14)
    audio.nr21 = self.memory.read(MemoryMap.Audio.nr21)
    audio.nr22 = self.memory.read(MemoryMap.Audio.nr22)
    audio.nr23 = self.memory.read(MemoryMap.Audio.nr23)
    audio.nr24 = self.memory.read(MemoryMap.Audio.nr24)
    audio.nr30 = self.memory.read(MemoryMap.Audio.nr30)
    audio.nr31 = self.memory.read(MemoryMap.Audio.nr31)
    audio.nr32 = self.memory.read(MemoryMap.Audio.nr32)
    audio.nr33 = self.memory.read(MemoryMap.Audio.nr33)
    audio.nr34 = self.memory.read(MemoryMap.Audio.nr34)
    audio.nr41 = self.memory.read(MemoryMap.Audio.nr41)
    audio.nr42 = self.memory.read(MemoryMap.Audio.nr42)
    audio.nr43 = self.memory.read(MemoryMap.Audio.nr43)
    audio.nr44 = self.memory.read(MemoryMap.Audio.nr44)
    audio.nr50 = self.memory.read(MemoryMap.Audio.nr50)
    audio.nr51 = self.memory.read(MemoryMap.Audio.nr51)
    audio.nr52 = self.memory.read(MemoryMap.Audio.nr52)
    audio.nr3_ram_start = self.memory.read(MemoryMap.Audio.nr3_ram_start)
    audio.nr3_ram_end   = self.memory.read(MemoryMap.Audio.nr3_ram_end)
  }

  private func fillLcd(lcd: inout DebugLcdState) {
    lcd.control     = self.memory.read(MemoryMap.Lcd.control)
    lcd.status      = self.memory.read(MemoryMap.Lcd.status)
    lcd.scrollY     = self.memory.read(MemoryMap.Lcd.scrollY)
    lcd.scrollX     = self.memory.read(MemoryMap.Lcd.scrollX)
    lcd.line        = self.memory.read(MemoryMap.Lcd.line)
    lcd.lineCompare = self.memory.read(MemoryMap.Lcd.lineCompare)
    lcd.dma         = self.memory.read(MemoryMap.Lcd.dma)
    lcd.backgroundPalette = self.memory.read(MemoryMap.Lcd.backgroundPalette)
    lcd.spritePalette0    = self.memory.read(MemoryMap.Lcd.spritePalette0)
    lcd.spritePalette1    = self.memory.read(MemoryMap.Lcd.spritePalette1)
    lcd.windowY = self.memory.read(MemoryMap.Lcd.windowY)
    lcd.windowX = self.memory.read(MemoryMap.Lcd.windowX)
  }

  private func fillInterrupts(interrupts: inout DebugInterruptState) {
    interrupts.enable = self.memory.read(MemoryMap.interruptEnable)
    interrupts.flag   = self.memory.read(MemoryMap.IO.interruptFlag)
  }
}
