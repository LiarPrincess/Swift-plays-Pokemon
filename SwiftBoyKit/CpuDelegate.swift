public protocol CpuDelegate: class {
  func cpuWillExecute(_ cpu: Cpu, opcode: UnprefixedOpcode)
  func cpuWillExecute(_ cpu: Cpu, opcode: CBPrefixedOpcode)

  func cpuDidExecute(_ cpu: Cpu, opcode: UnprefixedOpcode)
  func cpuDidExecute(_ cpu: Cpu, opcode: CBPrefixedOpcode)
}

public extension CpuDelegate {
  func cpuWillExecute(_ cpu: Cpu, opcode: UnprefixedOpcode) { }
  func cpuWillExecute(_ cpu: Cpu, opcode: CBPrefixedOpcode) { }

  func cpuDidExecute(_ cpu:Cpu, opcode: UnprefixedOpcode) { }
  func cpuDidExecute(_ cpu:Cpu, opcode: CBPrefixedOpcode) { }
}
