// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// From Blargg tests
private let unprefixedLengths = [
  1,3,1,1,1,1,2,1,3,1,1,1,1,1,2,1, // 0
  0,3,1,1,1,1,2,1,2,1,1,1,1,1,2,1, // 1
  2,3,1,1,1,1,2,1,2,1,1,1,1,1,2,1, // 2
  2,3,1,1,1,1,2,1,2,1,1,1,1,1,2,1, // 3
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, // 4
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, // 5
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, // 6
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, // 7
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, // 8
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, // 9
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, // A
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, // B
  1,1,3,3,3,1,2,1,1,1,3,0,3,3,2,1, // C
  1,1,3,0,3,1,2,1,1,1,3,0,3,0,2,1, // D
  2,1,1,0,0,1,2,1,2,1,3,0,0,0,2,1, // E
  2,1,1,1,0,1,2,1,2,1,3,1,0,0,2,1  // F
]

extension Debugger {

  private func next8(pc: UInt16) -> UInt8 {
    return self.memory.read(pc + 1)
  }

  private func next16(pc: UInt16) -> UInt16 {
    let low  = UInt16(self.memory.read(pc + 1))
    let high = UInt16(self.memory.read(pc + 2))
    return (high << 8) | low
  }

  private func read(_ address: UInt16) -> UInt8 {
    return self.memory.read(address)
  }

  private func unprefixedOpcodeAt(pc: UInt16) -> UnprefixedOpcode? {
    let rawOpcode = self.read(pc)
    return UnprefixedOpcode(rawValue: rawOpcode)
  }

  // MARK: - Print opcode

  internal func printNextOpcode() {
    switch self.unprefixedOpcodeAt(pc: self.cpu.pc) {
    case .none: return
    case let .some(opcode) where opcode == .prefix: self.printPrefixedOpcode()
    case let .some(opcode): printUnprefixedOpcode(opcode)
    }
  }

  private func printUnprefixedOpcode(_ opcode: UnprefixedOpcode) {
    let operands: String = {
      switch unprefixedLengths[Int(opcode.rawValue)] {
      case 2: return self.next8(pc: self.cpu.pc).hex
      case 3: return self.next16(pc: self.cpu.pc).hex
      default: return ""
      }
    }()

    let cycle = gameBoy.cpu.cycle
    let opcodeDesc = String(describing: opcode).padRight(toLength: 11)
    print("\(cpu.pc.hex): \(opcodeDesc) \(operands) (cycle: \(cycle))")
  }

  private func printPrefixedOpcode() {
    let rawOpcode = self.next8(pc: self.cpu.pc)
    guard let opcode = CBPrefixedOpcode(rawValue: rawOpcode) else {
      return
    }

    let pc = self.cpu.pc + 1
    let opcodeDesc = String(describing: opcode)
    print("\(pc.hex): \(opcodeDesc.padLeft(toLength: 11))")
  }

  // MARK: - Print opcode details

  // swiftlint:disable:next function_body_length cyclomatic_complexity
  internal func printExecutedOpcodeDetails(before: DebugState, after: DebugState) {
    guard let opcode = self.unprefixedOpcodeAt(pc: before.cpu.pc) else {
      return
    }

    let next8  = self.next8(pc: before.cpu.pc)
    let next16 = self.next16(pc: before.cpu.pc)

    switch opcode {
    case .call_a16:
      print("  > call to \(next16.hex)")
    case .call_c_a16, .call_nc_a16, .call_nz_a16, .call_z_a16:
      let taken = after.cpu.pc == next16 ? "TAKEN" : "NOT TAKEN"
      print("  > conditional call to \(next16.hex) \(taken)")

    case .jp_a16, .jp_pHL:
      print("  > jump to \(next16.hex)")
    case  .jp_c_a16, .jp_nc_a16, .jp_nz_a16, .jp_z_a16:
      let taken = after.cpu.pc == next16 ? "TAKEN" : "NOT TAKEN"
      print("  > conditional jump to \(next16.hex) \(taken)")

    case .jr_r8:
      let offset = Int8(bitPattern: next8)
      let length = Int(2)
      let predictedPc = UInt16(Int(before.cpu.pc) + length + Int(offset))
      print("  > relative jump by \(offset) (to: \(predictedPc.hex))")
    case .jr_c_r8, .jr_nc_r8, .jr_nz_r8, .jr_z_r8:
      let offset = Int8(bitPattern: next8)
      let length = Int(2)
      let predictedPc = UInt16(Int(before.cpu.pc) + length + Int(offset))
      let taken = after.cpu.pc == predictedPc ? "TAKEN" : "NOT TAKEN"
      print("  > relative conditional jump by \(offset) (to: \(predictedPc.hex)) \(taken)")

    case .ret:
      print("  > return to \(after.cpu.pc.hex)")
    case .ret_c, .ret_nc, .ret_nz, .ret_z, .reti:
      let length: UInt16 = 1
      let taken = after.cpu.pc == before.cpu.pc + length ? "NOT TAKEN" : "TAKEN"
      print("  > conditional return \(taken)")

    case .rst_00, .rst_08, .rst_10, .rst_18, .rst_20, .rst_28, .rst_30, .rst_38:
      print("  > rst call: \(opcode)")

    case .push_af, .push_bc, .push_de, .push_hl:
      print("  > push - \(opcode)")
    case .pop_af, .pop_bc, .pop_de, .pop_hl:
      print("  > pop - \(opcode)")

    case .prefix:
      print("  > prefix instruction")

    default:
      break
    }
  }

