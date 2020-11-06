// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

/// FF01 - SB - Data send using serial transfer
public final class LinkCable {

  public private(set) var data = Data()

  internal func write(_ value: UInt8) {
    self.data.append(value)
  }
}
