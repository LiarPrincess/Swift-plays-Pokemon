// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

private let buttonsMask:       UInt8 = 1 << 5
private let directionKeysMask: UInt8 = 1 << 4

private let aMask:      UInt8 = 1 << 0
private let bMask:      UInt8 = 1 << 1
private let startMask:  UInt8 = 1 << 3
private let selectMask: UInt8 = 1 << 2

private let upMask:    UInt8 = 1 << 2
private let downMask:  UInt8 = 1 << 3
private let leftMask:  UInt8 = 1 << 1
private let rightMask: UInt8 = 1 << 0

/// FF00 - P1/JOYP
internal class JoypadImpl: Joypad {

  private var _value: UInt8 = 0

  internal var value: UInt8 {
    get { return self._value }
    set {
      let isButtons = isSet(newValue, mask: buttonsMask)
      let isDirections = isSet(newValue, mask: directionKeysMask)

      // both true or both false? -> ignore
      if isButtons == isDirections { return }

      isButtons ? self.setButtons() : self.setDirections()
    }
  }

  private weak var input: GameboyInput?

  internal init (input: GameboyInput) {
    self.input = input
  }

  private func setButtons() {
    guard let state = self.input?.getButtonsState() else {
      return
    }

    self._value = 0
    if !state.a { self._value |= aMask }
    if !state.b { self._value |= bMask }
    if !state.start  { self._value |= startMask }
    if !state.select { self._value |= selectMask }
  }

  private func setDirections() {
    guard let state = self.input?.getDirectionKeysState() else {
      return
    }

    self._value = 0
    if !state.up    { self._value |= upMask }
    if !state.down  { self._value |= downMask }
    if !state.left  { self._value |= leftMask }
    if !state.right { self._value |= rightMask }
  }
}

private func isSet(_ value: UInt8, mask: UInt8) -> Bool {
  return (value & mask) == mask
}
