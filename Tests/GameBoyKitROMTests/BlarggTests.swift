// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import GameBoyKit

enum BlarggTests {

  /// Execute: `cpu_instrs/individual/01-special.gb`.
  static func cpuInstrs01(compareWithDumps: Bool) {
    test(romPath: "cpu_instrs/individual/01-special.gb",
         dumpDirName: "cpu_instr_01",
         frames: 145,
         compareWithDumps: compareWithDumps)
  }

  /// Execute: `cpu_instrs/individual/02-interrupts.gb`.
  static func cpuInstrs02(compareWithDumps: Bool) {
    test(romPath: "cpu_instrs/individual/02-interrupts.gb",
         dumpDirName: "cpu_instr_02",
         frames: 30,
         compareWithDumps: compareWithDumps)
  }

  /// Execute: `cpu_instrs/individual/03-op sp,hl.gb`.
  static func cpuInstrs03(compareWithDumps: Bool) {
    test(romPath: "cpu_instrs/individual/03-op sp,hl.gb",
         dumpDirName: "cpu_instr_03",
         frames: 145,
         compareWithDumps: compareWithDumps)
  }

  /// Execute: `cpu_instrs/individual/04-op r,imm.gb`.
  static func cpuInstrs04(compareWithDumps: Bool) {
    test(romPath: "cpu_instrs/individual/04-op r,imm.gb",
         dumpDirName: "cpu_instr_04",
         frames: 170,
         compareWithDumps: compareWithDumps)
  }

  /// Execute: `cpu_instrs/individual/05-op rp.gb`.
  static func cpuInstrs05(compareWithDumps: Bool) {
    test(romPath: "cpu_instrs/individual/05-op rp.gb",
         dumpDirName: "cpu_instr_05",
         frames: 230,
         compareWithDumps: compareWithDumps)
  }

  /// Execute: `cpu_instrs/individual/06-ld r,r.gb`.
  static func cpuInstrs06(compareWithDumps: Bool) {
    test(romPath: "cpu_instrs/individual/06-ld r,r.gb",
         dumpDirName: "cpu_instr_06",
         frames: 40,
         compareWithDumps: compareWithDumps)
  }

  /// Execute: `cpu_instrs/individual/07-jr,jp,call,ret,rst.gb`.
  static func cpuInstrs07(compareWithDumps: Bool) {
    test(romPath: "cpu_instrs/individual/07-jr,jp,call,ret,rst.gb",
         dumpDirName: "cpu_instr_07",
         frames: 45,
         compareWithDumps: compareWithDumps)
  }

  /// Execute: `cpu_instrs/individual/08-misc instrs.gb`.
  static func cpuInstrs08(compareWithDumps: Bool) {
    test(romPath: "cpu_instrs/individual/08-misc instrs.gb",
         dumpDirName: "cpu_instr_08",
         frames: 35,
         compareWithDumps: compareWithDumps)
  }

  /// Execute: `cpu_instrs/individual/09-op r,r.gb`.
  static func cpuInstrs09(compareWithDumps: Bool) {
    test(romPath: "cpu_instrs/individual/09-op r,r.gb",
         dumpDirName: "cpu_instr_09",
         frames: 550,
         compareWithDumps: compareWithDumps)
  }

  /// Execute: `cpu_instrs/individual/10-bit ops.gb`.
  static func cpuInstrs10(compareWithDumps: Bool) {
    test(romPath: "cpu_instrs/individual/10-bit ops.gb",
         dumpDirName: "cpu_instr_10",
         frames: 835,
         compareWithDumps: compareWithDumps)
  }

  /// Execute: `cpu_instrs/individual/11-op a,(hl).gb`.
  static func cpuInstrs11(compareWithDumps: Bool) {
    test(romPath: "cpu_instrs/individual/11-op a,(hl).gb",
         dumpDirName: "cpu_instr_11",
         frames: 1_055,
         compareWithDumps: compareWithDumps)
  }

/// Execute: `instr_timing/instr_timing.gb`.
  static func instrTiming(compareWithDumps: Bool) {
    test(romPath: "instr_timing/instr_timing.gb",
         dumpDirName: "instr_timing",
         frames: 45,
         compareWithDumps: compareWithDumps)
  }
}

// MARK: - Test

private func test(romPath: String,
                  dumpDirName: String,
                  frames: Int,
                  compareWithDumps: Bool) {
  print(romPath, terminator: "")

  let input = DummyInputProvider()
  let cartridge = openRom(romPath: romPath)
  let gameBoy = GameBoy(bootrom: nil, cartridge: cartridge, input: input)

  if compareWithDumps {
    let dumpsDirUrl = getDumpsDirUrl(dumpDirName: dumpDirName)
    runDump(gameBoy: gameBoy, dumpDirUrl: dumpsDirUrl)
  } else {
    for _ in 0..<frames {
      gameBoy.tickFrame()
    }
  }

  let link = String(bytes: gameBoy.linkCable.data, encoding: .ascii) ?? ""
  let passed = link.contains("Passed")

  if passed {
    print(" ✔")
  } else {
    print(" ✖ (serial: \(link.replacingOccurrences(of: "\n", with: " "))")
  }
}

private func openRom(romPath: String) -> Cartridge {
  do {
    let romUrl = romsDir
      .appendingPathComponent("Tests - Blargg")
      .appendingPathComponent("ROMs")
      .appendingPathComponent(romPath)

    let data = try Data(contentsOf: romUrl)
    return try CartridgeFactory.unchecked(data: data)
  } catch let error as CartridgeError {
    fatalError("Error when opening ROM: \(error.description).")
  } catch {
    fatalError(
      "Error when opening ROM: \(error.localizedDescription). " +
      "You can download roms from: 'http://gbdev.gg8.se/files/roms/blargg-gb-tests/')"
    )
  }
}

private func getDumpsDirUrl(dumpDirName: String) -> URL {
  return romsDir
    .appendingPathComponent("Tests - Blargg")
    .appendingPathComponent("Dump")
    .appendingPathComponent(dumpDirName)
}
