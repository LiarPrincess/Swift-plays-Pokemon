// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

@testable import GameBoyKit

class FakeLcd: Lcd {

  var control: UInt8 = 0
  var status:  UInt8 = 0

  var scrollY: UInt8 = 0
  var scrollX: UInt8 = 0

  var line:        UInt8 = 0
  var lineCompare: UInt8 = 0

  var windowY: UInt8 = 0
  var windowX: UInt8 = 0

  var backgroundPalette: UInt8 = 0
  var spritePalette0:    UInt8 = 0
  var spritePalette1:    UInt8 = 0

  var videoRam = [UInt16:UInt8]()
  var oam      = [UInt16:UInt8]()

  var framebuffer = Framebuffer()

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

  func startFrame() { }
  func tick(cycles: Int) { }
}
