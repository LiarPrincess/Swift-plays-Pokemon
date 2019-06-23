// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import GameBoyKit

private var programCounters: [String] = [
  "0x03", "0x04", "0x07", "0x08", "0x0a", "0x0c", "0x0f",
  "0x11", "0x13", "0x14", "0x15", "0x16", "0x18", "0x19", "0x1a", "0x1c", "0x1d", "0x1f",
  "0x21", "0x24", "0x27", "0x28",
  "0x95", "0x96", "0x98", "0x99", "0x9b", "0x9c", "0x9d", "0x9f",
  "0xa0", "0xa1", "0xa3", "0xa4", "0xa5", "0xa6", "0xa7",
  "0x2b", "0x2e", "0x2f",
  "0x30", "0x32", "0x34", "0x37", "0x39", "0x3a", "0x3b", "0x3c", "0x3d", "0x3e",
  "0x40", "0x42", "0x45", "0x48", "0x4a", "0x4b", "0x4d", "0x4e", "0x4f",
  "0x51", "0x53", "0x55", "0x56", "0x58", "0x59", "0x5b", "0x5d", "0x5f",
  "0x60", "0x62", "0x64", "0x66", "0x68", "0x6a", "0x6b", "0x6d", "0x6e",
  "0x70", "0x72", "0x73", "0x74", "0x76", "0x78", "0x7a", "0x7c", "0x7e",
  "0x86", "0x88", "0x89", "0x8b", "0x8c", "0x80", "0x81", "0x82", "0x83", "0x85", "0x8e", "0x8f",
  "0x91", "0x93",
  "0xe0", "0xe3", "0xe6", "0xe7", "0xe8", "0xe9", "0xeb",
  "0xec", "0xed", "0xef",
  "0xf1", "0xf3", "0xf4", "0xf5", "0xf6", "0xf7", "0xf9", "0xfa", "0xfc", "0xfe",
  /* "0x100" */
]

internal func pyBoyBootromTests() {
  let gameBoy = GameBoy()
  let debugger = Debugger(gameBoy: gameBoy)

  let currentFile = URL(fileURLWithPath: #file)
  let mainDir     = currentFile.deletingLastPathComponent()
  let bootromPath = mainDir.appendingPathComponent("PyBootromFiles")

  for pc in programCounters {
    let fileName = "pyboy_bootrom_pc_\(pc).txt"
    let fileUrl = bootromPath.appendingPathComponent(fileName)
    let pyBoy = pyLoad(fileUrl)

    debugger.run(mode: .none, lastPC: pyBoy.cpu.pc)
    pyTest(pyBoy: pyBoy, swiftBoy: gameBoy)
  }

  testStateBeforeUnmappingBootrom(gameBoy)
}

// source: http://www.codeslinger.co.uk/pages/projects/gameboy/hardware.html
private func testStateBeforeUnmappingBootrom(_ s: GameBoy) {
  print("Final state")

  if s.cpu.pc != 0x0100 { print("  pc: \(s.cpu.pc.hex) vs 0x0100") }
  if s.cpu.sp != 0xfffe { print("  sp: \(s.cpu.sp.hex) vs 0xfffe") }

  let sReg = s.cpu.registers
  if sReg.a != 0x01 { print("  a: \(sReg.a.hex) vs 0x01") }
  if sReg.b != 0x00 { print("  b: \(sReg.b.hex) vs 0x00") }
  if sReg.c != 0x13 { print("  c: \(sReg.c.hex) vs 0x13") }
  if sReg.d != 0x00 { print("  d: \(sReg.d.hex) vs 0x00") }
  if sReg.e != 0xd8 { print("  e: \(sReg.e.hex) vs 0xd8") }
  if sReg.h != 0x01 { print("  h: \(sReg.h.hex) vs 0x01") }
  if sReg.l != 0x4d { print("  l: \(sReg.l.hex) vs 0x4d") }

  // 0xb0 = 0b10110000
  if sReg.zeroFlag      != true  { print("  zeroFlag: \(sReg.zeroFlag) vs true") }
  if sReg.subtractFlag  != false { print("  subtractFlag: \(sReg.subtractFlag) vs false") }
  if sReg.halfCarryFlag != true  { print("  halfCarryFlag: \(sReg.halfCarryFlag) vs true") }
  if sReg.carryFlag     != true  { print("  carryFlag: \(sReg.carryFlag) vs true") }

  checkMemory(s, address: 0xff05, value: 0x00)
  checkMemory(s, address: 0xff06, value: 0x00)
  checkMemory(s, address: 0xff07, value: 0x00)
  checkMemory(s, address: 0xff10, value: 0x80)
  checkMemory(s, address: 0xff11, value: 0xbf)
  checkMemory(s, address: 0xff12, value: 0xf3)
  checkMemory(s, address: 0xff14, value: 0xbf)
  checkMemory(s, address: 0xff16, value: 0x3f)
  checkMemory(s, address: 0xff17, value: 0x00)
  checkMemory(s, address: 0xff19, value: 0xbf)
  checkMemory(s, address: 0xff1a, value: 0x7f)
  checkMemory(s, address: 0xff1b, value: 0xff)
  checkMemory(s, address: 0xff1c, value: 0x9f)
  checkMemory(s, address: 0xff1e, value: 0xbf)
  checkMemory(s, address: 0xff20, value: 0xff)
  checkMemory(s, address: 0xff21, value: 0x00)
  checkMemory(s, address: 0xff22, value: 0x00)
  checkMemory(s, address: 0xff23, value: 0xbf)
  checkMemory(s, address: 0xff24, value: 0x77)
  checkMemory(s, address: 0xff25, value: 0xf3)
  checkMemory(s, address: 0xff26, value: 0xf1)
  checkMemory(s, address: 0xff40, value: 0x91)
  checkMemory(s, address: 0xff42, value: 0x00)
  checkMemory(s, address: 0xff43, value: 0x00)
  checkMemory(s, address: 0xff45, value: 0x00)
  checkMemory(s, address: 0xff47, value: 0xfc)
  checkMemory(s, address: 0xff48, value: 0xff)
  checkMemory(s, address: 0xff49, value: 0xff)
  checkMemory(s, address: 0xff4a, value: 0x00)
  checkMemory(s, address: 0xff4b, value: 0x00)
  checkMemory(s, address: 0xffff, value: 0x00)
}

private func checkMemory(_ s: GameBoy, address: UInt16, value: UInt8) {
  let sValue = s.bus.read(address)
  if sValue != value {
    let desc = MemoryMap.describe(address: address)
    print("  memory \(address.hex): \(sValue.hex) vs \(value.hex) (\(desc))")
  }
}
