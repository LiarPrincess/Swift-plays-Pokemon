// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

// Idk, it just feels more natural this way.

extension ClosedRange {

  /// First element included in range
  public var start: Bound { return self.lowerBound }

  /// Last element included in range
  public var end: Bound { return self.upperBound }
}
