public protocol CpuDelegate: RegistersDelegate {
  func cpuWillExecute(_ cpu: Cpu, opcode: UnprefixedOpcode)
  func cpuWillExecute(_ cpu: Cpu, opcode: CBPrefixedOpcode)

  func cpuDidExecute(_ cpu: Cpu, opcode: UnprefixedOpcode)
  func cpuDidExecute(_ cpu: Cpu, opcode: CBPrefixedOpcode)
}

extension CpuDelegate {
  public func cpuWillExecute(_ cpu: Cpu, opcode: UnprefixedOpcode) { }
  public func cpuWillExecute(_ cpu: Cpu, opcode: CBPrefixedOpcode) { }

  public func cpuDidExecute(_ cpu: Cpu, opcode: UnprefixedOpcode) { }
  public func cpuDidExecute(_ cpu: Cpu, opcode: CBPrefixedOpcode) { }
}
