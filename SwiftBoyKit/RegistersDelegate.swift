public protocol RegistersDelegate: AnyObject {
  func registersDidSet(r: SingleRegister, to value: UInt8)
}

extension RegistersDelegate {
  public func registersDidSet(r: SingleRegister, to value: UInt8) { }
}
