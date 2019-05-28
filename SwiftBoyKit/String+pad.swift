extension StringProtocol {
  public func pad(toLength newLength: Int) -> String {
    return self.padding(toLength: newLength, withPad: " ", startingAt: 0)
  }
}
