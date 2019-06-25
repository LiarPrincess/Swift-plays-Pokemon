// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftlint:disable trailing_comma

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
  let cartridge = createCartridge()
  let gameBoy   = GameBoy(bootrom: .dmg, cartridge: cartridge)
  let debugger  = Debugger(gameBoy: gameBoy)

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

private func createCartridge() -> Cartridge {
  let count = MemoryMap.rom0.count + MemoryMap.rom1.count
  var rom = Data(count: count)
  rom[0x0147] = 0 //
  rom[0x014d] = 231 // just to make checksum happy

  let logoStart = 0x0104
  let logoEnd = logoStart + nintendoLogo.count
  rom.replaceSubrange(logoStart..<logoEnd, with: nintendoLogo)

  // swiftlint:disable:next force_try
  return try! CartridgeFactory.fromData(rom)
}

// swiftlint:disable collection_alignment
private let nintendoLogo: [UInt8] = [
/*           0     1     2     3     4     5     6     7     8     9    a      b     c     d     e     f */
/* 100 */                         0xce, 0xed, 0x66, 0x66, 0xcc, 0x0d, 0x00, 0x0b, 0x03, 0x73, 0x00, 0x83,
/* 110 */ 0x00, 0x0c, 0x00, 0x0d, 0x00, 0x08, 0x11, 0x1f, 0x88, 0x89, 0x00, 0x0e, 0xdc, 0xcc, 0x6e, 0xe6,
/* 120 */ 0xdd, 0xdd, 0xd9, 0x99, 0xbb, 0xbb, 0x67, 0x63, 0x6e, 0x0e, 0xec, 0xcc, 0xdd, 0xdc, 0x99, 0x9f,
/* 130 */ 0xbb, 0xb9, 0x33, 0x3e, /* checksum starts here */
                                  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
/* 140 */ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xe7, 0x00, 0x00
]

// swiftlint:disable:next function_body_length cyclomatic_complexity
private func testStateBeforeUnmappingBootrom(_ s: GameBoy) {
  // source: http://bgb.bircd.org/pandocs.htm#powerupsequence
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

  let values: [UInt16: UInt8] = [
    0xff05: 0x00, // tima
    0xff06: 0x00, // tma
    0xff07: 0x00, // tac
    0xff10: 0x80, // nr10
    0xff11: 0xbf, // nr11
    0xff12: 0xf3, // nr12
    0xff14: 0xbf, // nr14
    0xff16: 0x3f, // nr21
    0xff17: 0x00, // nr22
    0xff19: 0xbf, // nr24
    0xff1a: 0x7f, // nr30
    0xff1b: 0xff, // nr31
    0xff1c: 0x9f, // nr32
    0xff1e: 0xbf, // nr33
    0xff20: 0xff, // nr41
    0xff21: 0x00, // nr42
    0xff22: 0x00, // nr43
    0xff23: 0xbf, // nr30
    0xff24: 0x77, // nr50
    0xff25: 0xf3, // nr51
    0xff26: 0xf1, // nr52 (0xf1-GB, $F0-SGB)
    0xff40: 0x91, // lcdc
    0xff42: 0x00, // scy
    0xff43: 0x00, // scx
    0xff45: 0x00, // lyc
    0xff47: 0xfc, // bgp
    0xff48: 0xff, // obp0
    0xff49: 0xff, // obp1
    0xff4a: 0x00, // wy
    0xff4b: 0x00, // wx
    0xffff: 0x00, // ie
  ]

  for address in checkedAddresses {
    // this does not really matter
    if MemoryMap.videoRam.contains(address) {
      continue
    }

    let value = s.bus.read(address)
    let expected = values[address] ?? 0x00

    if value != expected {
      let desc = MemoryMap.describe(address: address)
      print("  memory \(address.hex): \(value.hex) vs \(expected.hex) (\(desc))")
    }
  }
}
