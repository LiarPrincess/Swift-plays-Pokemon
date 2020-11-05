// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public protocol Lcd: AnyObject {

  /// FF40 - LCDC - LCD Control
  var controlRaw: UInt8 { get }

  /// FF41 - STAT - LCDC Status
  var statusRaw: UInt8 { get }

  /// FF42 - SCY - Scroll Y
  var scrollY: UInt8 { get }

  /// FF43 - SCX - Scroll X
  var scrollX: UInt8 { get }

  /// FF44 - LY - LCDC Y-Coordinate
  var line: UInt8 { get }

  /// FF45 - LYC - LY Compare
  var lineCompare: UInt8 { get }

  /// FF4A - WY - Window Y Position
  var windowY: UInt8 { get }

  /// FF4B - WX - Window X Position (minus 7)
  var windowX: UInt8 { get }

  /// FF47 - BGP - BG Palette Data
  var backgroundPalette: UInt8 { get }

  /// FF48 - OBP0 - Object Palette 0 Data
  var spritePalette0: UInt8 { get }

  /// FF49 - OBP1 - Object Palette 1 Data
  var spritePalette1: UInt8 { get }

  /// Data that should be put on screen:
  /// - 0 - White
  /// - 1 - Light gray
  /// - 2 - Dark gray
  /// - 3 - Black
  var framebuffer: UnsafeMutableBufferPointer<UInt8> { get }

  /// 8000-9FFF 8KB Video RAM (VRAM)
  func readVideoRam(_ address: UInt16) -> UInt8

  /// FE00-FE9F Sprite Attribute Table (OAM)
  func readOAM(_ address: UInt16) -> UInt8
}

internal protocol WritableLcd: Lcd {

  /// FF40 - LCDC - LCD Control
  var controlRaw: UInt8 { get set }

  /// FF41 - STAT - LCDC Status
  var statusRaw: UInt8 { get set }

  /// FF42 - SCY - Scroll Y
  var scrollY: UInt8 { get set }

  /// FF43 - SCX - Scroll X
  var scrollX: UInt8 { get set }

  /// FF44 - LY - LCDC Y-Coordinate
  var line: UInt8 { get set }

  /// FF45 - LYC - LY Compare
  var lineCompare: UInt8 { get set }

  /// FF4A - WY - Window Y Position
  var windowY: UInt8 { get set }

  /// FF4B - WX - Window X Position (minus 7)
  var windowX: UInt8 { get set }

  /// FF47 - BGP - BG Palette Data
  var backgroundPalette: UInt8 { get set }

  /// FF48 - OBP0 - Object Palette 0 Data
  var spritePalette0: UInt8 { get set }

  /// FF49 - OBP1 - Object Palette 1 Data
  var spritePalette1: UInt8 { get set }

  /// 8000-9FFF 8KB Video RAM (VRAM)
  func writeVideoRam(_ address: UInt16, value: UInt8)

  /// FE00-FE9F Sprite Attribute Table (OAM)
  func writeOAM(_ address: UInt16, value: UInt8)

  func tick(cycles: Int)
}

extension WritableLcd {

  // MARK: - Control properties

  internal var control: LcdControl {
    get { return LcdControl(value: self.controlRaw) }
    set { self.controlRaw = newValue.value }
  }

  internal var status: LcdStatus {
    get { return LcdStatus(value: self.statusRaw) }
    set { self.statusRaw = newValue.value }
  }
}
