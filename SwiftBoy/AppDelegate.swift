import Cocoa
import SwiftBoyKit

@NSApplicationMain
public class AppDelegate: NSObject, NSApplicationDelegate {

  private let debug = Debug()

  public func applicationDidFinishLaunching(_ aNotification: Notification) {
//    let cpu = loadEmptyCpu()
//    let cpu = loadState(from: "bootrom_skipToAudio.json")
//    let cpu = loadState(from: "bootrom_skipToNintendoLogo.json")
    let cpu = loadState(from: "bootrom_skipToTileMap.json")

    cpu.memory.delegate = self.debug
    cpu.delegate = self.debug

    self.debug.printRegisters(cpu, indent: "")
    print("---------------------")

    cpu.run(maxCycles: 5, lastPC: 0xffff) // maxCycles: 100_000, lastPC: 0x0050

//    saveState(cpu: cpu, to: "bootrom_skipToTileMap.json")
  }
}

public class Debug: CpuDelegate, MemoryDelegate {

  public enum Mode {
    case none
    case full
    case onlyOpcodes
  }

  private let mode = Mode.full

  public func registersDidSet(r: SingleRegister, to value: UInt8) {
    if self.mode == .full {
      print("> register - setting \(r) to \(value.hex)")
    }
  }

  private func cpuWillExecuteShared<Type>(_ cpu: Cpu, opcode: Opcode<Type>) {
    if self.mode == .onlyOpcodes || self.mode == .full {
      self.printOpcode(cpu, opcode: opcode)
    }
  }

  private func cpuDidExecuteShared<Type>(_ cpu: Cpu, opcode: Opcode<Type>) {
    if self.mode == .full {
      self.printAdditionalInfo(cpu, opcode: opcode)
      self.printRegisters(cpu, indent: "  ")
      print()
      print("---------------------")
      print()
    }
  }

  public func memoryDidRead(_ memory: Memory, address: UInt16, value: UInt8) {
    if self.mode == .full {
      print("> memory - reading \(value.hex) from \(address.hex)")
    }
  }
  public func memoryWillWrite(_ memory: Memory, address: UInt16, value: UInt8) {
    if self.mode == .full {
      print("> memory - writing \(value.hex) to \(address.hex)")
    }
  }

  public func cpuWillExecute(_ cpu: Cpu, opcode: UnprefixedOpcode) { if opcode.value != .prefix { self.cpuWillExecuteShared(cpu, opcode: opcode) } }
  public func cpuWillExecute(_ cpu: Cpu, opcode: CBPrefixedOpcode) { self.cpuWillExecuteShared(cpu, opcode: opcode) }
  public func cpuDidExecute(_ cpu: Cpu, opcode: UnprefixedOpcode) { if opcode.value != .prefix { self.cpuDidExecuteShared(cpu, opcode: opcode) } }
  public func cpuDidExecute(_ cpu: Cpu, opcode: CBPrefixedOpcode) { self.cpuDidExecuteShared(cpu, opcode: opcode) }
}

// MARK: - Print opcode

extension Debug {

  private func printOpcode<Type>(_ cpu: Cpu, opcode: Opcode<Type>, indent: String = "") {
    let pc = cpu.pc.hex
    let mnemonic = String(describing: opcode.value).pad(toLength: 11)

    var operands: String = {
      switch opcode.length {
      case 2: return self.next8(cpu).hex
      case 3: return self.next16(cpu).hex
      default: return ""
      }
    }()
    operands = operands.pad(toLength: 8)

    let additional = "(raw: \(opcode.rawValue.hex), length: \(opcode.length), cycles: \(opcode.cycles) \(opcode.alternativeCycles))"
    print("\(indent)\(pc): \(mnemonic) \(operands) \(additional)")
  }

  /// We can't just 'cpu.memory.read' as this may involve side-effect on emulator side
  private func next8(_ cpu: Cpu) -> UInt8 {
    return cpu.memory.data[cpu.pc + 1]
  }

  /// We can't just 'cpu.memory.read' as this may involve side-effect on emulator side
  private func next16(_ cpu: Cpu) -> UInt16 {
    let low  = UInt16(cpu.memory.data[cpu.pc + 1])
    let high = UInt16(cpu.memory.data[cpu.pc + 2])
    return (high << 8) | low
  }
}

// MARK: - printRegisters

extension Debug {

  public func printRegisters(_ cpu: Cpu, indent: String = "") {
    let registers = cpu.registers

    let stackStart = Int(cpu.sp)
    let stackEnd = 0xfffe
    let stackValues = stackEnd - stackStart <= 16 ? cpu.memory.data[stackStart..<stackEnd] : []

    print("""
\(indent)cycle: \(cpu.currentCycle)
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

  private func registerValue(_ value: UInt8) -> String {
    return "\(value.dec) (\(value.hex))"
  }

  private func registerValue(_ value: UInt16) -> String {
    return "\(value.dec) (\(value.hex))"
  }

  private func flagValue(_ value: Bool) -> String {
    return value ? "1" : "0"
  }
}

// MARK: - Additional info

extension Debug {
  private func printAdditionalInfo<Type>(_ cpu: Cpu, opcode: Opcode<Type>) {
    guard let unprefixedOpcode = opcode as? UnprefixedOpcode else {
      return
    }

    let pc = "\(cpu.pc) (\(cpu.pc.hex))"
    switch unprefixedOpcode.value {
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
