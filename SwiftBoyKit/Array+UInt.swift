extension Array {
  public init(repeating repeatedValue: Element, count: UInt16) {
    self.init(repeating: repeatedValue, count: Int(count))
  }

  public subscript(index: UInt8) -> Element {
    get { return self[Int(index)] }
    set { self[Int(index)] = newValue }
  }

  public subscript(index: UInt16) -> Element {
    get { return self[Int(index)] }
    set { self[Int(index)] = newValue }
  }
}
