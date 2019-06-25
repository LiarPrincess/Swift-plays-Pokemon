// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

/// Code that will be ran when gameboy is started. You can find
/// different bootroms [here](http://gbdev.gg8.se/files/roms/bootroms/).
public class Bootrom {

  internal static let size = MemoryMap.bootrom.count

  public let data: Data

  public init(data: Data) throws {
    guard data.count == Bootrom.size else {
      throw BootromInitError.invalidSize
    }

    self.data = data
  }
}

// MARK: - Predefined bootroms

extension Bootrom {

  /// Skip directly to the game.
  /// Source: https://github.com/Baekalfen/PyBoy
  public static var skip: Bootrom {
    // TODO: Use pandocs (end) instead
    var data = Data(memoryRange: MemoryMap.bootrom)

    // Set stack pointer
    data[0x00] = 0x31
    data[0x01] = 0xfe
    data[0x02] = 0xff

    // Inject jump to 0xFC
    data[0x03] = 0xc3
    data[0x04] = 0xfc
    data[0x05] = 0x00

    // Inject code to disable boot-ROM
    data[0xfc] = 0x3e
    data[0xfd] = 0x01
    data[0xfe] = 0xe0
    data[0xff] = 0x50

    // swiftlint:disable:next force_try
    return try! Bootrom(data: data)
  }

  /// This is the most common version of the boot ROM
  /// found in the original DMG-01 model of Gameboy.
  /// Source: http://gbdev.gg8.se/files/roms/bootroms/
  public static var dmg: Bootrom {
    let data = Data(dmgData)

    // swiftlint:disable:next force_try
    return try! Bootrom(data: data)
  }
}

private let dmgData: [UInt8] = [
/*          0     1     2     3     4     5     6     7     8     9    a      b     c     d     e     f */
/* 00 */ 0x31, 0xfe, 0xff, 0xaf, 0x21, 0xff, 0x9f, 0x32, 0xcb, 0x7c, 0x20, 0xfb, 0x21, 0x26, 0xff, 0x0e,
/* 10 */ 0x11, 0x3e, 0x80, 0x32, 0xe2, 0x0c, 0x3e, 0xf3, 0xe2, 0x32, 0x3e, 0x77, 0x77, 0x3e, 0xfc, 0xe0,
/* 20 */ 0x47, 0x11, 0x04, 0x01, 0x21, 0x10, 0x80, 0x1a, 0xcd, 0x95, 0x00, 0xcd, 0x96, 0x00, 0x13, 0x7b,
/* 30 */ 0xfe, 0x34, 0x20, 0xf3, 0x11, 0xd8, 0x00, 0x06, 0x08, 0x1a, 0x13, 0x22, 0x23, 0x05, 0x20, 0xf9,
/* 40 */ 0x3e, 0x19, 0xea, 0x10, 0x99, 0x21, 0x2f, 0x99, 0x0e, 0x0c, 0x3d, 0x28, 0x08, 0x32, 0x0d, 0x20,
/* 50 */ 0xf9, 0x2e, 0x0f, 0x18, 0xf3, 0x67, 0x3e, 0x64, 0x57, 0xe0, 0x42, 0x3e, 0x91, 0xe0, 0x40, 0x04,
/* 60 */ 0x1e, 0x02, 0x0e, 0x0c, 0xf0, 0x44, 0xfe, 0x90, 0x20, 0xfa, 0x0d, 0x20, 0xf7, 0x1d, 0x20, 0xf2,
/* 70 */ 0x0e, 0x13, 0x24, 0x7c, 0x1e, 0x83, 0xfe, 0x62, 0x28, 0x06, 0x1e, 0xc1, 0xfe, 0x64, 0x20, 0x06,
/* 80 */ 0x7b, 0xe2, 0x0c, 0x3e, 0x87, 0xe2, 0xf0, 0x42, 0x90, 0xe0, 0x42, 0x15, 0x20, 0xd2, 0x05, 0x20,
/* 90 */ 0x4f, 0x16, 0x20, 0x18, 0xcb, 0x4f, 0x06, 0x04, 0xc5, 0xcb, 0x11, 0x17, 0xc1, 0xcb, 0x11, 0x17,
/* a0 */ 0x05, 0x20, 0xf5, 0x22, 0x23, 0x22, 0x23, 0xc9, 0xce, 0xed, 0x66, 0x66, 0xcc, 0x0d, 0x00, 0x0b,
/* b0 */ 0x03, 0x73, 0x00, 0x83, 0x00, 0x0c, 0x00, 0x0d, 0x00, 0x08, 0x11, 0x1f, 0x88, 0x89, 0x00, 0x0e,
/* c0 */ 0xdc, 0xcc, 0x6e, 0xe6, 0xdd, 0xdd, 0xd9, 0x99, 0xbb, 0xbb, 0x67, 0x63, 0x6e, 0x0e, 0xec, 0xcc,
/* d0 */ 0xdd, 0xdc, 0x99, 0x9f, 0xbb, 0xb9, 0x33, 0x3e, 0x3c, 0x42, 0xb9, 0xa5, 0xb9, 0xa5, 0x42, 0x3c,
/* e0 */ 0x21, 0x04, 0x01, 0x11, 0xa8, 0x00, 0x1a, 0x13, 0xbe, 0x20, 0xfe, 0x23, 0x7d, 0xfe, 0x34, 0x20,
/* f0 */ 0xf5, 0x06, 0x19, 0x78, 0x86, 0x23, 0x05, 0x20, 0xfb, 0x86, 0x20, 0xfe, 0x3e, 0x01, 0xe0, 0x50
]
