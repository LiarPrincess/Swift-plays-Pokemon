extension Array {
  public subscript(index: UInt8) -> Element {
    get { return self[Int(index)] }
    set { self[Int(index)] = newValue }
  }

  public subscript(index: UInt16) -> Element {
    get { return self[Int(index)] }
    set { self[Int(index)] = newValue }
  }
}
