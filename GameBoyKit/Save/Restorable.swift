// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

internal protocol Restorable {
  func save(to state: inout GameBoyState)
  func load(from state: GameBoyState)
}