  // MARK: - Print register writes

  internal func printRegiserWrites(before: DebugState, after: DebugState) {
    func printIfChanged<T: Equatable>(name: String, path: KeyPath<DebugState, T>) {
      let valueBefore = before[keyPath: path]
      let valueAfter = after[keyPath: path]

      if valueBefore != valueAfter {
        print("  > \(name) <- \(valueAfter)")
      }
    }

    printIfChanged(name: "cpu.a", path: \DebugState.cpu.a)
    printIfChanged(name: "cpu.b", path: \DebugState.cpu.b)
    printIfChanged(name: "cpu.c", path: \DebugState.cpu.c)
    printIfChanged(name: "cpu.d", path: \DebugState.cpu.d)
    printIfChanged(name: "cpu.e", path: \DebugState.cpu.e)
    printIfChanged(name: "cpu.h", path: \DebugState.cpu.h)
    printIfChanged(name: "cpu.l", path: \DebugState.cpu.l)

    printIfChanged(name: "cpu.zeroFlag", path: \DebugState.cpu.zeroFlag)
    printIfChanged(name: "cpu.subtractFlag", path: \DebugState.cpu.subtractFlag)
    printIfChanged(name: "cpu.halfCarryFlag", path: \DebugState.cpu.halfCarryFlag)
    printIfChanged(name: "cpu.carryFlag", path: \DebugState.cpu.carryFlag)

    printIfChanged(name: "cpu.pc", path: \DebugState.cpu.pc)
    printIfChanged(name: "cpu.sp", path: \DebugState.cpu.sp)
  }

  // MARK: - Print register values

  public func dumpCpuState() {
    let stackStart: UInt16 = self.cpu.sp
    var stackEnd:   UInt16 = 0xfffe

    let stackCount = stackEnd - stackStart
    if stackCount > 20 {
      stackEnd = stackStart + 20
    }

    let stackValues = (stackStart...stackEnd).map { self.memory.read($0) }

    let r = self.cpu.registers
    print("""
Cpu
  pc: \(cpu.pc) (\(cpu.pc.hex))
  sp: \(cpu.sp) (\(cpu.sp.hex)) \(stackValues.map { $0.hex })
  cycle: \(cpu.cycle)
  auxiliary registers:
    a: \(formatRegister(r.a))
    b: \(formatRegister(r.b)) | c: \(formatRegister(r.c)) | bc: \(formatRegister(r.bc))
    d: \(formatRegister(r.d)) | e: \(formatRegister(r.e)) | de: \(formatRegister(r.de))
    h: \(formatRegister(r.h)) | l: \(formatRegister(r.l)) | hl: \(formatRegister(r.hl))
  flags:
    z: \(formatFlag(r.zeroFlag))
    n: \(formatFlag(r.subtractFlag))
    h: \(formatFlag(r.halfCarryFlag))
    c: \(formatFlag(r.carryFlag))
""")
  }

  private func formatRegister(_ value: UInt8) -> String {
    return "\(value.dec) (\(value.hex))"
  }

  private func formatRegister(_ value: UInt16) -> String {
    return "\(value.dec) (\(value.hex))"
  }

  private func formatFlag(_ value: Bool) -> String {
    return value ? "1" : "0"
  }
}
