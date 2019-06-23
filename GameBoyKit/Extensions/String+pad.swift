// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

extension String {

  public func padLeft(toLength newLength: Int) -> String {
    // self.count is O(n)
    let currentCount = self.count

    if currentCount >= newLength {
      return self
    }

    let padCount = newLength - currentCount
    return String(repeating: " ", count: padCount) + self
  }
}
