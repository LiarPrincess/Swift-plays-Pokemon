// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import GameBoyKit

enum RunDumpErrorHandling {
  case ignore
  case fatal
}

func runDump(gameBoy: GameBoy,
             dumpDirUrl: URL,
             mode: Debugger.Mode = .opcodes,
             errorHandling: RunDumpErrorHandling = .fatal)
{
  let debugger = Debugger(gameBoy: gameBoy)
  let dumpFiles = openDumpDir(directory: dumpDirUrl)

  for (index, file) in dumpFiles.enumerated() {
    print("\(index) - \(file.filename)")

    // https://swiftrocks.com/autoreleasepool-in-2019-swift.html
    autoreleasepool {
      let expectedState = openDumpFile(file: file)
      debugger.run(mode: mode, untilPC: expectedState.cpu.pc)
      let hasError = compare(gameBoy: gameBoy, state: expectedState)

      if hasError {
        switch errorHandling {
        case .ignore: break
        case .fatal: fatalError("Ivalid state!")
        }
      }
    }
  }
}

// swiftlint:disable:next function_body_length
private func compare(gameBoy: GameBoy, state: DumpFileContent) -> Bool {
  var hasError = false

  func compare<T: Equatable>(name: String, path: KeyPath<GameBoy, T>, expected: T) {
    let value = gameBoy[keyPath: path]
    if value != expected {
      print("Invalid \(name): \(format(value)) vs \(format(expected))")
      hasError = true
    }
  }

  compare(name: "cpu.pc", path: \GameBoy.cpu.pc, expected: state.cpu.pc)
  compare(name: "cpu.sp", path: \GameBoy.cpu.sp, expected: state.cpu.sp)
  compare(name: "cpu.ime", path: \GameBoy.cpu.imeNext, expected: state.cpu.ime)

  compare(name: "cpu.a", path: \GameBoy.cpu.registers.a, expected: state.cpu.a)
  compare(name: "cpu.b", path: \GameBoy.cpu.registers.b, expected: state.cpu.b)
  compare(name: "cpu.c", path: \GameBoy.cpu.registers.c, expected: state.cpu.c)
  compare(name: "cpu.d", path: \GameBoy.cpu.registers.d, expected: state.cpu.d)
  compare(name: "cpu.e", path: \GameBoy.cpu.registers.e, expected: state.cpu.e)
  compare(name: "cpu.h", path: \GameBoy.cpu.registers.h, expected: state.cpu.h)
  compare(name: "cpu.l", path: \GameBoy.cpu.registers.l, expected: state.cpu.l)

  // swiftlint:disable line_length
  compare(name: "cpu.zeroFlag", path: \GameBoy.cpu.registers.zeroFlag, expected: state.cpu.zeroFlag)
  compare(name: "cpu.subtractFlag", path: \GameBoy.cpu.registers.subtractFlag, expected: state.cpu.subtractFlag)
  compare(name: "cpu.halfCarryFlag", path: \GameBoy.cpu.registers.halfCarryFlag, expected: state.cpu.halfCarryFlag)
  compare(name: "cpu.carryFlag", path: \GameBoy.cpu.registers.carryFlag, expected: state.cpu.carryFlag)
  // swiftlint:enable line_length

  for address in memoryAddressesToTest {
    let expected = state.memory[Int(address)]
    let value = gameBoy.memory.read(address)

    if value != expected {
      let desc = MemoryMap.describe(address: address)

      if address == MemoryMap.Lcd.control || address == MemoryMap.Lcd.status {
        print("Invalid memory \(address.hex): \(value.bin) vs \(expected.bin) (\(desc))")
      } else {
        print("Invalid memory \(address.hex): \(value.hex) vs \(expected.hex) (\(desc))")
      }

      hasError = true
    }
  }

  return hasError
}

private func format<T>(_ value: T) -> String {
  if let u8 = value as? UInt16 {
    return u8.hex
  }

  if let u16 = value as? UInt16 {
    return u16.hex
  }

  return String(describing: value)
}
