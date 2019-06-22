// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftlint:disable function_body_length
// swiftlint:disable cyclomatic_complexity
// swiftlint:disable force_unwrapping

import Cocoa

internal func pyLoad(_ url: URL) -> PyBoy {
  let fileContent = open(url)
  let emulator    = PyBoy(filename: url.lastPathComponent)
  fill(emulator, from: fileContent)
  return emulator
}

private func open(_ url: URL) -> String {
  do {
    return try String(contentsOf: url, encoding: .utf8)
  } catch let error {
    fatalError(error.localizedDescription)
  }
}

private func fill(_ emulator: PyBoy, from fileContent: String) {
  let cpu = emulator.cpu
  let memory = emulator.memory

  for line in fileContent.split(separator: "\n") {
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

    case "ram_INTERNAL_RAM0":        replace(memory, from: 0xC000, to: 0xDFFF, with: value)
    case "ram_NON_IO_INTERNAL_RAM0": replace(memory, from: 0xFEA0, to: 0xFEFF, with: value)
    case "ram_IO_PORTS":             replace(memory, from: 0xFF00, to: 0xFF4B, with: value)
    case "ram_INTERNAL_RAM1":        replace(memory, from: 0xFF80, to: 0xFFFE, with: value)
    case "ram_NON_IO_INTERNAL_RAM1": replace(memory, from: 0xFF4C, to: 0xFF79, with: value)

    case "ram_INTERRUPT_ENABLE_REGISTER":
      let data = value.split(separator: ",").map { UInt8($0)! }
      memory.data[0xFFFF] = data[0]

    default:
      print("Invalid line: \(line.prefix(40))")
    }

    assert(memory.data.count == 0x10000, String(property))
  }
}

private func replace(_ memory: PyMemory, from: UInt16, to: UInt16, with values: Substring) {
  // we could use 'replaceSubrange', but whatever...
  let data = values.split(separator: ",").map { UInt8($0)! }
  for (index, address) in (from...to).enumerated() where memory.data[address] == 0 {
    memory.data[address] = data[index]
  }
}
