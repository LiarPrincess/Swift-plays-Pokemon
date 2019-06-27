// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import GameBoyKit

internal func pyBoyBootromTests() {
  let cartridge = createBootromCartridge()
  let gameBoy   = GameBoy(bootrom: .dmg, cartridge: cartridge)
  let debugger  = Debugger(gameBoy: gameBoy)

  for (index, pyUrl) in PyFiles.bootrom.enumerated() {
    let fileName = pyUrl.lastPathComponent
    print("\(index) - \(fileName)")

    let pyBoy = pyLoad(pyUrl)

    let debugMode: DebugMode = .none // index >= 113 ? .opcodes : .none
    debugger.run(mode: debugMode, lastPC: pyBoy.cpu.pc)
    let hasError = pyTest(pyBoy: pyBoy, swiftBoy: gameBoy)

    if hasError {
      fatalError()
    }
  }

  testStateBeforeUnmappingBootrom(gameBoy)
}

private func createBootromCartridge() -> Cartridge {
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
                                    0x50, 0x4f, 0x4b, 0x45, 0x4d, 0x4f, 0x4e, 0x20, 0x42, 0x4c, 0x55, 0x45,
  /* 140 */ 0x00, 0x00, 0x00, 0x00, 0x30, 0x31, 0x03, 0x13, 0x05, 0x03, 0x01, 0x33, 0x00, 0xd3, 0x9d, 0x0a
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

