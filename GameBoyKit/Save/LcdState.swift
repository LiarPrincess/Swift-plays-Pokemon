// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

internal struct LcdState {

  internal var control: UInt8 = 0
  internal var status:  UInt8 = 0

  internal var scrollY: UInt8 = 0
  internal var scrollX: UInt8 = 0

  internal var line: UInt8 = 0
  internal var lineCompare: UInt8 = 0

  internal var windowY: UInt8 = 0
  internal var windowX: UInt8 = 0

  internal var backgroundColors: UInt8 = 0
  internal var objectColors0: UInt8 = 0
  internal var objectColors1: UInt8 = 0

  internal var lineProgress: UInt16 = 0

  internal var videoRam = Data(memoryRange: MemoryMap.videoRam)
  internal var oam      = Data(memoryRange: MemoryMap.oam)
}
