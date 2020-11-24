// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public struct SpriteSize: Equatable {

  internal static let size8 = SpriteSize(value: 8)
  internal static let size16 = SpriteSize(value: 16)

  public let value: Int

  private init(value: Int) {
    self.value = value
  }
}
