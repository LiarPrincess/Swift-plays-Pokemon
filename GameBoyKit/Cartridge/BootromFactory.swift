// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

public enum BootromFactory {

  public static func fromData(_ data: Data) throws -> Bootrom {
    guard data.count == Bootrom.size else {
      throw BootromCreationError.invalidSize
    }

    return Bootrom(data: data)
  }
}
