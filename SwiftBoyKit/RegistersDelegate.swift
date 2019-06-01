public protocol RegistersDelegate: AnyObject {
  func registersDidSet(f: FlagRegister, to value: Bool)
  func registersDidSet(r: SingleRegister, to value: UInt8)
}

extension RegistersDelegate {
  public func registersDidSet(f: FlagRegister, to value: Bool) { }
  public func registersDidSet(r: SingleRegister, to value: UInt8) { }
}
