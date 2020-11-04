// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

// MARK: - String

extension String {

  public func padLeft(toLength newLength: Int) -> String {
    return self.createPadding(newLength) + self
  }

  public func padRight(toLength newLength: Int) -> String {
    return self + self.createPadding(newLength)
  }

  private func createPadding(_ newLength: Int) -> String {
    // self.count is O(n)
    let currentCount = self.count

    if currentCount >= newLength {
      return ""
    }

    let padCount = newLength - currentCount
    return String(repeating: " ", count: padCount)
  }
}

// MARK: - Numbers

extension UInt8 {

  public var dec: String {
    let s = String(self, radix: 10, uppercase: false)
    let padding = String(repeating: " ", count: 3 - s.count)
    return "\(padding)\(s)"
  }

  public var hex: String  {
    let s = String(self, radix: 16, uppercase: false)
    let padding = String(repeating: "0", count: 2 - s.count)
    return "0x\(padding)\(s)"
  }

  public var bin: String  {
    let s = String(self, radix: 2, uppercase: false)
    let padding = String(repeating: "0", count: 8 - s.count)
    return "0b\(padding)\(s)"
  }
}

extension UInt16 {

  public var dec: String {
    let s = String(self, radix: 10, uppercase: false)
    let padding = String(repeating: " ", count: 5 - s.count)
    return "\(padding)\(s)"
  }

  public var hex: String  {
    let s = String(self, radix: 16, uppercase: false)
    let padding = String(repeating: "0", count: 4 - s.count)
    return "0x\(padding)\(s)"
  }

  public var bin: String  {
    let s = String(self, radix: 2, uppercase: false)
    let padding = String(repeating: "0", count: 16 - s.count)
    return "0b\(padding)\(s)"
  }
}

// MARK: - Data

extension Data {

  internal init(memoryRange range: ClosedRange<UInt16>) {
    self.init(count: range.count)
  }

  public subscript(index: UInt8) -> UInt8 {
    get { return self[Int(index)] }
    set { self[Int(index)] = newValue }
  }

  public subscript(index: UInt16) -> UInt8 {
    get { return self[Int(index)] }
    set { self[Int(index)] = newValue }
  }
}

// MARK: - Range

extension Range {

  /// First element included in range
  public var start: Bound { return self.lowerBound }

  /// Last element included in range
  public var end: Bound { return self.upperBound }
}

extension ClosedRange {

  /// First element included in range
  public var start: Bound { return self.lowerBound }

  /// Last element included in range
  public var end: Bound { return self.upperBound }
}
