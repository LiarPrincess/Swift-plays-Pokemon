// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Cocoa
import SwiftBoyKit

class OldRegisters: Codable {
  var a: UInt8 = 0
  var c: UInt8 = 0
  var b: UInt8 = 0
  var e: UInt8 = 0
  var d: UInt8 = 0
  var l: UInt8 = 0
  var h: UInt8 = 0
  var zeroFlag:      Bool = false
  var subtractFlag:  Bool = false
  var halfCarryFlag: Bool = false
  var carryFlag:     Bool = false
}

class OldCpu: Codable {
  var pc:    UInt16 = 0
  var sp:    UInt16 = 0
  var cycle: UInt16 = 0
  var ime:           Bool = false
  var imeEnableNext: Bool = false
  var isHalted:      Bool = false
  var registers = OldRegisters()
  var memory    = OldMemory()
}

class OldMemory: Codable {
  var data = [UInt8](repeating: 0, count: 0x10000)
}

private func getPath(_ filename: String) -> URL {
  let documentDirs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
  guard let dir = documentDirs.first else {
    fatalError("Unable to find document path.")
  }
  return dir.appendingPathComponent(filename)
}

//internal func saveState(cpu: Cpu, to filename: String) {
//  let url = getPath(filename)
//
//  if FileManager.default.fileExists(atPath: url.path) {
//    print("Error when saving: file already exists.")
//    return
//  }
//
//  do {
//    let encoder = JSONEncoder()
//    let data = try encoder.encode(cpu)
//    try data.write(to: url, options: .atomicWrite)
//
//    print("Succesfuly saved state to: \(url.path)")
//  } catch let error {
//    print("Error when saving: \(error.localizedDescription)")
//  }
//}

internal func loadState(from filename: String) -> OldCpu {
  let url = getPath(filename)

  do {
    let decoder = JSONDecoder()
    let data = try Data(contentsOf: url)
    return try decoder.decode(OldCpu.self, from: data)
  } catch let error {
    fatalError("Error when loading: \(error.localizedDescription).")
  }
}
