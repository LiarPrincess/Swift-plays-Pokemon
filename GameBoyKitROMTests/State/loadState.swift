// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftlint:disable function_body_length
// swiftlint:disable cyclomatic_complexity
// swiftlint:disable force_unwrapping

import Cocoa

private func data(_ s: String) -> Data { return s.data(using: .ascii)! }

private var cpu_A:  Data = { return data("cpu_A") }()
private var cpu_B:  Data = { return data("cpu_B") }()
private var cpu_C:  Data = { return data("cpu_C") }()
private var cpu_D:  Data = { return data("cpu_D") }()
private var cpu_E:  Data = { return data("cpu_E") }()
private var cpu_HL: Data = { return data("cpu_HL") }()

private var cpu_c_carry:     Data = { return data("cpu_c_carry") }()
private var cpu_h_halfcarry: Data = { return data("cpu_h_halfcarry") }()
private var cpu_n_substract: Data = { return data("cpu_n_substract") }()
private var cpu_z_zero:      Data = { return data("cpu_z_zero") }()

private var cpu_SP: Data = { return data("cpu_SP") }()
private var cpu_PC: Data = { return data("cpu_PC") }()

private var cpu_interrupt_master_enable: Data = { return data("cpu_interrupt_master_enable") }()
private var cpu_halted:  Data = { return data("cpu_halted") }()
private var cpu_stopped: Data = { return data("cpu_stopped") }()

private var memoryD: Data = { return data("memory") }()
private var falseD:  Data = { return data("False") }()

private var colon: UInt8 = { return /* : */ 58 }()
private var comma: UInt8 = { return /* , */ 44 }()

internal func loadState(_ url: URL) -> SavedState {
  let state = SavedState(filename: url.lastPathComponent)
  fill(state, from: url)
  return state
}

private func fill(_ emulator: SavedState, from fileUrl: URL) {
  guard let stream = StreamReader(url: fileUrl, encoding: .utf8) else {
    print("Unable to open: '\(fileUrl.lastPathComponent)'")
    exit(1)
  }

  defer { stream.close() }

  let cpu = emulator.cpu
  let memory = emulator.memory

  while let line = stream.nextLineData() {
    guard let splitIndex = line.firstIndex(of: colon) else {
      continue
    }

    let property = line[..<splitIndex]
    let value    = line[line.index(after: splitIndex)...]

    if property == cpu_A  { cpu.registers.a = parseUInt8(value) }
    else if property == cpu_B  { cpu.registers.b = parseUInt8(value) }
    else if property == cpu_C  { cpu.registers.c = parseUInt8(value) }
    else if property == cpu_D  { cpu.registers.d = parseUInt8(value) }
    else if property == cpu_E  { cpu.registers.e = parseUInt8(value) }
    else if property == cpu_HL {
      let v = parseUInt16(value)
      cpu.registers.h = UInt8((v & 0xff00) >> 8)
      cpu.registers.l = UInt8(v & 0xff)
    }

    else if property == cpu_c_carry      { cpu.registers.carryFlag     = parseBool(value) }
    else if property == cpu_h_halfcarry  { cpu.registers.halfCarryFlag = parseBool(value) }
    else if property == cpu_n_substract  { cpu.registers.subtractFlag  = parseBool(value) }
    else if property == cpu_z_zero       { cpu.registers.zeroFlag      = parseBool(value) }

    else if property == cpu_SP  { cpu.sp = parseUInt16(value) }
    else if property == cpu_PC  { cpu.pc = parseUInt16(value) }

    else if property == cpu_interrupt_master_enable  { cpu.ime      = parseBool(value) }
    else if property == cpu_halted                   { cpu.isHalted = parseBool(value) }
    else if property == cpu_stopped { } // TODO: Import 'cpu_stopped' from py

    else if property == memoryD {
      replace(memory, from: 0x0000, to: 0xffff, with: value)
      assert(memory.data.count == 0x10000, String(bytes: property, encoding: .ascii)!)
    }

    else {
      print("Invalid line: \(String(bytes: property, encoding: .ascii)!)...")
    }
  }
}

private func parseBool(_ data: Data) -> Bool {
  return data != falseD
}

private func parseUInt8(_ data: Data) -> UInt8 {
  return data.reduce(0) { acc, ascii in 10 * acc + (ascii - 48) }
}

private func parseUInt16(_ data: Data) -> UInt16 {
  return data.reduce(0) { acc, ascii in 10 * acc + (UInt16(ascii) - 48) }
}

private func replace(_ memory: SavedMemory, from: Int, to: Int, with data: Data) {
  var value: UInt8 = 0
  var addressOffset = 0

  for ascii in data {
    if ascii == comma {
      let address = from + addressOffset
      memory.data[address] = value
      addressOffset += 1
      value = 0
    } else {
      value = 10 * value + (ascii - 48)
    }
  }

  let lastByte = data[data.index(before: data.endIndex)]
  if lastByte != comma {
    let address = from + addressOffset
    memory.data[address] = value
    addressOffset += 1
  }

  let expectedOffset = to - from + 1
  assert(addressOffset == expectedOffset)
}

// we could create separate class that implements Sequence, but whatever...
//private func split(_ s:          Substring,
//                   by separator: Character = ",",
//                   with f:       (Substring) -> ()) {
//
//  var index = s.startIndex
//  var startIndex = s.startIndex
//
//  while index != s.endIndex {
//    if s[index] == separator {
//      f(s[startIndex..<index])
//      startIndex = s.index(after: index)
//    }
//
//    index = s.index(after: index)
//  }
//
//  // last value (after last separator)
//  f(s[startIndex..<s.endIndex])
//}