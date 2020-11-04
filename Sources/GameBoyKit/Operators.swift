// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftlint:disable static_operator

precedencegroup OrEqual {
  associativity: right
  higherThan: AssignmentPrecedence
  lowerThan: FunctionArrowPrecedence
}

infix operator ||= : OrEqual

// internal because Apple may introduce it and we don't want to break clients
// (but, it is ok to break ourselves)
internal func ||= (left: inout Bool, right: Bool) {
  left = left || right
}
