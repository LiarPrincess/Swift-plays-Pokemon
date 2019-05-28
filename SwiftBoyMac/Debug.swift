import SwiftBoyKit

class Debug {
  func skipToAudio(_ cpu: Cpu) {
    cpu.pc = 0x000c
    cpu.sp = 0xfffe
    cpu.registers.hl = 0x7fff
    cpu.registers.zeroFlag = true
    cpu.registers.halfCarryFlag = true
  }

  //private mutating func skipAfterAudio() {
  //  //    Finished
  //  //    pc: 29 (0x001d)
  //  //    sp: 65534 (0xfffe)
  //  //    values:
  //  //    a 119 (0x77)
  //  //    b   0 (0x00) | c  18 (0x12) | bc 0x0012 (0x0012)
  //  //    d   0 (0x00) | e   0 (0x00) | de 0x0000 (0x0000)
  //  //    h 255 (0xff) | l  36 (0x24) | hl 0xff24 (0xff24)
  //  //    flags:
  //  //    z:0 n:0 h:0 c:0
  //}

  ////    print("Finished")
  ////    self.debugRegisters(indent: "  ")
}

//extension Debug: MemoryDelegate {
//  func memoryWillWrite(_ memory: Memory, address: UInt16, value: UInt8)
//    print("[memory] writing \(value.hex) to \(address.hex)")
//  }
//}

extension Debug: CpuDelegate {

  func cpuWillExecute(_ cpu: Cpu, opcode: UnprefixedOpcode) { self.willExecute(cpu, opcode: opcode) }
  func cpuWillExecute(_ cpu: Cpu, opcode: CBPrefixedOpcode) { self.willExecute(cpu, opcode: opcode) }

  func cpuDidExecute(_ cpu: Cpu, opcode: UnprefixedOpcode) { self.didExecute(cpu, opcode: opcode) }
  func cpuDidExecute(_ cpu: Cpu, opcode: CBPrefixedOpcode) { self.didExecute(cpu, opcode: opcode) }

  private func willExecute<Type>(_ cpu: Cpu, opcode: OpcodeBase<Type>) {
    cpu.debugOpcode(cpu, opcode: opcode)
    cpu.debugRegisters(cpu, indent: "  ")
  }

  private func didExecute<Type>(_ cpu: Cpu, opcode: OpcodeBase<Type>) {
    print()
  }
}
