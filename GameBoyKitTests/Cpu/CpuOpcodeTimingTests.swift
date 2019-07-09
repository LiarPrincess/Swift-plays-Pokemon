// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import GameBoyKit

// From Blargg tests

private let unprefixedTimings = [
  1,3,2,2,1,1,2,1,5,2,2,2,1,1,2,1,
  0,3,2,2,1,1,2,1,3,2,2,2,1,1,2,1,
  2,3,2,2,1,1,2,1,2,2,2,2,1,1,2,1,
  2,3,2,2,3,3,3,1,2,2,2,2,1,1,2,1,
  1,1,1,1,1,1,2,1,1,1,1,1,1,1,2,1,
  1,1,1,1,1,1,2,1,1,1,1,1,1,1,2,1,
  1,1,1,1,1,1,2,1,1,1,1,1,1,1,2,1,
  2,2,2,2,2,2,0,2,1,1,1,1,1,1,2,1,
  1,1,1,1,1,1,2,1,1,1,1,1,1,1,2,1,
  1,1,1,1,1,1,2,1,1,1,1,1,1,1,2,1,
  1,1,1,1,1,1,2,1,1,1,1,1,1,1,2,1,
  1,1,1,1,1,1,2,1,1,1,1,1,1,1,2,1,
  2,3,3,4,3,4,2,4,2,4,3,0,3,6,2,4,
  2,3,3,0,3,4,2,4,2,4,3,0,3,0,2,4,
  3,3,2,0,0,4,2,4,4,1,4,0,0,0,2,4,
  3,3,2,1,0,4,2,4,3,2,4,1,0,0,2,4
]

private let prefixedTimings = [
  2,2,2,2,2,2,4,2,2,2,2,2,2,2,4,2,
  2,2,2,2,2,2,4,2,2,2,2,2,2,2,4,2,
  2,2,2,2,2,2,4,2,2,2,2,2,2,2,4,2,
  2,2,2,2,2,2,4,2,2,2,2,2,2,2,4,2,
  2,2,2,2,2,2,3,2,2,2,2,2,2,2,3,2,
  2,2,2,2,2,2,3,2,2,2,2,2,2,2,3,2,
  2,2,2,2,2,2,3,2,2,2,2,2,2,2,3,2,
  2,2,2,2,2,2,3,2,2,2,2,2,2,2,3,2,
  2,2,2,2,2,2,4,2,2,2,2,2,2,2,4,2,
  2,2,2,2,2,2,4,2,2,2,2,2,2,2,4,2,
  2,2,2,2,2,2,4,2,2,2,2,2,2,2,4,2,
  2,2,2,2,2,2,4,2,2,2,2,2,2,2,4,2,
  2,2,2,2,2,2,4,2,2,2,2,2,2,2,4,2,
  2,2,2,2,2,2,4,2,2,2,2,2,2,2,4,2,
  2,2,2,2,2,2,4,2,2,2,2,2,2,2,4,2,
  2,2,2,2,2,2,4,2,2,2,2,2,2,2,4,2
]

class CpuOpcodeTimingTests: XCTestCase {

  func test_unprefixed() {
    let skippedOpcodes = Set<UInt8>([
      0xcb, // prefix
      0x10, // stop is not implemented
      0xd3, 0xdb, 0xdd, 0xe3, 0xe4, 0xeb, 0xec, 0xed, 0xf4, 0xfc, 0xfd, // non-existing

      // we have separate tests for those:
      0x20, 0x28, 0x30, 0x38, // jr_cc:       .nz, .z, .nc, .c
      0xc0, 0xc8, 0xd0, 0xd8, // ret_cc:      .nz, .z, .nc, .c
      0xc2, 0xca, 0xd2, 0xda, // jp_cc_nn:    .nz, .z, .nc, .c
      0xc4, 0xcc, 0xd4, 0xdc  // call_cc_a16: .nz, .z, .nc, .c
    ])

    for i in 0..<unprefixedTimings.count {
      let opcode = UInt8(i)
      if skippedOpcodes.contains(opcode) {
        continue
      }

      let memory = FakeCpuAddressableMemory()
      let cpu = self.createCpu(memory: memory)

      cpu.pc = 0
      cpu.sp = 0x1000
      let cycles = cpu.executeUnprefixed(opcode)

      let timing = unprefixedTimings[i]
      XCTAssertEqual(cycles, 4 * timing, "Invalid timing for \(opcode.hex).")
    }
  }

  func test_unprefixed_z_c() {
    // jr_cc, ret_cc, jp_cc_nn, call_cc_a16
    let opcodes: [UInt8] = [
      0x28, 0xc8, 0xca, 0xcc, // z
      0x38, 0xd8, 0xda, 0xdc  // c
    ]

    for opcode in opcodes {
      let memory = FakeCpuAddressableMemory()
      let cpu = self.createCpu(memory: memory)

      cpu.pc = 0
      cpu.sp = 0x1000
      cpu.registers.zeroFlag = false
      cpu.registers.carryFlag = false
      let cycles = cpu.executeUnprefixed(opcode)

      let timing = unprefixedTimings[Int(opcode)]
      XCTAssertEqual(cycles, 4 * timing, "Invalid timing for \(opcode.hex).")
    }
  }

  func test_unprefixed_nz_nc() {
    // jr_cc, ret_cc, jp_cc_nn, call_cc_a16
    let opcodes: [UInt8] = [
      0x20, 0xc0, 0xc2, 0xc4, // nz
      0x30, 0xd0, 0xd2, 0xd4  // nc
    ]

    for opcode in opcodes {
      let memory = FakeCpuAddressableMemory()
      let cpu = self.createCpu(memory: memory)

      cpu.pc = 0
      cpu.sp = 0x1000
      cpu.registers.zeroFlag = true
      cpu.registers.carryFlag = true
      let cycles = cpu.executeUnprefixed(opcode)

      let timing = unprefixedTimings[Int(opcode)]
      XCTAssertEqual(cycles, 4 * timing, "Invalid timing for \(opcode.hex).")
    }
  }

  func test_prefixed() {
    let memory = FakeCpuAddressableMemory()
    let cpu = self.createCpu(memory: memory)

    for (i, timing) in prefixedTimings.enumerated() {
      let opcode = UInt8(i)

      cpu.pc = 0
      let cycles = cpu.executePrefixed(opcode)

      XCTAssertEqual(cycles, 4 * timing, "Invalid timing for \(opcode.hex).")
    }
  }
}
