// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftlint:disable function_body_length
// swiftlint:disable cyclomatic_complexity

import GameBoyKit

private var checkedAddresses: Set<UInt16> {
  var result = Set<UInt16>()
  MemoryMap.rom0.forEach { result.insert($0) }
  MemoryMap.rom1.forEach { result.insert($0) }
  MemoryMap.videoRam.forEach { result.insert($0) }
  MemoryMap.externalRam.forEach { result.insert($0) }
  MemoryMap.internalRam.forEach { result.insert($0) }
  MemoryMap.internalRamEcho.forEach { result.insert($0) }
  MemoryMap.oam.forEach { result.insert($0) }
  MemoryMap.notUsable.forEach { result.insert($0) }
  MemoryMap.io.forEach { result.insert($0) }
  result.insert(MemoryMap.unmapBootrom)
  MemoryMap.highRam.forEach { result.insert($0) }
  result.insert(MemoryMap.interruptEnable)
  //  (0x0000...0x00ff).forEach { skipAddress.insert($0) } // bootrom
  //  (0x0104...0x0133).forEach { skipAddress.insert($0) } // nintendo logo
  //  (0xfea0...0xfeff).forEach { skipAddress.insert($0) } // not usable
  return []
}

func pyTest(_ p: PyBoy) {
  print("\(p.filename) <-- starting")

  let s = GameBoy()
  let debugger = Debugger(mode: .none)
  debugger.attach(s)
  debugger.run(cycles: .max, lastPC: p.cpu.pc)

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
    let pValue = p.memory.data[address]
    let sValue = s.bus.read(address)

    if sValue != pValue {
      print("  mem \(address.hex): \(sValue.hex) vs \(pValue.hex)")
    }
  }
}
