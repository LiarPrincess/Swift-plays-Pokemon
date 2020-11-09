// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import GameBoyKit

// This table comes from Blargg tests

private let unprefixedLengths: [UInt16] = [
  1, 3, 1, 1, 1, 1, 2, 1, 3, 1, 1, 1, 1, 1, 2, 1,
  0, 3, 1, 1, 1, 1, 2, 1, 2, 1, 1, 1, 1, 1, 2, 1,
  2, 3, 1, 1, 1, 1, 2, 1, 2, 1, 1, 1, 1, 1, 2, 1,
  2, 3, 1, 1, 1, 1, 2, 1, 2, 1, 1, 1, 1, 1, 2, 1,
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
  1, 1, 3, 3, 3, 1, 2, 1, 1, 1, 3, 0, 3, 3, 2, 1,
  1, 1, 3, 0, 3, 1, 2, 1, 1, 1, 3, 0, 3, 0, 2, 1,
  2, 1, 1, 0, 0, 1, 2, 1, 2, 1, 3, 0, 0, 0, 2, 1,
  2, 1, 1, 1, 0, 1, 2, 1, 2, 1, 3, 1, 0, 0, 2, 1
]

class CpuOpcodeLengthTests: CpuTestCase {

  // MARK: - Unprefixed

  func test_unprefixed() {
    let skippedOpcodes = Set<UInt8>([
      0x10, // stop is not implemented
      0xcb, // prefix
      0x76, // halt - it's complicated

      0xd3, 0xdb, 0xdd, 0xe3, 0xe4, 0xeb, 0xec, 0xed, 0xf4, 0xfc, 0xfd, // non-existing
      0xcd, // call_a16.
      0x18, 0xe9, 0xc3, // jr_r8, jp_pHL, jp_a16
      0xc9, 0xd9, // ret, reti
      0xc7, 0xcf, 0xd7, 0xdf, 0xe7, 0xef, 0xf7, 0xff, // rst 00, 08, 10, 18, 20, 28, 30, 38

      // We have separate tests for those:
      0x20, 0x28, 0x30, 0x38, // jr_cc: nz, z, nc, c
      0xc0, 0xc8, 0xd0, 0xd8, // ret_cc: .nz, .z, .nc, .c
      0xc2, 0xca, 0xd2, 0xda, // jp_cc_nn: .nz, .z, .nc, .c
      0xc4, 0xcc, 0xd4, 0xdc // call_cc_a16: .nz, .z, .nc, .c
    ])

    for (i, length) in unprefixedLengths.enumerated() {
      let opcode = UInt8(i)
      if skippedOpcodes.contains(opcode) {
        continue
      }

      let memory = self.createFakeMemory()
      let cpu = self.createCpu(memory: memory)

      cpu.pc = 0
      cpu.sp = 0x1000
      memory.write(0, value: opcode)
      _ = cpu.tick()

      XCTAssertEqual(cpu.pc, length, "Invalid length for \(opcode.hex).")
    }
  }

  func test_unprefixed_z_c() {
    // jr_cc, ret_cc, jp_cc_nn, call_cc_a16
    let opcodes: [UInt8] = [
      0x28, 0xc8, 0xca, 0xcc, // z
      0x38, 0xd8, 0xda, 0xdc // c
    ]

    for opcode in opcodes {
      let memory = self.createFakeMemory()
      let cpu = self.createCpu(memory: memory)

      cpu.pc = 0
      cpu.sp = 0x1000
      cpu.registers.zeroFlag = false
      cpu.registers.carryFlag = false
      _ = cpu.executeUnprefixed(opcode)

      let length = unprefixedLengths[Int(opcode)]
      XCTAssertEqual(cpu.pc, length, "Invalid length for \(opcode.hex).")
    }
  }

  func test_unprefixed_nz_nc() {
    // jr_cc, ret_cc, jp_cc_nn, call_cc_a16
    let opcodes: [UInt8] = [
      0x20, 0xc0, 0xc2, 0xc4, // nz
      0x30, 0xd0, 0xd2, 0xd4 // nc
    ]

    for opcode in opcodes {
      let memory = self.createFakeMemory()
      let cpu = self.createCpu(memory: memory)

      cpu.pc = 0
      cpu.sp = 0x1000
      cpu.registers.zeroFlag = true
      cpu.registers.carryFlag = true
      _ = cpu.executeUnprefixed(opcode)

      let length = unprefixedLengths[Int(opcode)]
      XCTAssertEqual(cpu.pc, length, "Invalid length for \(opcode.hex).")
    }
  }

  // MARK: - Prefixed

  func test_prefixed() {
    for opcode in 0...UInt8.max {
      let memory = self.createFakeMemory()
      let cpu = self.createCpu(memory: memory)

      cpu.pc = 0
      memory.write(0, value: 0xcb)
      memory.write(1, value: opcode)
      _ = cpu.executePrefixed(opcode)

      XCTAssertEqual(cpu.pc, 2, "Invalid length for \(opcode.hex).")
    }
  }
}
