public protocol RegistersDelegate: class {
  func registersDidSet(r: SingleRegister, to value: UInt8)
}

public extension RegistersDelegate {
  func registersDidSet(r: SingleRegister, to value: UInt8) { }
}
