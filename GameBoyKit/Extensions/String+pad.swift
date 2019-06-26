// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

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
