// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftlint:disable force_unwrapping
// swiftlint:disable force_cast

import Foundation

struct Opcodes {
  let unprefixed: [Opcode]
  let cbprefixed: [Opcode]
}

// Orginal 'opcodes.json' was taken from:
// https://github.com/lmmendes/game-boy-opcodes
func openOpcodesFile() throws -> Opcodes {
  var opcodesFile = URL(fileURLWithPath: #file, isDirectory: false)
  opcodesFile.deleteLastPathComponent()
  opcodesFile.appendPathComponent("opcodes.json")

  let fileStream = InputStream(fileAtPath: opcodesFile.path)!
  fileStream.open()
  defer { fileStream.close() }

  let dict = try JSONSerialization.jsonObject(with: fileStream, options: []) as! [String:[String:[String:Any]]]
  let unprefixed = parseOpcodes(dict["unprefixed"]!)
  let cbprefixed = parseOpcodes(dict["cbprefixed"]!)

  return Opcodes(unprefixed: unprefixed, cbprefixed: cbprefixed)
}

private func parseOpcodes(_ data: [String:[String:Any]]) -> [Opcode] {
  return data.values
    .map(toOp)
    .sorted(by: addr)
}

private func toOp(_ value: [String:Any]) -> Opcode {
  return Opcode(
    mnemonic: value["mnemonic"] as! String,
    length: value["length"] as! Int,
    cycles: value["cycles"] as! [Int],
    flags: value["flags"] as! [String],
    addr: value["addr"] as! String,
    operand1: value["operand1"] as? String,
    operand2: value["operand2"] as? String
  )
}

private func addr(_ lhs: Opcode, _ rhs: Opcode) -> Bool {
  return lhs.addr.count != rhs.addr.count ?
    lhs.addr.count < rhs.addr.count :
    lhs.addr < rhs.addr
}
