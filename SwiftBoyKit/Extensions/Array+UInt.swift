// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

// TODO: Cleanup?

extension Array where Element == UInt8 {
  internal init(memoryRange range: ClosedRange<UInt16>) {
    self.init(repeating: 0, count: range.count)
  }
}

extension Array {
  public init(repeating repeatedValue: Element, count: UInt8) {
    self.init(repeating: repeatedValue, count: Int(count))
  }

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
