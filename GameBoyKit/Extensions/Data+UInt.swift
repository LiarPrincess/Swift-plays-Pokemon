// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

extension Data {

  public subscript(index: UInt8) -> UInt8 {
    get { return self[Int(index)] }
    set { self[Int(index)] = newValue }
  }

  public subscript(index: UInt16) -> UInt8 {
    get { return self[Int(index)] }
    set { self[Int(index)] = newValue }
  }
}
