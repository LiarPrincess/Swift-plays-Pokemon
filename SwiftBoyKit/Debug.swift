private enum DebugMode {
  case none
  case full
  case onlyOpcodes
  case onlyMemoryWrites
}

internal enum Debug {
  private static let mode = DebugMode.full

  internal static func emulatorWillRun(_ emulator: Emulator) {
    printRegisters(emulator.cpu)
    printSeparator()
  }

  internal static func registersDidSet(f: FlagRegister, to value: Bool) {
    if mode == .full {
      print("> register - setting \(f) to \(value ? 1 : 0)")
    }
  }
  internal static func registersDidSet(r: SingleRegister, to value: UInt8) {
    if mode == .full {
      print("> register - setting \(r) to \(value.hex)")
    }
  }

  internal static func cpuWillExecute(_ cpu: Cpu, opcode: UnprefixedOpcode) {
    if mode == .onlyOpcodes || mode == .full {
      self.printOpcode(cpu, opcode: String(describing: opcode), length: getOpcodeLength(opcode))
    }
  }
  internal static func cpuWillExecute(_ cpu: Cpu, opcode: CBPrefixedOpcode) {
    if mode == .onlyOpcodes || mode == .full {
      self.printOpcode(cpu, opcode: String(describing: opcode), length: 2)
    }
  }
  internal static func cpuDidExecute(_ cpu: Cpu, opcode: UnprefixedOpcode) {
    if mode == .full {
      self.printAdditionalInfo(cpu, opcode: opcode)
      self.printRegisters(cpu, indent: "  ")
      self.printSeparator()
    }
  }
  internal static func cpuDidExecute(_ cpu: Cpu, opcode: CBPrefixedOpcode) {
    if mode == .full {
      self.printRegisters(cpu, indent: "  ")
      self.printSeparator()
    }
  }

  internal static func memoryDidRead(_ memory: Memory, address: UInt16, value: UInt8) {
    if mode == .full {
      print("> memory - reading \(value.hex) from \(address.hex)")
    }
  }
  internal static func memoryDidWrite(_ memory: Memory, address: UInt16, value: UInt8) {
    if mode == .full || mode == .onlyMemoryWrites {
      print("> memory - writing \(value.hex) to \(address.hex)")
    }
  }
}

// MARK: - Print opcode

extension Debug {

  private static func printOpcode(_ cpu: Cpu, opcode: String, length: Int, indent: String = "") {
    let operands: String = {
      switch length {
      case 2: return self.next8(cpu).hex
      case 3: return self.next16(cpu).hex
      default: return ""
      }
    }()

    print("\(indent)\(cpu.pc.hex): \(opcode.pad(toLength: 11)) \(operands)")
  }

  /// We can't just 'cpu.memory.read' as this may involve side-effect on emulator side
  private static func next8(_ cpu: Cpu) -> UInt8 {
    let memory = cpu.memory as! Memory
    return memory[cpu.pc + 1]
  }

  /// We can't just 'cpu.memory.read' as this may involve side-effect on emulator side
  private static func next16(_ cpu: Cpu) -> UInt16 {
    let memory = cpu.memory as! Memory
    let low  = UInt16(memory[cpu.pc + 1])
    let high = UInt16(memory[cpu.pc + 2])
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

  private static func printSeparator() {
    print()
    print("---------------------")
    print()
  }
}

// MARK: - printRegisters

extension Debug {

  private static func printRegisters(_ cpu: Cpu, indent: String = "") {
    let registers = cpu.registers
    let memory = cpu.memory as! Memory
    let stackValues = memory[max(0xff80, Int(cpu.sp))..<0xfffe]

    print("""
      \(indent)cycle: \(cpu.cycle)
      \(indent)pc: \(cpu.pc) (\(cpu.pc.hex))
      \(indent)sp: \(cpu.sp) (\(cpu.sp.hex))
      \(indent)  \(stackValues.reversed().map { $0.hex })
      \(indent)auxiliary registers:
      \(indent)  a: \(registerValue(registers.a))
      \(indent)  b: \(registerValue(registers.b)) | c: \(registerValue(registers.c)) | bc: \(registerValue(registers.bc))
      \(indent)  d: \(registerValue(registers.d)) | e: \(registerValue(registers.e)) | de: \(registerValue(registers.de))
      \(indent)  h: \(registerValue(registers.h)) | l: \(registerValue(registers.l)) | hl: \(registerValue(registers.hl))
      \(indent)flags:
      \(indent)  z:\(flagValue(registers.zeroFlag)) n:\(flagValue(registers.subtractFlag)) h:\(flagValue(registers.halfCarryFlag)) c:\(flagValue(registers.carryFlag))
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

// MARK: - Additional info

extension Debug {
  private static func printAdditionalInfo(_ cpu: Cpu, opcode: UnprefixedOpcode) {
    let length = getOpcodeLength(opcode)
    if length > 1 {
      print("> opcode - reading additional \(length - 1) byte(s) for arguments")
    }

    let pc = "\(cpu.pc) (\(cpu.pc.hex))"
    switch opcode {
    case .call_a16, .call_c_a16, .call_nc_a16, .call_nz_a16, .call_z_a16:
      print("> call to \(pc)")
    case .jp_a16, .jp_c_a16, .jp_nc_a16, .jp_nz_a16, .jp_pHL, .jp_z_a16:
      print("> jump to \(pc)")
    case .jr_c_r8, .jr_nc_r8, .jr_nz_r8, .jr_r8, .jr_z_r8:
      print("> relative jump to \(pc)")
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

/*
 // swiftlint:disable:nextA function_body_length
 private func compare(_ new: Cpu, _ old: Cpu) {
 print("")
 print("")
 print("")
 print("")
 print("")
 print("Starting compare")
 let a = true

 print("pc: \(new.pc) vs \(old.pc)")
 assert(a || new.pc == old.pc)

 print("sp: \(new.sp) vs \(old.sp)")
 assert(a || new.sp == old.sp)

 print("a: \(new.registers.a) vs \(old.registers.a)")
 assert(a || new.registers.a == old.registers.a)

 print("b: \(new.registers.b) vs \(old.registers.b)")
 assert(a || new.registers.b == old.registers.b)

 print("c: \(new.registers.c) vs \(old.registers.c)")
 assert(a || new.registers.c == old.registers.c)

 print("d: \(new.registers.d) vs \(old.registers.d)")
 assert(a || new.registers.d == old.registers.d)

 print("e: \(new.registers.e) vs \(old.registers.e)")
 assert(a || new.registers.e == old.registers.e)

 print("h: \(new.registers.h) vs \(old.registers.h)")
 assert(a || new.registers.h == old.registers.h)

 print("l: \(new.registers.l) vs \(old.registers.l)")
 assert(a || new.registers.l == old.registers.l)

 print("zeroFlag: \(new.registers.zeroFlag) vs \(old.registers.zeroFlag)")
 assert(a || new.registers.zeroFlag == old.registers.zeroFlag)

 print("subtractFlag: \(new.registers.subtractFlag) vs \(old.registers.subtractFlag)")
 assert(a || new.registers.subtractFlag == old.registers.subtractFlag)

 print("halfCarryFlag: \(new.registers.halfCarryFlag) vs \(old.registers.halfCarryFlag)")
 assert(a || new.registers.halfCarryFlag == old.registers.halfCarryFlag)

 print("carryFlag: \(new.registers.carryFlag) vs \(old.registers.carryFlag)")
 assert(a || new.registers.carryFlag == old.registers.carryFlag)

 print("memory")
 assert(a || new.memory.data == old.memory.data)

 print("all fine")
 }
 */
