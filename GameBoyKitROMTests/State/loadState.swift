// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftlint:disable function_body_length
// swiftlint:disable cyclomatic_complexity
// swiftlint:disable force_unwrapping

import Cocoa

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

  while let line = stream.nextLine() {
    if line.isEmpty { continue }

    let split = line.split(separator: ":")
    let property = split[0]
    let value = split[1]

    switch property {
    case "cpu_A": cpu.registers.a = UInt8(value)!
    case "cpu_B": cpu.registers.b = UInt8(value)!
    case "cpu_C": cpu.registers.c = UInt8(value)!
    case "cpu_D": cpu.registers.d = UInt8(value)!
    case "cpu_E": cpu.registers.e = UInt8(value)!
    case "cpu_HL":
      let v = UInt16(value)!
      cpu.registers.h = UInt8((v & 0xff00) >> 8)
      cpu.registers.l = UInt8(v & 0xff)

    case "cpu_c_carry":     cpu.registers.carryFlag     = value != "False"
    case "cpu_h_halfcarry": cpu.registers.halfCarryFlag = value != "False"
    case "cpu_n_substract": cpu.registers.subtractFlag  = value != "False"
    case "cpu_z_zero":      cpu.registers.zeroFlag      = value != "False"

    case "cpu_SP": cpu.sp = UInt16(value)!
    case "cpu_PC": cpu.pc = UInt16(value)!
    case "cpu_interrupt_master_enable": cpu.ime = value != "False"
    case "cpu_halted": cpu.isHalted = value != "False"

    // TODO: Import 'cpu_stopped' from py
    case "cpu_stopped": break

    case "lcd_VRAM": replace(memory, from: 0x8000, to: 0x9fff, with: value)
    case "lcd_Oam": replace(memory, from: 0xfe00, to: 0xfe9f, with: value)

    case "lcd_LY" :   memory.data[0xFF44] = UInt8(value)!
    case "lcd_LYC" :  memory.data[0xFF45] = UInt8(value)!
    case "lcd_STAT" : memory.data[0xFF41] = UInt8(value)!
    case "lcd_LCDC":  memory.data[0xFF40] = UInt8(value)!
    case "lcd_BGP":   memory.data[0xFF47] = UInt8(value)!
    case "lcd_OBP0":  memory.data[0xFF48] = UInt8(value)!
    case "lcd_OBP1":  memory.data[0xFF49] = UInt8(value)!
    case "lcd_SCY":   memory.data[0xFF42] = UInt8(value)!
    case "lcd_SCX":   memory.data[0xFF43] = UInt8(value)!
    case "lcd_WY":    memory.data[0xFF4A] = UInt8(value)!
    case "lcd_WX":    memory.data[0xFF4B] = UInt8(value)!

    case "ram_INTERNAL_RAM0":        replace(memory, from: 0xc000, to: 0xdfff, with: value)
    case "ram_NON_IO_INTERNAL_RAM0": replace(memory, from: 0xfea0, to: 0xfeff, with: value)
    case "ram_IO_PORTS":             replace(memory, from: 0xff00, to: 0xff4b, with: value)
    case "ram_NON_IO_INTERNAL_RAM1": replace(memory, from: 0xff4c, to: 0xff79, with: value)
    case "ram_INTERNAL_RAM1":        replace(memory, from: 0xff80, to: 0xfffe, with: value)

    case "ram_INTERRUPT_ENABLE_REGISTER":
      let data = value.split(separator: ",").map { UInt8($0)! }
      memory.data[0xFFFF] = data[0]

    case "memory":
      replace(memory, from: 0x0000, to: 0xffff, with: value)

    default:
      print("Invalid line: \(line.prefix(40))")
    }

    assert(memory.data.count == 0x10000, String(property))
  }
}

private func replace(_ memory: SavedMemory, from: Int, to: Int, with values: Substring) {
  var addressOffset = 0
  split(values, by: ",") { s in
    guard !s.isEmpty else { return } // we have ',' after last value

    let address = from + addressOffset
    guard memory.data[address] == 0 else { return } // prevent overriding IO

    memory.data[address] = UInt8(s)!
    addressOffset += 1
  }
}

// we could create separate class that implements Sequence, but whatever...
private func split(_ s:          Substring,
                   by separator: Character = ",",
                   with f:       (Substring) -> ()) {

  var index = s.startIndex
  var startIndex = s.startIndex

  while index != s.endIndex {
    if s[index] == separator {
      f(s[startIndex..<index])
      startIndex = s.index(after: index)
    }

    index = s.index(after: index)
  }

  // last value (after last separator)
  f(s[startIndex..<s.endIndex])
}
