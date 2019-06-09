// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

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
