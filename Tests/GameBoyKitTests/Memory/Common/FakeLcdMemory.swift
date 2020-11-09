// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

@testable import GameBoyKit

class FakeLcdMemory: LcdMemory {

  var control = LcdControl(value: 0)
  var status = LcdStatus(value: 0)

  var scrollY = UInt8()
  var scrollX = UInt8()

  var line = UInt8()
  var lineCompare = UInt8()

  var windowY = UInt8()
  var windowX = UInt8()

  var backgroundColorPalette = BackgroundColorPalette(value: 0)
  var spriteColorPalette0 = SpriteColorPalette(value: 0)
  var spriteColorPalette1 = SpriteColorPalette(value: 0)

  var videoRam = [UInt16: UInt8]()
  var oam = [UInt16: UInt8]()

  func readVideoRam(_ address: UInt16) -> UInt8 {
    return self.videoRam[address] ?? 0
  }

  func writeVideoRam(_ address: UInt16, value: UInt8) {
    self.videoRam[address] = value
  }

  func readOAM(_ address: UInt16) -> UInt8 {
    return self.oam[address] ?? 0
  }

  func writeOAM(_ address: UInt16, value: UInt8) {
    self.oam[address] = value
  }
}
