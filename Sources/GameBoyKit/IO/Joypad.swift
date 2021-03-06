// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftformat:disable consecutiveSpaces

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
public final class Joypad: JoypadMemory {

  private var _value: UInt8 = 0

  /// FF00 - P1/JOYP
  public internal(set) var value: UInt8 {
    get { return self._value }
    set {
      // 0 = Select
      let isButtons = !isSet(newValue, mask: buttonsMask)
      let isDirections = !isSet(newValue, mask: directionKeysMask)

      // both true or both false? -> ignore
      if isButtons == isDirections { return }

      guard let input = self.provider?.getGameBoyInput() else {
        fatalError("GameBoy input provider was deallocated before finishing running")
      }

      isButtons ? self.setButtons(from: input) : self.setDirections(from: input)
    }
  }

  private weak var provider: GameBoyInputProvider?

  internal init(provider: GameBoyInputProvider) {
    self.provider = provider
  }

  private func setButtons(from input: GameBoyInput) {
    self._value = 0
    if !input.a { self._value |= aMask }
    if !input.b { self._value |= bMask }
    if !input.start { self._value |= startMask }
    if !input.select { self._value |= selectMask }
  }

  private func setDirections(from input: GameBoyInput) {
    self._value = 0
    if !input.up { self._value |= upMask }
    if !input.down { self._value |= downMask }
    if !input.left { self._value |= leftMask }
    if !input.right { self._value |= rightMask }
  }
}

private func isSet(_ value: UInt8, mask: UInt8) -> Bool {
  return (value & mask) == mask
}
