// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

@testable import GameBoyKit

class FakeLcdMemory: LcdMemory {

  var control = LcdControl()
  var status  = LcdStatus()

  var scrollY: UInt8 = 0
  var scrollX: UInt8 = 0

  var line:        UInt8 = 0
  var lineCompare: UInt8 = 0

  var windowY: UInt8 = 0
  var windowX: UInt8 = 0

  var backgroundColors = BackgroundColorPalette()
  var objectColors0    = ObjectColorPalette()
  var objectColors1    = ObjectColorPalette()

  lazy var videoRam = Data(memoryRange: MemoryMap.videoRam)
  lazy var oam      = Data(memoryRange: MemoryMap.oam)
}
