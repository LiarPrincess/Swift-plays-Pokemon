// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftlint:disable closure_body_length
// swiftlint:disable cyclomatic_complexity

import GameBoyKit

var checkedAddresses: [UInt16] = {
  var result = Set<UInt16>()

  // add all interesting regions
  //  MemoryMap.rom0 - no need to check rom
  //  MemoryMap.rom1 - no need to check rom

//  MemoryMap.videoRam.forEach { result.insert($0) }
  MemoryMap.externalRam.forEach { result.insert($0) }
  MemoryMap.internalRam.forEach { result.insert($0) }
  // MemoryMap.internalRamEcho - we have unit tests for this
//  MemoryMap.oam.forEach { result.insert($0) }
  MemoryMap.notUsable.forEach { result.insert($0) }

//  result.insert(MemoryMap.IO.joypad) // not yet implemented
//  result.insert(MemoryMap.IO.sb) // not yet implemented
//  result.insert(MemoryMap.IO.sc)

  result.insert(MemoryMap.IO.unmapBootrom)

//  result.insert(MemoryMap.Timer.div)
//  result.insert(MemoryMap.Timer.tima)
//  result.insert(MemoryMap.Timer.tma)
//  result.insert(MemoryMap.Timer.tac)

//  result.insert(MemoryMap.Audio.nr10) // not yet implemented
//  result.insert(MemoryMap.Audio.nr11)
//  result.insert(MemoryMap.Audio.nr12)
//  result.insert(MemoryMap.Audio.nr13)
//  result.insert(MemoryMap.Audio.nr14)
//  result.insert(MemoryMap.Audio.nr21)
//  result.insert(MemoryMap.Audio.nr22)
//  result.insert(MemoryMap.Audio.nr23)
//  result.insert(MemoryMap.Audio.nr24)
//  result.insert(MemoryMap.Audio.nr30)
//  result.insert(MemoryMap.Audio.nr31)
//  result.insert(MemoryMap.Audio.nr32)
//  result.insert(MemoryMap.Audio.nr33)
//  result.insert(MemoryMap.Audio.nr34)
//  result.insert(MemoryMap.Audio.nr41)
//  result.insert(MemoryMap.Audio.nr42)
//  result.insert(MemoryMap.Audio.nr43)
//  result.insert(MemoryMap.Audio.nr44)
//  result.insert(MemoryMap.Audio.nr50)
//  result.insert(MemoryMap.Audio.nr51)
//  result.insert(MemoryMap.Audio.nr52)
//  result.insert(MemoryMap.Audio.nr3_ram_start)
//  result.insert(MemoryMap.Audio.nr3_ram_end)

  result.insert(MemoryMap.Lcd.control)
//  result.insert(MemoryMap.Lcd.status)
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

  return [UInt16](result).sorted()
}()

func compare(saved p: SavedState, gameboy g: GameBoy) -> Bool {
  var e = false // has error

  if g.cpu.pc  != p.cpu.pc  { print("Invalid pc: \(g.cpu.pc.hex) vs \(p.cpu.pc.hex)"); e = true }
  if g.cpu.sp  != p.cpu.sp  { print("Invalid sp: \(g.cpu.sp.hex) vs \(p.cpu.sp.hex)"); e = true }
  if g.cpu.ime != p.cpu.ime { print("Invalid ime: \(g.cpu.ime) vs \(p.cpu.ime)"); e = true }

  let pReg = p.cpu.registers
  let gReg = g.cpu.registers
  if gReg.a != pReg.a { print("Invalid a: \(gReg.a.hex) vs \(pReg.a.hex)"); e = true }
  if gReg.b != pReg.b { print("Invalid b: \(gReg.b.hex) vs \(pReg.b.hex)"); e = true }
  if gReg.c != pReg.c { print("Invalid c: \(gReg.c.hex) vs \(pReg.c.hex)"); e = true }
  if gReg.d != pReg.d { print("Invalid d: \(gReg.d.hex) vs \(pReg.d.hex)"); e = true }
  if gReg.e != pReg.e { print("Invalid e: \(gReg.e.hex) vs \(pReg.e.hex)"); e = true }
  if gReg.h != pReg.h { print("Invalid h: \(gReg.h.hex) vs \(pReg.h.hex)"); e = true }
  if gReg.l != pReg.l { print("Invalid l: \(gReg.l.hex) vs \(pReg.l.hex)"); e = true }

  if gReg.zeroFlag      != pReg.zeroFlag      { print("Invalid zeroFlag: \(gReg.zeroFlag) vs \(pReg.zeroFlag)"); e = true }
  if gReg.subtractFlag  != pReg.subtractFlag  { print("Invalid subtractFlag: \(gReg.subtractFlag) vs \(pReg.subtractFlag)"); e = true }
  if gReg.halfCarryFlag != pReg.halfCarryFlag { print("Invalid halfCarryFlag: \(gReg.halfCarryFlag) vs \(pReg.halfCarryFlag)"); e = true }
  if gReg.carryFlag     != pReg.carryFlag     { print("Invalid carryFlag: \(gReg.carryFlag) vs \(pReg.carryFlag)"); e = true }

  for address in checkedAddresses {
    let pValue = p.memory.data[Int(address)]
    let sValue = g.bus.read(address)

    if sValue != pValue {
      let desc = MemoryMap.describe(address: address)
      print("Invalid memory \(address.hex): \(sValue.hex) vs \(pValue.hex) (\(desc))")
      e = true
    }
  }

  return e
}
