// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

var bootromPath: URL {
  let currentFile = URL(fileURLWithPath: #file)
  let mainDir     = currentFile.deletingLastPathComponent()
  return mainDir.appendingPathComponent("PyBootromFiles")
}

private func testBootrom(file: String) {
  let fileUrl = bootromPath.appendingPathComponent(file)
  pyTest(pyLoad(fileUrl))
}

// swiftlint:disable:next function_body_length
internal func pyBoyBootromTests() {
//  testBootrom(file: "pyboy_bootrom_pc_0x03.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x04.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x07.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x08.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x0a.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x0c.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x0f.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x11.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x13.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x14.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x15.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x16.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x18.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x19.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x1a.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x1c.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x1d.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x1f.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x21.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x24.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x27.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x28.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x95.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x96.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x98.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x99.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x9b.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x9c.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x9d.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x9f.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0xa0.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0xa1.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0xa3.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0xa4.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0xa5.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0xa6.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0xa7.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x2b.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x2e.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x2f.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x30.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x32.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x34.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x37.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x39.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x3a.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x3b.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x3c.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x3d.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x3e.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x40.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x42.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x45.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x48.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x4a.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x4b.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x4d.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x4e.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x4f.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x51.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x53.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x55.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x56.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x58.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x59.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x5b.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x5d.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x5f.txt")
  testBootrom(file: "pyboy_bootrom_pc_0x60.txt")
  testBootrom(file: "pyboy_bootrom_pc_0x62.txt")
  testBootrom(file: "pyboy_bootrom_pc_0x64.txt")
  testBootrom(file: "pyboy_bootrom_pc_0x66.txt")
  testBootrom(file: "pyboy_bootrom_pc_0x68.txt")
  testBootrom(file: "pyboy_bootrom_pc_0x6a.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x6b.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x6d.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x6e.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x70.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x72.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x73.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x74.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x76.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x78.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x7a.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x7c.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x7e.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x86.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x88.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x89.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x8b.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x8c.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x80.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x81.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x82.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x83.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x85.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x8e.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x8f.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x91.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x93.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0xe0.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0xe3.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0xe6.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0xe7.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0xe8.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0xe9.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0xeb.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0xec.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0xed.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0xef.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0xf1.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0xf3.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0xf4.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0xf5.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0xf6.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0xf7.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0xf9.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0xfa.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0xfc.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0xfe.txt")
//  testBootrom(file: "pyboy_bootrom_pc_0x100.txt")
}
