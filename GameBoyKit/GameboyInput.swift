// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public struct ButtonsState {
  public var a: Bool
  public var b: Bool
  public var start:  Bool
  public var select: Bool

  public init() {
    self.init(a: false, b: false, start: false, select: false)
  }

  public init(a: Bool, b: Bool, start:  Bool, select: Bool) {
    self.a = a
    self.b = b
    self.start = start
    self.select = select
  }
}

public struct DirectionKeysState {
  public var up:    Bool
  public var down:  Bool
  public var left:  Bool
  public var right: Bool

  public init() {
    self.init(up: false, down: false, left: false, right: false)
  }

  public init(up: Bool, down: Bool, left: Bool, right: Bool) {
    self.up    = up
    self.down  = down
    self.left  = left
    self.right = right
  }
}

public protocol GameboyInput: AnyObject {
  func getButtonsState() -> ButtonsState
  func getDirectionKeysState() -> DirectionKeysState
}
