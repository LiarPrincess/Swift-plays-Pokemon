// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public struct GameboyInput {

  public var up    = false
  public var down  = false
  public var left  = false
  public var right = false

  public var a = false
  public var b = false
  public var start  = false
  public var select = false

  public init() { }
}

public protocol GameboyInputProvider: AnyObject {
  func getGameboyInput() -> GameboyInput
}
