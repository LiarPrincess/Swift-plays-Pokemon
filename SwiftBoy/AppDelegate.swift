// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Cocoa
import SwiftBoyKit

@NSApplicationMain
public class AppDelegate: NSObject, NSApplicationDelegate {

  public func applicationDidFinishLaunching(_ aNotification: Notification) {
//    self.testSavedState("bootrom_0_skipToAudio2.json")
//    self.testSavedState("bootrom_1_skipToNintendoLogo2.json")
//    self.testSavedState("bootrom_2_skipToTileMap2.json")

    let emulator = Emulator()
    emulator.fakeEmptyCartridge()
    emulator.run(maxCycles: .max, lastPC: 0x0068)
  }

  // swiftlint:disable:next function_body_length
  private func testSavedState(_ file: String) {
    let old = loadState(from: file)

    let emulator = Emulator()
    emulator.fakeEmptyCartridge()
    emulator.run(maxCycles: .max, lastPC: old.pc)

    print("Comparing: \(file)")

    let new = emulator
    let skipAssert = false

    print("  pc: \(new.cpu.pc.hex) vs \(old.pc.hex)")
    assert(skipAssert || new.cpu.pc == old.pc)

    print("  sp: \(new.cpu.sp.hex) vs \(old.sp.hex)")
    assert(skipAssert || new.cpu.sp == old.sp)

    print("  a: \(new.cpu.registers.a.hex) vs \(old.registers.a.hex)")
    assert(skipAssert || new.cpu.registers.a == old.registers.a)

    print("  b: \(new.cpu.registers.b.hex) vs \(old.registers.b.hex)")
    assert(skipAssert || new.cpu.registers.b == old.registers.b)

    print("  c: \(new.cpu.registers.c.hex) vs \(old.registers.c.hex)")
    assert(skipAssert || new.cpu.registers.c == old.registers.c)

    print("  d: \(new.cpu.registers.d.hex) vs \(old.registers.d.hex)")
    assert(skipAssert || new.cpu.registers.d == old.registers.d)

    print("  e: \(new.cpu.registers.e.hex) vs \(old.registers.e.hex)")
    assert(skipAssert || new.cpu.registers.e == old.registers.e)

    print("  h: \(new.cpu.registers.h.hex) vs \(old.registers.h.hex)")
    assert(skipAssert || new.cpu.registers.h == old.registers.h)

    print("  l: \(new.cpu.registers.l.hex) vs \(old.registers.l.hex)")
    assert(skipAssert || new.cpu.registers.l == old.registers.l)

    print("  zeroFlag: \(new.cpu.registers.zeroFlag) vs \(old.registers.zeroFlag)")
    assert(skipAssert || new.cpu.registers.zeroFlag == old.registers.zeroFlag)

    print("  subtractFlag: \(new.cpu.registers.subtractFlag) vs \(old.registers.subtractFlag)")
    assert(skipAssert || new.cpu.registers.subtractFlag == old.registers.subtractFlag)

    print("  halfCarryFlag: \(new.cpu.registers.halfCarryFlag) vs \(old.registers.halfCarryFlag)")
    assert(skipAssert || new.cpu.registers.halfCarryFlag == old.registers.halfCarryFlag)

    print("  carryFlag: \(new.cpu.registers.carryFlag) vs \(old.registers.carryFlag)")
    assert(skipAssert || new.cpu.registers.carryFlag == old.registers.carryFlag)

    print("  memory:")
    var skipAddress = Set<UInt16>()
    (0xfea0...0xfeff).forEach { skipAddress.insert($0) } // not usable
    skipAddress.insert(0xff04) // div was not implemented
    skipAddress.insert(0xff41) // LCD Status was not implemented

    for addressInt in 0..<old.memory.data.count {
      let address = UInt16(addressInt)
      guard !skipAddress.contains(address) else { continue }

      let oldValue = old.memory.data[address]
      let newValue = new.memory.read(address)

      if oldValue != newValue {
        print("    \(address.hex): \(newValue.hex) vs \(oldValue.hex)")
        assert(skipAssert || newValue == oldValue)
      }
    }

    print()
  }
}
