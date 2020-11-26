// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

public struct ExternalRamState {

  /// Data that should be saved to be able to restore state.
  public let data: Data

  /// Init from previously saved `self.data`.
  public init(data: Data) {
    self.data = data
  }

  /// Init from current Game Boy state.
  public init(gameBoy: GameBoy) {
    let cartridge = gameBoy.memory.cartridge
    self.data = cartridge.ram
  }
}
