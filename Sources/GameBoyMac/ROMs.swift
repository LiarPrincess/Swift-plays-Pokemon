// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

// swiftlint:disable line_length

private let bundle = Bundle.main
private let fileManager = FileManager.default

/// Path to the ROMs in ROMs dir.
enum ROMs {

  static let tetris = Self.createPath(filename: "Tetris.gb")
  static let pokemonRed = Self.createPath(filename: "Pokemon Red.gb")
  static let pokemonBlue = Self.createPath(filename: "Pokemon Blue.gb")
  static let superMarioLand = Self.createPath(filename: "Super Mario Land.gb")
  static let legendOfZelda = Self.createPath(filename: "Legend of Zelda - The Link's Awakening.gb")
  static let bomberman = Self.createPath(filename: "Bomberman.gb")
  static let f1Race = Self.createPath(filename: "F-1 Race.gb")
  static let galagaGalaxian = Self.createPath(filename: "Galaga & Galaxian.gb")
  static let kirbysDreamLand = Self.createPath(filename: "Kirby's Dream Land.gb")
  static let spaceInvaders = Self.createPath(filename: "Space Invaders.gb")

  enum Blargg {
    static let cpuInstrs01 = Self.createBlarggPath(filename: "cpu_instrs/individual/01-special.gb")
    static let cpuInstrs02 = Self.createBlarggPath(filename: "cpu_instrs/individual/02-interrupts.gb")
    static let cpuInstrs03 = Self.createBlarggPath(filename: "cpu_instrs/individual/03-op sp,hl.gb")
    static let cpuInstrs04 = Self.createBlarggPath(filename: "cpu_instrs/individual/04-op r,imm.gb")
    static let cpuInstrs05 = Self.createBlarggPath(filename: "cpu_instrs/individual/05-op rp.gb")
    static let cpuInstrs06 = Self.createBlarggPath(filename: "cpu_instrs/individual/06-ld r,r.gb")
    static let cpuInstrs07 = Self.createBlarggPath(filename: "cpu_instrs/individual/07-jr,jp,call,ret,rst.gb")
    static let cpuInstrs08 = Self.createBlarggPath(filename: "cpu_instrs/individual/08-misc instrs.gb")
    static let cpuInstrs09 = Self.createBlarggPath(filename: "cpu_instrs/individual/09-op r,r.gb")
    static let cpuInstrs10 = Self.createBlarggPath(filename: "cpu_instrs/individual/10-bit ops.gb")
    static let cpuInstrs11 = Self.createBlarggPath(filename: "cpu_instrs/individual/11-op a,(hl).gb")
    static let instrTiming = Self.createBlarggPath(filename: "instr_timing/instr_timing.gb")

    private static func createBlarggPath(filename: String) -> String {
      let romUrl = ROMs.romsDir
        .appendingPathComponent("Tests - Blargg")
        .appendingPathComponent("ROMs")
        .appendingPathComponent(filename)

      return romUrl.path
    }
  }

  private static func createPath(filename: String) -> String {
    let romUrl = Self.romsDir.appendingPathComponent(filename)
    return romUrl.path
  }

  private static let executableURL: URL = {
    if let url = bundle.executableURL {
      return url
    }

    if let path = bundle.executablePath {
      return URL(fileURLWithPath: path)
    }

    fatalError("Failed to obtain executable path.")
  }()

  /// `ROMs` directory in repository root.
  private static let romsDir: URL = {
    var dir = executableURL
    dir.deleteLastPathComponent()

    for _ in 0..<dir.pathComponents.count {
      let romDir = dir.appendingPathComponent("ROMs")
      let exists = fileManager.fileExists(atPath: romDir.path)

      if exists {
        return romDir
      }

      dir.deleteLastPathComponent()
    }

    fatalError("Failed to obtain path to ROMs dir")
  }()
}
