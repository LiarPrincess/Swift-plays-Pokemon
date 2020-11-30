// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import GameBoyKit

private let romUrl = romsDir
  .appendingPathComponent("Tetris.gb")

private let dumpDirUrl = romsDir
  .appendingPathComponent("Tests - Bootrom")
  .appendingPathComponent("Dump")

enum BootromTests {

  static func run(compareWithDumps: Bool) {
    print("Bootrom test")

    let bootrom = Bootrom.dmg
    let cartridge = Self.openRom()
    let input = DummyInputProvider()
    let gameBoy = GameBoy(bootrom: bootrom, cartridge: cartridge, input: input)

    if compareWithDumps {
      runDump(gameBoy: gameBoy, dumpDirUrl: dumpDirUrl)
    } else {
      let debugger = Debugger(gameBoy: gameBoy)
      debugger.run(mode: .none, untilPC: 0x0100)
    }

    self.checkFinalStateBeforeUnmappingBootrom(gameBoy: gameBoy)
  }

  private static func openRom() -> Cartridge {
    do {
      let data = try Data(contentsOf: romUrl)
      return try CartridgeFactory.create(rom: data, ram: nil)
    } catch {
      fatalError("Unable to open: '\(romUrl)'")
    }
  }

  // swiftlint:disable:next function_body_length
  private static func checkFinalStateBeforeUnmappingBootrom(gameBoy: GameBoy) {
    // source: http://bgb.bircd.org/pandocs.htm#powerupsequence
    print("Final state")

    if gameBoy.cpu.pc != 0x0100 {
      print("  pc: \(gameBoy.cpu.pc.hex) vs 0x0100")
    }

    if gameBoy.cpu.sp != 0xfffe {
      print("  sp: \(gameBoy.cpu.sp.hex) vs 0xfffe")
    }

    func compareRegister(register: CpuRegisters.Single, expected: UInt8) {
      let value = gameBoy.cpu.registers.get(register)
      if value != expected {
        print("  \(register): \(value.hex) vs \(expected.hex)")
      }
    }

    compareRegister(register: .a, expected: 0x01)
    compareRegister(register: .b, expected: 0x00)
    compareRegister(register: .c, expected: 0x13)
    compareRegister(register: .d, expected: 0x00)
    compareRegister(register: .e, expected: 0xd8)
    compareRegister(register: .h, expected: 0x01)
    compareRegister(register: .l, expected: 0x4d)

    func compareFlag(flag: CpuRegisters.Flag, expected: Bool) {
      let value = gameBoy.cpu.registers.get(flag)
      if value != expected {
        print("  \(flag): \(value) vs \(expected)")
      }
    }

    compareFlag(flag: .zeroFlag, expected: true)
    compareFlag(flag: .subtractFlag, expected: false)
    compareFlag(flag: .halfCarryFlag, expected: true)
    compareFlag(flag: .carryFlag, expected: true)

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
      0xffff: 0x00 // ie
    ]

    for address in memoryAddressesToTest {
      // 'videoRam' does not really matter since it will be overriden by game
      if MemoryMap.videoRam.contains(address) {
        continue
      }

      let value = gameBoy.memory.read(address)
      let expected = values[address] ?? 0x00

      if value != expected {
        let desc = MemoryMap.describe(address: address)
        print("  memory \(address.hex): \(value.hex) vs \(expected.hex) (\(desc))")
      }
    }
  }
}
