// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftlint:disable closure_body_length
// swiftlint:disable cyclomatic_complexity

import GameBoyKit

var checkedAddresses: [UInt16] = {
  var result = Set<UInt16>()

  // add all interesting regions
  MemoryMap.rom0.forEach { result.insert($0) }
  MemoryMap.rom1.forEach { result.insert($0) }
  MemoryMap.videoRam.forEach { result.insert($0) }
  MemoryMap.externalRam.forEach { result.insert($0) }
  MemoryMap.internalRam.forEach { result.insert($0) }
  MemoryMap.internalRamEcho.forEach { result.insert($0) }
  MemoryMap.oam.forEach { result.insert($0) }
  MemoryMap.notUsable.forEach { result.insert($0) }
  result.insert(MemoryMap.IO.joypad)
  result.insert(MemoryMap.IO.sb)
  result.insert(MemoryMap.IO.sc)
  result.insert(MemoryMap.IO.unmapBootrom)
  result.insert(MemoryMap.Timer.div)
  result.insert(MemoryMap.Timer.tima)
  result.insert(MemoryMap.Timer.tma)
  result.insert(MemoryMap.Timer.tac)
  result.insert(MemoryMap.Audio.nr10)
  result.insert(MemoryMap.Audio.nr11)
  result.insert(MemoryMap.Audio.nr12)
  result.insert(MemoryMap.Audio.nr13)
  result.insert(MemoryMap.Audio.nr14)
  result.insert(MemoryMap.Audio.nr21)
  result.insert(MemoryMap.Audio.nr22)
  result.insert(MemoryMap.Audio.nr23)
  result.insert(MemoryMap.Audio.nr24)
  result.insert(MemoryMap.Audio.nr30)
  result.insert(MemoryMap.Audio.nr31)
  result.insert(MemoryMap.Audio.nr32)
  result.insert(MemoryMap.Audio.nr33)
  result.insert(MemoryMap.Audio.nr34)
  result.insert(MemoryMap.Audio.nr41)
  result.insert(MemoryMap.Audio.nr42)
  result.insert(MemoryMap.Audio.nr43)
  result.insert(MemoryMap.Audio.nr44)
  result.insert(MemoryMap.Audio.nr50)
  result.insert(MemoryMap.Audio.nr51)
  result.insert(MemoryMap.Audio.nr52)
  result.insert(MemoryMap.Audio.nr3_ram_start)
  result.insert(MemoryMap.Audio.nr3_ram_end)
  result.insert(MemoryMap.Lcd.control)
  result.insert(MemoryMap.Lcd.status)
  result.insert(MemoryMap.Lcd.scrollY)
  result.insert(MemoryMap.Lcd.scrollX)
  result.insert(MemoryMap.Lcd.line)
  result.insert(MemoryMap.Lcd.lineCompare)
  result.insert(MemoryMap.Lcd.dma)
  result.insert(MemoryMap.Lcd.backgroundColors)
  result.insert(MemoryMap.Lcd.objectColors0)
  result.insert(MemoryMap.Lcd.objectColors1)
  result.insert(MemoryMap.Lcd.windowY)
  result.insert(MemoryMap.Lcd.windowX)
  MemoryMap.highRam.forEach { result.insert($0) }
  result.insert(MemoryMap.interruptEnable)

  // and remove some of them
  (0x0000...0x00ff).forEach { result.remove($0) } // bootrom
  (0x0104...0x014f).forEach { result.remove($0) } // nintendo logo + checksum

  return [UInt16](result).sorted()
}()

func pyTest(pyBoy p: PyBoy, swiftBoy s: GameBoy) {
  print("\(p.filename)")

  if s.cpu.pc  != p.cpu.pc  { print("  pc: \(s.cpu.pc.hex) vs \(p.cpu.pc.hex)") }
  if s.cpu.sp  != p.cpu.sp  { print("  sp: \(s.cpu.sp.hex) vs \(p.cpu.sp.hex)") }
  if s.cpu.ime != p.cpu.ime { print("  ime: \(s.cpu.ime) vs \(p.cpu.ime)") }

  let pReg = p.cpu.registers
  let sReg = s.cpu.registers
  if sReg.a != pReg.a { print("  a: \(sReg.a.hex) vs \(pReg.a.hex)") }
  if sReg.b != pReg.b { print("  b: \(sReg.b.hex) vs \(pReg.b.hex)") }
  if sReg.c != pReg.c { print("  c: \(sReg.c.hex) vs \(pReg.c.hex)") }
  if sReg.d != pReg.d { print("  d: \(sReg.d.hex) vs \(pReg.d.hex)") }
  if sReg.e != pReg.e { print("  e: \(sReg.e.hex) vs \(pReg.e.hex)") }
  if sReg.h != pReg.h { print("  h: \(sReg.h.hex) vs \(pReg.h.hex)") }
  if sReg.l != pReg.l { print("  l: \(sReg.l.hex) vs \(pReg.l.hex)") }

  if sReg.zeroFlag      != pReg.zeroFlag      { print("  zeroFlag: \(sReg.zeroFlag) vs \(pReg.zeroFlag)") }
  if sReg.subtractFlag  != pReg.subtractFlag  { print("  subtractFlag: \(sReg.subtractFlag) vs \(pReg.subtractFlag)") }
  if sReg.halfCarryFlag != pReg.halfCarryFlag { print("  halfCarryFlag: \(sReg.halfCarryFlag) vs \(pReg.halfCarryFlag)") }
  if sReg.carryFlag     != pReg.carryFlag     { print("  carryFlag: \(sReg.carryFlag) vs \(pReg.carryFlag)") }

  for address in checkedAddresses {
    let pValue = p.memory.data[Int(address)]
    let sValue = s.bus.read(address)

    if sValue != pValue {
      let desc = MemoryMap.describe(address: address)
      print("  memory \(address.hex): \(sValue.hex) vs \(pValue.hex) (\(desc))")
    }
  }
}
