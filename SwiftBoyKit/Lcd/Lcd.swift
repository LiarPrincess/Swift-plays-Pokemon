// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

public class Lcd {

  /// FF40 - LCDC - LCD Control
  public internal(set) var control = LcdControl()

  /// FF41 - STAT - LCDC Status
  public internal(set) var status = LcdStatus()

  /// FF42 - SCY - Scroll Y
  public internal(set) var scrollY: UInt8 = 0

  /// FF43 - SCX - Scroll X
  public internal(set) var scrollX: UInt8 = 0

  /// FF44 - LY - LCDC Y-Coordinate (R)
  public internal(set) var line: UInt8 = 0

  /// FF45 - LYC - LY Compare (R/W)
  public internal(set) var lineCompare: UInt8 = 0

  /// FF4A - WY - Window Y Position (R/W)
  public internal(set) var windowY: UInt8 = 0

  /// FF4B - WX - Window X Position minus 7 (R/W)
  public internal(set) var windowX: UInt8 = 0

  /// FF47 - BGP - BG Palette Data
  public internal(set) var backgroundPalette = BackgroundColorPalette()

  /// FF48 - OBP0 - Object Palette 0 Data
  public internal(set) var objectPalette0 = ObjectColorPalette()

  /// FF49 - OBP1 - Object Palette 1 Data
  public internal(set) var objectPalette1 = ObjectColorPalette()

  /// 8000-9FFF 8KB Video RAM (VRAM) (switchable bank 0-1 in CGB Mode)
  public internal(set) var videoRam: [UInt8]

  /// FE00-FE9F Sprite Attribute Table (OAM)
  public internal(set) var oam: [UInt8]

  internal init() {
    self.videoRam = [UInt8](memoryRange: MemoryMap.videoRam)
    self.oam = [UInt8](memoryRange: MemoryMap.oam)
  }

  // MARK: - Line

  /// Go to the next line
//  public func advanceLine() -> UInt8 {
//    self.line += 1
//    return self.line
//  }

  /// Go to the 1st line
//  public func resetLine() {
//    self.line += 0
//  }
}
