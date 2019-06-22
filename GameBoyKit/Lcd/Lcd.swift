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
  public internal(set) var backgroundColors = BackgroundColorPalette()

  /// FF48 - OBP0 - Object Palette 0 Data
  public internal(set) var objectColors0 = ObjectColorPalette()

  /// FF49 - OBP1 - Object Palette 1 Data
  public internal(set) var objectColors1 = ObjectColorPalette()

  /// 8000-9FFF 8KB Video RAM (VRAM) (switchable bank 0-1 in CGB Mode)
  public internal(set) var videoRam: [UInt8]

  /// FE00-FE9F Sprite Attribute Table (OAM)
  public internal(set) var oam: [UInt8]

  /// Flag instead of 0xFF0F
  public internal(set) var hasStatusInterrupt: Bool = false

  /// Flag instead of 0xFF0F
  public internal(set) var hasVBlankInterrupt: Bool = false

  /// Data thst should be put on screen
  public internal(set) var framebuffer = Framebuffer()

  internal init() {
    self.videoRam = [UInt8](memoryRange: MemoryMap.videoRam)
    self.oam = [UInt8](memoryRange: MemoryMap.oam)
  }

  // MARK: - Tick

  internal func clear() {
    self.line = 0
    // TODO: self.window.blank_screen()
  }

  internal func startLine(_ line: UInt8) {
    self.line = line

    let hasInterrupt = self.lineCompare == line

    self.status.isLineCompareInterrupt = hasInterrupt
    if hasInterrupt && self.status.isLineCompareInterruptEnabled {
      self.hasStatusInterrupt = true
    }
  }

  internal func setMode(_ mode: LcdMode) {
    self.status.mode = mode
    switch mode {
    case .hBlank:
      self.hasStatusInterrupt ||= self.status.isHBlankInterruptEnabled
    case .vBlank:
      self.hasVBlankInterrupt ||= self.status.isVBlankInterruptEnabled
      self.hasStatusInterrupt ||= self.status.isVBlankInterruptEnabled
    case .oamSearch:
      self.hasStatusInterrupt ||= self.status.isOamInterruptEnabled
    case .pixelTransfer:
      break
    }
  }

  // MARK: - Draw

  internal func drawLine() {
    guard self.control.spriteSize == .size8x8 else {
      fatalError("Tile size 8x16 is not yet supported.")
    }

    if self.control.isBackgroundVisible {
      self.drawBackgroundLine()
    }

//    if self.lcdControl.isWindowEnabled {
//      self.drawWindow()
//    }
//
//    if self.lcdControl.isSpriteEnabled {
//      self.drawSprites()
//    }
  }

  private func drawBackgroundLine() {
    let map = self.control.backgroundTileMap
    let globalY = self.scrollY + self.line

    for x in 0..<Lcd.width {
      let globalX = self.scrollX + x

      let tileWidth: UInt8 = 8
      let tileRow    = globalY / tileWidth
      let tileColumn = globalX / tileWidth

      let tileIndexAddress = self.getTileIndexAddress(from: map, row: tileRow, column: tileColumn)
      let tileIndex        = self.readVideoRam(tileIndexAddress)

      let bytesPerLine: UInt16 = 2
      let lineInsideTile = UInt16(globalY % tileWidth) * bytesPerLine

      let tileDataAddress = self.getTileDataAddress(tileIndex: tileIndex)
      let data1 = self.readVideoRam(tileDataAddress + lineInsideTile)
      let data2 = self.readVideoRam(tileDataAddress + lineInsideTile + 1)

      let colorOffset = globalX % 8
      let tileColor   = self.getRawColorValue(data1, data2, bitOffset: colorOffset)
      let color       = self.backgroundColors[tileColor]

      self.framebuffer[x, self.line] = color
    }
  }

  /// Address (in vram) of a tile index at given row and column.
  internal func getTileIndexAddress(from map: TileMap,
                                    row:    UInt8,
                                    column: UInt8) -> UInt16 {
    let tilesPerRow: UInt16 = 32
    let offset = UInt16(row) * tilesPerRow + UInt16(column)
    return map.range.start + offset
  }

  /// Address (in vram) of a tile data.
  internal func getTileDataAddress(tileIndex: UInt8) -> UInt16 {
    let tileSize: UInt16 = 16 // bits

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

  /// Read data from video ram.
  internal func readVideoRam(_ address: UInt16) -> UInt8 {
    return self.videoRam[address -  MemoryMap.videoRam.start]
  }

  /// Color before applying palette.
  /// Bit offset is counted from left starting from 0.
  internal func getRawColorValue(_ data1: UInt8,
                                 _ data2: UInt8,
                                 bitOffset: UInt8) -> UInt8 {
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
