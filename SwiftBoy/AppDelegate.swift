import Cocoa
import SwiftBoyKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  let debug = Debug()

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    //    let cpu = loadEmptyCpu()
    //    let cpu = loadState(from: "bootrom_skipToAudio.json")!
//    let cpu = loadState(from: "bootrom_skipToNintendoLogo.json")!
    let cpu = loadState(from: "bootrom_skipToTileMap.json")!

    cpu.memory.delegate = self.debug
    cpu.delegate = self.debug

    cpu.run(maxCycles: 100_000, lastPC: 0x0040)
    //    cpu.run(maxPC: 0x000C)
    //    cpu.run()

    print("Finished")
    self.debug.printRegisters(cpu, indent: "  ")

//    saveState(cpu: cpu, to: "bootrom_skipToTileMap.json")
  }
}

enum DebugMode {
  case none
  case full
  case onlyOpcodes
}

class Debug: CpuDelegate, MemoryDelegate {

  private let mode = DebugMode.onlyOpcodes

  func registersDidSet(r: SingleRegister, to value: UInt8) {
    if self.mode == .full {
      print("> register - setting \(r) to \(value.hex)")
    }
  }

  private func cpuWillExecuteShared<Type>(_ cpu: Cpu, opcode: OpcodeBase<Type>) {
    if self.mode == .onlyOpcodes || self.mode == .full {
      self.printOpcode(cpu, opcode: opcode)
    }
    if self.mode == .full {
      self.printRegisters(cpu, indent: "  ")
    }
  }

  private func cpuDidExecuteShared<Type>(_ cpu: Cpu, opcode: OpcodeBase<Type>) {
    if self.mode == .full {
      self.printAdditionalInfo(cpu, opcode: opcode)
      self.printRegisters(cpu, indent: "  ")
      print()
      print("---------------------")
      print()
    }
  }

  func memoryDidRead(_ memory: Memory, address: UInt16, value: UInt8) {
    if self.mode == .full {
      print("> memory - reading \(value.hex) from \(address.hex)")
    }
  }
  func memoryWillWrite(_ memory: Memory, address: UInt16, value: UInt8) {
    if self.mode == .full {
      print("> memory - writing \(value.hex) to \(address.hex)")
    }
  }

  func cpuWillExecute(_ cpu: Cpu, opcode: UnprefixedOpcode) { if opcode.type != .prefix { self.cpuWillExecuteShared(cpu, opcode: opcode) } }
  func cpuWillExecute(_ cpu: Cpu, opcode: CBPrefixedOpcode) { self.cpuWillExecuteShared(cpu, opcode: opcode) }
  func cpuDidExecute(_ cpu: Cpu, opcode: UnprefixedOpcode) { if opcode.type != .prefix { self.cpuDidExecuteShared(cpu, opcode: opcode) } }
  func cpuDidExecute(_ cpu: Cpu, opcode: CBPrefixedOpcode) { self.cpuDidExecuteShared(cpu, opcode: opcode) }
}

// MARK: - Print opcode

extension Debug {

  func printOpcode<Type>(_ cpu: Cpu, opcode: OpcodeBase<Type>, indent: String = "") {
    let pc = cpu.pc.hex
    let mnemonic = opcode.debug.pad(toLength: 11)

    var operands: String = {
      switch opcode.length {
      case 2: return self.next8(cpu).hex
      case 3: return self.next16(cpu).hex
      default: return ""
      }
    }()
    operands = operands.pad(toLength: 8)

    let additional = "(addr: \(opcode.addr), length: \(opcode.length), cycles: \(opcode.cycles))"
    print("\(indent)\(pc): \(mnemonic) \(operands) \(additional)")
  }

  private func next8(_ cpu: Cpu) -> UInt8 {
    return cpu.memory.data[cpu.pc + 1]
  }

  private func next16(_ cpu: Cpu) -> UInt16 {
    let low  = UInt16(cpu.memory.data[cpu.pc + 1])
    let high = UInt16(cpu.memory.data[cpu.pc + 2])
    return (high << 8) | low
  }
}

// MARK: - printRegisters

extension Debug {

  // swiftlint:disable:next function_body_length
  func printRegisters(_ cpu: Cpu, indent: String = "") {
    print("\(indent)cycle: \(cpu.currentCycle)")
    print("\(indent)pc: \(cpu.pc) (\(cpu.pc.hex))")

    let stackStart = Int(cpu.sp)
    let stackEnd = 0xfffe
    let stack = stackEnd - stackStart <= 16 ? cpu.memory.data[stackStart..<stackEnd] : []
    print("\(indent)sp: \(cpu.sp) (\(cpu.sp.hex))")
    print("\(indent)  \(stack.reversed().map { $0.hex })")

    print("\(indent)values:")

    var lineA = "\(indent)  "
    lineA += "\(getSingleRegisterInfo("a", cpu.registers.a))"
    print(lineA)

    var lineBC = "\(indent)  "
    lineBC += getSingleRegisterInfo("b", cpu.registers.b) + " | "
    lineBC += getSingleRegisterInfo("c", cpu.registers.c) + " | "
    lineBC += getCombinedRegisterInfo("bc", cpu.registers.bc)
    print(lineBC)

    var lineDE = "\(indent)  "
    lineDE += getSingleRegisterInfo("d", cpu.registers.d) + " | "
    lineDE += getSingleRegisterInfo("e", cpu.registers.e) + " | "
    lineDE += getCombinedRegisterInfo("de", cpu.registers.de)
    print(lineDE)

    var lineHL = "\(indent)  "
    lineHL += getSingleRegisterInfo("h", cpu.registers.h) + " | "
    lineHL += getSingleRegisterInfo("l", cpu.registers.l) + " | "
    lineHL += getCombinedRegisterInfo("hl", cpu.registers.hl)
    print(lineHL)

    print("\(indent)flags:")
    var flags = ""
    flags += "z:\(cpu.registers.zeroFlag      ? 1 : 0) "
    flags += "n:\(cpu.registers.subtractFlag  ? 1 : 0) "
    flags += "h:\(cpu.registers.halfCarryFlag ? 1 : 0) "
    flags += "c:\(cpu.registers.carryFlag     ? 1 : 0) "
    print("\(indent)  \(flags)")
  }

  private func getSingleRegisterInfo(_ name: String, _ value: UInt8) -> String {
    return "\(name) \(value.dec) (\(value.hex))"
  }

  private func getCombinedRegisterInfo(_ name: String, _ value: UInt16) -> String {
    return "\(name) \(value.dec) (\(value.hex))"
  }
}

// MARK: - Additional info

extension Debug {
  func printAdditionalInfo<Type>(_ cpu: Cpu, opcode: OpcodeBase<Type>) {
    guard let unprefixedOpcode = opcode as? UnprefixedOpcode else {
      return
    }

    let pc = "\(cpu.pc) (\(cpu.pc.hex))"
    switch unprefixedOpcode.type {
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
