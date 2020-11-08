// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import Cocoa

func openDumpFile(file: DumpFile) -> DumpFileContent {
  var result = DumpFileContent()
  fill(state: &result, from: file.url)
  return result
}

private func toData(_ s: String) -> Data {
  // swiftlint:disable:next force_unwrapping
  return s.data(using: .ascii)!
}

private let cpu_A  = toData("cpu_A")
private let cpu_B  = toData("cpu_B")
private let cpu_C  = toData("cpu_C")
private let cpu_D  = toData("cpu_D")
private let cpu_E  = toData("cpu_E")
private let cpu_HL = toData("cpu_HL")

private let cpu_c_carry     = toData("cpu_c_carry")
private let cpu_h_halfcarry = toData("cpu_h_halfcarry")
private let cpu_n_substract = toData("cpu_n_substract")
private let cpu_z_zero      = toData("cpu_z_zero")

private let cpu_SP = toData("cpu_SP")
private let cpu_PC = toData("cpu_PC")
private let total_ticks = toData("total_ticks")
private let instruction_ticks = toData("instruction_ticks")

private let cpu_interrupt_master_enable = toData("cpu_interrupt_master_enable")
private let cpu_halted  = toData("cpu_halted")
private let cpu_stopped = toData("cpu_stopped")

private let memory = toData("memory")

private var colon: UInt8 = 58 // ascii for ':'
private var comma: UInt8 = 44 // ascii for ','

// MARK: - Fill

// swiftlint:disable:next cyclomatic_complexity function_body_length
private func fill(state: inout DumpFileContent, from fileUrl: URL) {
  guard let stream = StreamReader(url: fileUrl, encoding: .utf8) else {
    print("Unable to open: '\(fileUrl.path)'")
    exit(1)
  }

  defer { stream.close() }

  while let line = stream.nextLineData() {
    guard let splitIndex = line.firstIndex(of: colon) else {
      continue
    }

    let property = line[..<splitIndex]
    let value = line[line.index(after: splitIndex)...]

    if property == cpu_A  { state.cpu.a = parseUInt8(value) }
    else if property == cpu_B  { state.cpu.b = parseUInt8(value) }
    else if property == cpu_C  { state.cpu.c = parseUInt8(value) }
    else if property == cpu_D  { state.cpu.d = parseUInt8(value) }
    else if property == cpu_E  { state.cpu.e = parseUInt8(value) }
    else if property == cpu_HL {
      let v = parseUInt16(value)
      state.cpu.h = UInt8((v & 0xff00) >> 8)
      state.cpu.l = UInt8(v & 0xff)
    }

    else if property == cpu_c_carry      { state.cpu.carryFlag     = parseBool(value) }
    else if property == cpu_h_halfcarry  { state.cpu.halfCarryFlag = parseBool(value) }
    else if property == cpu_n_substract  { state.cpu.subtractFlag  = parseBool(value) }
    else if property == cpu_z_zero       { state.cpu.zeroFlag      = parseBool(value) }

    else if property == cpu_SP  { state.cpu.sp = parseUInt16(value) }
    else if property == cpu_PC  { state.cpu.pc = parseUInt16(value) }

    else if property == total_ticks {  }
    else if property == instruction_ticks {  }

    else if property == cpu_interrupt_master_enable  { state.cpu.ime = parseBool(value) }
    else if property == cpu_halted  { state.cpu.isHalted  = parseBool(value) }
    else if property == cpu_stopped { state.cpu.isStopped = parseBool(value) }

    else if property == memory {
      fillMemory(state: &state, from: 0x0000, to: 0xffff, with: value)
      assert(state.memory.count == 0x10000)
    }

    else {
      // swiftlint:disable:next force_unwrapping
      let propertyString = String(bytes: property, encoding: .ascii)!
      print("Invalid line: \(propertyString)...")
    }
  }
}

// MARK: - Parse

private func parseBool(_ data: Data) -> Bool {
  return data != toData("False")
}

private func parseUInt8(_ data: Data) -> UInt8 {
  return data.reduce(0) { acc, ascii in 10 * acc + (ascii - 48) }
}

private func parseUInt16(_ data: Data) -> UInt16 {
  return data.reduce(0) { acc, ascii in 10 * acc + (UInt16(ascii) - 48) }
}

// MARK: - Fill memory

private func fillMemory(state: inout DumpFileContent, from: Int, to: Int, with data: Data) {
  var value: UInt8 = 0
  var addressOffset = 0

  for ascii in data {
    if ascii == comma {
      let address = from + addressOffset
      state.memory[address] = value
      addressOffset += 1
      value = 0
    } else {
      value = 10 * value + (ascii - 48)
    }
  }

  let lastByte = data[data.index(before: data.endIndex)]
  if lastByte != comma {
    let address = from + addressOffset
    state.memory[address] = value
    addressOffset += 1
  }

  let expectedOffset = to - from + 1
  assert(addressOffset == expectedOffset)
}
