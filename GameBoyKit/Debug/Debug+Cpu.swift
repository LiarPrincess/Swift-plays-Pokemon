// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// MARK: - Registers

extension Debug {

  internal static func registersDidSet(_ f: FlagRegister) {
    if fRegisterWrites {
      let value = registers.get(f)
      print("> register - setting \(f) to \(value ? 1 : 0)")
    }
  }

  internal static func registersDidSet(_ r: SingleRegister) {
    if fRegisterWrites {
      let value = registers.get(r)
      print("> register - setting \(r) to \(value.hex)")
    }
  }

  internal static func registersDidSet(_ r: CombinedRegister) {
    if fRegisterWrites {
      let value = registers.get(r)
      print("> register - setting \(r) to \(value.hex)")
    }
  }
}

// MARK: - Cpu

extension Debug {

  internal static func cpuWillExecute(opcode: UnprefixedOpcode) {
    if fOpcode {
      printOpcode(opcode: String(describing: opcode), length: getOpcodeLength(opcode))
    }
  }

  internal static func cpuWillExecute(opcode: CBPrefixedOpcode) {
    if fOpcode {
      printOpcode(opcode: String(describing: opcode), length: 2)
    }
  }

  internal static func cpuDidExecute(opcode: UnprefixedOpcode) {
    if fOpcodeDetails {
      printAdditionalInfo(opcode: opcode)
      printRegisters(indent: "  ")
      printSeparator()
    }
  }

  internal static func cpuDidExecute(opcode: CBPrefixedOpcode) {
    if fOpcodeDetails {
      printRegisters(indent: "  ")
      printSeparator()
    }
  }
}

// MARK: - Print opcode

extension Debug {

  internal static func printOpcode(opcode: String, length: Int, indent: String = "") {
    let operands: String = {
      switch length {
      case 2: return next8.hex
      case 3: return next16.hex
      default: return ""
      }
    }()

    print("\(indent)\(cpu.pc.hex): \(opcode.padLeft(toLength: 11)) \(operands)")
  }

  /// We can't just 'cpu.memory.read' as this may involve side-effect on emulator side
  private static var next8: UInt8 {
    return bus.readInternal(cpu.pc + 1)
  }

  /// We can't just 'cpu.memory.read' as this may involve side-effect on emulator side
  private static var next16: UInt16 {
    let low  = UInt16(bus.readInternal(cpu.pc + 1))
    let high = UInt16(bus.readInternal(cpu.pc + 2))
    return (high << 8) | low
  }

  private static func getOpcodeLength(_ opcode: UnprefixedOpcode) -> Int {
    switch opcode {
    case .adc_a_d8, .add_a_d8, .add_sp_r8, .and_d8, .cp_d8,
         .jr_c_r8, .jr_nc_r8, .jr_nz_r8, .jr_r8, .jr_z_r8,
         .ld_a_d8, .ld_b_d8, .ld_c_d8, .ld_d_d8, .ld_e_d8, .ld_h_d8, .ld_hl_spR8, .ld_l_d8, .ld_pHL_d8,
         .ldh_a_pA8, .ldh_pA8_a,
         .sub_d8, .sbc_a_d8,
         .or_d8, .xor_d8:
      return 2

    case .call_a16, .call_c_a16, .call_nc_a16, .call_nz_a16, .call_z_a16, .jp_a16,
         .jp_c_a16, .jp_nc_a16, .jp_nz_a16, .jp_z_a16, .ld_a_pA16,
         .ld_bc_d16, .ld_de_d16, .ld_hl_d16, .ld_pA16_a, .ld_pA16_sp, .ld_sp_d16:
      return 3

    default:
      return 1
    }
  }
}

// MARK: - Print registers

extension Debug {

  internal static func printRegisters(indent: String = "") {
    let stackStart: UInt16 = max(0xff80, cpu.sp)
    let stackEnd:   UInt16 = 0xfffe
    let stackValues = (stackStart...stackEnd).map { bus.readInternal($0) }

    let r = registers
    print("""
      \(indent)cycle: \(cpu.cycle)
      \(indent)pc: \(cpu.pc) (\(cpu.pc.hex))
      \(indent)sp: \(cpu.sp) (\(cpu.sp.hex))
      \(indent)  \(stackValues.reversed().map { $0.hex })
      \(indent)auxiliary registers:
      \(indent)  a: \(registerValue(r.a))
      \(indent)  b: \(registerValue(r.b)) | c: \(registerValue(r.c)) | bc: \(registerValue(r.bc))
      \(indent)  d: \(registerValue(r.d)) | e: \(registerValue(r.e)) | de: \(registerValue(r.de))
      \(indent)  h: \(registerValue(r.h)) | l: \(registerValue(r.l)) | hl: \(registerValue(r.hl))
      \(indent)flags:
      \(indent)  z:\(flagValue(r.zeroFlag)) n:\(flagValue(r.subtractFlag)) h:\(flagValue(r.halfCarryFlag)) c:\(flagValue(r.carryFlag))
      """)
  }

  private static func registerValue(_ value: UInt8) -> String {
    return "\(value.dec) (\(value.hex))"
  }

  private static func registerValue(_ value: UInt16) -> String {
    return "\(value.dec) (\(value.hex))"
  }

  private static func flagValue(_ value: Bool) -> String {
    return value ? "1" : "0"
  }
}

// MARK: - Print additional info

extension Debug {

  private static func printAdditionalInfo(opcode: UnprefixedOpcode) {
    let length = getOpcodeLength(opcode)
    if length > 1 {
      print("> opcode - reading additional \(length - 1) byte(s) for arguments")
    }

    let pc = "\(cpu.pc) (\(cpu.pc.hex))"
    switch opcode {
    case .call_a16, .call_c_a16, .call_nc_a16, .call_nz_a16, .call_z_a16:
      print("> call to \(pc)")

    case .jp_a16, .jp_pHL:
      print("> jump to \(pc)")
    case  .jp_c_a16, .jp_nc_a16, .jp_nz_a16, .jp_z_a16:
      print("> conditional jump (don't know if taken). pc after: \(pc)")

    case .jr_r8:
      print("> relative jump to \(pc)")
    case .jr_c_r8, .jr_nc_r8, .jr_nz_r8, .jr_z_r8:
      print("> relative conditional jump (don't know if taken). pc after \(pc)")

    case .ret, .ret_c, .ret_nc, .ret_nz, .ret_z, .reti:
      print("> return to \(pc)")
    case .rst_00, .rst_08, .rst_10, .rst_18, .rst_20, .rst_28, .rst_30, .rst_38:
      print("> rst call to \(pc)")

    //case .push_af, .push_bc, .push_de, .push_hl:
    //print("> push")
    //case .pop_af, .pop_bc, .pop_de, .pop_hl:
    //print("> pop")

    case .prefix:
      print("> prefix - will read additional 8 bytes")
    default:
      break
    }
  }
}
