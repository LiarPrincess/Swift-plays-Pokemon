// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftlint:disable closure_body_length
// swiftlint:disable cyclomatic_complexity

import GameBoyKit

var checkedAddresses: [UInt16] = {
  var result = Set<UInt16>()

  // add all interesting regions
//  MemoryMap.rom0.forEach { result.insert($0) }
//  MemoryMap.rom1.forEach { result.insert($0) }
  MemoryMap.videoRam.forEach { result.insert($0) }
  MemoryMap.externalRam.forEach { result.insert($0) }
  MemoryMap.internalRam.forEach { result.insert($0) }
//  MemoryMap.internalRamEcho.forEach { result.insert($0) }
  MemoryMap.oam.forEach { result.insert($0) }
  MemoryMap.notUsable.forEach { result.insert($0) }
  result.insert(MemoryMap.IO.joypad)
  result.insert(MemoryMap.IO.sb)
  result.insert(MemoryMap.IO.sc)
  result.insert(MemoryMap.IO.unmapBootrom)
//  result.insert(MemoryMap.Timer.div) // pyBoy?
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
//  result.insert(MemoryMap.Lcd.status) // pyBoy?
  result.insert(MemoryMap.Lcd.scrollY)
  result.insert(MemoryMap.Lcd.scrollX)
//  result.insert(MemoryMap.Lcd.line) // pyBoy?
  result.insert(MemoryMap.Lcd.lineCompare)
  result.insert(MemoryMap.Lcd.dma)
//  result.insert(MemoryMap.Lcd.backgroundColors) // pyBoy?
//  result.insert(MemoryMap.Lcd.objectColors0) // pyBoy?
//  result.insert(MemoryMap.Lcd.objectColors1) // pyBoy?
  result.insert(MemoryMap.Lcd.windowY)
  result.insert(MemoryMap.Lcd.windowX)
  MemoryMap.highRam.forEach { result.insert($0) }
  result.insert(MemoryMap.interruptEnable)

  // and remove some of them
  (0x0000...0x00ff).forEach { result.remove($0) } // bootrom
  (0x0104...0x014f).forEach { result.remove($0) } // nintendo logo + checksum

  return [UInt16](result).sorted()
}()

func pyTest(py p: PyBoy, swift s: GameBoy) -> Bool {
  var e = false // has error

  if s.cpu.pc  != p.cpu.pc  { print("Invalid pc: \(s.cpu.pc.hex) vs \(p.cpu.pc.hex)"); e = true }
  if s.cpu.sp  != p.cpu.sp  { print("Invalid sp: \(s.cpu.sp.hex) vs \(p.cpu.sp.hex)"); e = true }
  if s.cpu.ime != p.cpu.ime { print("Invalid ime: \(s.cpu.ime) vs \(p.cpu.ime)"); e = true }

  let pReg = p.cpu.registers
  let sReg = s.cpu.registers
  if sReg.a != pReg.a { print("Invalid a: \(sReg.a.hex) vs \(pReg.a.hex)"); e = true }
  if sReg.b != pReg.b { print("Invalid b: \(sReg.b.hex) vs \(pReg.b.hex)"); e = true }
  if sReg.c != pReg.c { print("Invalid c: \(sReg.c.hex) vs \(pReg.c.hex)"); e = true }
  if sReg.d != pReg.d { print("Invalid d: \(sReg.d.hex) vs \(pReg.d.hex)"); e = true }
  if sReg.e != pReg.e { print("Invalid e: \(sReg.e.hex) vs \(pReg.e.hex)"); e = true }
  if sReg.h != pReg.h { print("Invalid h: \(sReg.h.hex) vs \(pReg.h.hex)"); e = true }
  if sReg.l != pReg.l { print("Invalid l: \(sReg.l.hex) vs \(pReg.l.hex)"); e = true }

  if sReg.zeroFlag      != pReg.zeroFlag      { print("Invalid zeroFlag: \(sReg.zeroFlag) vs \(pReg.zeroFlag)"); e = true }
  if sReg.subtractFlag  != pReg.subtractFlag  { print("Invalid subtractFlag: \(sReg.subtractFlag) vs \(pReg.subtractFlag)"); e = true }
  if sReg.halfCarryFlag != pReg.halfCarryFlag { print("Invalid halfCarryFlag: \(sReg.halfCarryFlag) vs \(pReg.halfCarryFlag)"); e = true }
  if sReg.carryFlag     != pReg.carryFlag     { print("Invalid carryFlag: \(sReg.carryFlag) vs \(pReg.carryFlag)"); e = true }

  for address in checkedAddresses {
    let pValue = p.memory.data[Int(address)]
    let sValue = s.bus.read(address)

    if sValue != pValue {
      let desc = MemoryMap.describe(address: address)
      print("Invalid memory \(address.hex): \(sValue.hex) vs \(pValue.hex) (\(desc))")
      e = true
    }
  }

  return e
}
