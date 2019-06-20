// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public class Lcd {

  /// 160 px = 20 tiles
  public static let width: UInt8 = 160

  /// 144 px = 18 tiles
  public static let height: UInt8 = 144

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

  /// Flag instead of 0xFF0F.
  public internal(set) var hasInterrupt: Bool = false

  internal init() {
    self.videoRam = [UInt8](memoryRange: MemoryMap.videoRam)
    self.oam = [UInt8](memoryRange: MemoryMap.oam)
  }

  // MARK: - Tick

  /// Go to the 1st line
  internal func resetLine() {
    self.line = 0
  }

  internal func startLine(_ line: UInt8) {
    self.line = line

    let interrupt = self.lineCompare == line

    self.status.isLineCompareInterrupt = interrupt
    if interrupt && self.status.isLineCompareInterruptEnabled {
      self.hasInterrupt = true
    }
  }

  internal func setMode(_ mode: LcdMode) {
    self.status.mode = mode
    self.hasInterrupt = self.hasInterrupt || self.isInterruptEnabled(mode)
  }

  private func isInterruptEnabled(_ mode: LcdMode) -> Bool {
    switch mode {
    case .hBlank:
      return  self.status.isHBlankInterruptEnabled
    case .vBlank:
      return self.status.isVBlankInterruptEnabled
    case .oamSearch:
      return self.status.isOamInterruptEnabled
    case .pixelTransfer:
      return false
    }
  }

  // MARK: - Draw

  internal func drawLine() {

  }

  //  private func drawBackgroundLine(into data: inout [UInt8]) {
  //    let map = self.lcdControl.backgroundTileMap
  //    let globalY = self.lcd.scrollY + self.lcd.line
  //
  //    for x in 0..<Screen.width {
  //      let globalX = self.lcd.scrollX + x
  //
  //      let tileIndexAddress = self.getTileIndexAddress(from: map, globalX: globalX, globalY: globalY)
  //      let tileIndex = self.memory.read(tileIndexAddress)
  //
  //      let bytesPerLine: UInt8 = 2
  //      let lineInsideTile = UInt16((globalY % 8) * bytesPerLine)
  //
  //      let tileDataAddress = self.getTileDataAddress(tileIndex: tileIndex)
  //      let data1 = self.memory.read(tileDataAddress + lineInsideTile)
  //      let data2 = self.memory.read(tileDataAddress + lineInsideTile + 1)
  //
  //      let colorOffset = globalX % 8
  //      let color = self.getRawColorValue(data1, data2, bitOffset: colorOffset)
  //    }
  //  }

  /// Tile index address (means: draw tile from this index)
  internal func getTileIndexAddress(from map: TileMap, globalX: UInt8, globalY: UInt8) -> UInt16 {
    let tileRow = globalY / 8
    let tileColumn = globalX / 8
    return self.getTileIndexAddress(from: map, tileRow: tileRow, tileColumn: tileColumn)
  }

  /// Tile index address (means: draw tile from this index)
  internal func getTileIndexAddress(from map: TileMap, tileRow: UInt8, tileColumn: UInt8) -> UInt16 {
    let tilesPerRow: UInt16 = 32
    let offset = UInt16(tileRow) * tilesPerRow + UInt16(tileColumn)

    switch map {
    case .from9800to9bff: return 0x9800 + offset
    case .from9c00to9fff: return 0x9c00 + offset
    }
  }

  /// Start of the tile in memory
  internal func getTileDataAddress(tileIndex: UInt8) -> UInt16 {
    let tileSize: UInt16 = 16

    switch self.control.tileData {
    case .from8000to8fff:
      let start: UInt16 = 0x8000
      return start + UInt16(tileIndex) * tileSize

    case .from8800to97ff:
      let middle: Int = 0x9000
      let signedTileNumber = Int8(bitPattern: tileIndex)
      return UInt16(middle + Int(signedTileNumber) * Int(tileSize))
    }
  }

  /// Color before applying palette.
  /// Bit offset is counted from left starting from 0.
  internal func getRawColorValue(_ data1: UInt8, _ data2: UInt8, bitOffset: UInt8) -> UInt8 {
    let shift = 7 - bitOffset
    let data1Bit = (data1 >> shift) & 0x1
    let data2Bit = (data2 >> shift) & 0x1

    var color: UInt8 = 0
    color |= data2Bit
    color <<= 1
    color |= data1Bit
    return color
  }
}
