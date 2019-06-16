// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

public class LcdMemory: MemoryRegion {

  public static let controlAddress:     UInt16 = 0xff40
  public static let statusAddress:      UInt16 = 0xff41
  public static let scrollYAddress:     UInt16 = 0xff42
  public static let scrollXAddress:     UInt16 = 0xff43
  public static let lineAddress:        UInt16 = 0xff44
  public static let lineCompareAddress: UInt16 = 0xff45

  public static let backgroundPaletteAddress: UInt16 = 0xff47
  public static let objectPalette0Address:    UInt16 = 0xff48
  public static let objectPalette1Address:    UInt16 = 0xff49

  public static let windowYAddress: UInt16 = 0xff4a
  public static let windowXAddress: UInt16 = 0xff4b

  /// FF40 - LCDC - LCD Control
  public var control = LcdControl()

  /// FF41 - STAT - LCDC Status
  public var status = LcdStatus()

  /// FF42 - SCY - Scroll Y
  public var scrollY: UInt8 = 0

  /// FF43 - SCX - Scroll X
  public var scrollX: UInt8 = 0

  /// FF44 - LY - LCDC Y-Coordinate (R)
  public var line: UInt8 = 0

  /// FF45 - LYC - LY Compare (R/W)
  public var lineCompare: UInt8 = 0

  /// FF4A - WY - Window Y Position (R/W)
  public var windowY: UInt8 = 0

  /// FF4B - WX - Window X Position minus 7 (R/W)
  public var windowX: UInt8 = 0

  /// FF47 - BGP - BG Palette Data
  public var backgroundPalette = ColorPalette()

  /// FF48 - OBP0 - Object Palette 0 Data
  public var objectPalette0 = TransparentColorPalette()

  /// FF49 - OBP1 - Object Palette 1 Data
  public var objectPalette1 = TransparentColorPalette()

  // MARK: - MemoryRegion

  public func contains(globalAddress address: UInt16) -> Bool {
    return (LcdMemory.controlAddress <= address && address <= LcdMemory.lineCompareAddress)
        || (LcdMemory.backgroundPaletteAddress <= address && address <= LcdMemory.objectPalette1Address)
        || (LcdMemory.windowYAddress <= address && address <= LcdMemory.windowXAddress)
  }

  // swiftlint:disable:next cyclomatic_complexity
  public func read(globalAddress address: UInt16) -> UInt8 {
    assert(self.contains(globalAddress: address))
    switch address {
    case LcdMemory.controlAddress:     return self.control.byte
    case LcdMemory.statusAddress:      return self.status.byte
    case LcdMemory.scrollYAddress:     return self.scrollY
    case LcdMemory.scrollXAddress:     return self.scrollX
    case LcdMemory.lineAddress:        return self.line
    case LcdMemory.lineCompareAddress: return self.lineCompare
    case LcdMemory.backgroundPaletteAddress: return self.backgroundPalette.byte
    case LcdMemory.objectPalette0Address:    return self.objectPalette0.byte
    case LcdMemory.objectPalette1Address:    return self.objectPalette1.byte
    case LcdMemory.windowYAddress: return self.windowY
    case LcdMemory.windowXAddress: return self.windowX
    default:
      fatalError("Attempting to read invalid lcd memory")
    }
  }

  // swiftlint:disable:next cyclomatic_complexity
  public func write(globalAddress address: UInt16, value: UInt8) {
    assert(self.contains(globalAddress: address))

    switch address {
    case LcdMemory.controlAddress:     self.control.byte = value
    case LcdMemory.statusAddress:      self.status.byte = value
    case LcdMemory.scrollYAddress:     self.scrollY = value
    case LcdMemory.scrollXAddress:     self.scrollX = value
    case LcdMemory.lineAddress:        self.line = 0
    case LcdMemory.lineCompareAddress: self.lineCompare = value
    case LcdMemory.backgroundPaletteAddress: self.backgroundPalette.byte = value
    case LcdMemory.objectPalette0Address:    self.objectPalette0.byte = value
    case LcdMemory.objectPalette1Address:    self.objectPalette1.byte = value
    case LcdMemory.windowYAddress: self.windowY = value
    case LcdMemory.windowXAddress: self.windowX = value
    default:
      fatalError("Attempting to write invalid lcd memory")
    }
  }

  // MARK: - Line

  /// Go to the next line
  public func advanceLine() -> UInt8 {
    self.line += 1
    return self.line
  }

  /// Go to the 1st line
  public func resetLine() {
    self.line += 0
  }
}
