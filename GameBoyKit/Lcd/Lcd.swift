// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public class Lcd {

  /// 160 px = 20 tiles
  public static let width: UInt8 = 160

  /// 144 px = 18 tiles
  public static let height: UInt8 = 144

  /// Total number of lines (lcd + vBlank)
  internal static let totalLineCount: UInt8 = Lcd.height + LcdMode.vBlankLineCount

  /// Number of cycles needed to draw the whole line
  public static let cyclesPerLine: UInt16 = 456

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
  public internal(set) lazy var videoRam: Data = {
    return Data(memoryRange: MemoryMap.videoRam)
  }()

  /// FE00-FE9F Sprite Attribute Table (OAM)
  public internal(set) lazy var oam: Data = {
    return Data(memoryRange: MemoryMap.oam)
  }()

  /// Flag instead of 0xFF0F
  public internal(set) var hasStatusInterrupt: Bool = false

  /// Flag instead of 0xFF0F
  public internal(set) var hasVBlankInterrupt: Bool = false

  /// Data thst should be put on screen
  public internal(set) var framebuffer = Framebuffer()

  private var lineProgress: UInt16 = 0

  // MARK: - Tick

  internal func tick(cycles: UInt8) {
    guard self.control.isLcdEnabled else {
      // basically go to the beginning
      self.line = 0
      self.lineProgress = 0
      // TODO: clear framebuffer (flag in framebuffer to avoid clear on every cycle)
      self.status.mode = .vBlank
      return
    }

    let previousMode = self.status.mode
    self.advanceProgress(cycles: cycles)
    self.updateMode()

    let hasFinishedTransfer = previousMode == .pixelTransfer && self.status.mode == .hBlank
    if hasFinishedTransfer {
      self.drawLine()
    }
  }

  /// Advance progress (possibly moving to new line)
  private func advanceProgress(cycles: UInt8) {
    self.lineProgress += UInt16(cycles)

    let isAdvancingLine = self.lineProgress > Lcd.cyclesPerLine
    if isAdvancingLine {
      self.lineProgress -= Lcd.cyclesPerLine

      self.line += 1
      if self.line > Lcd.totalLineCount {
        self.line = 0
      }

      self.requestLineCompareInterruptIfEnabled()
    }
  }

  private func requestLineCompareInterruptIfEnabled() {
    let hasInterrupt = self.lineCompare == line

    self.status.isLineCompareInterrupt = hasInterrupt
    if hasInterrupt && self.status.isLineCompareInterruptEnabled {
      self.hasStatusInterrupt = true
    }
  }

  /// Update STAT with new mode (after updating progress),
  /// will also request any needed interrupt
  private func updateMode() {
    if self.line >= Lcd.height {
      if self.status.mode != .vBlank {
        self.status.mode = .vBlank
        self.hasVBlankInterrupt ||= self.status.isVBlankInterruptEnabled
        self.hasStatusInterrupt ||= self.status.isVBlankInterruptEnabled
      }
      return
    }

    let previousMode = self.status.mode
    var requestInterrupt = false

    switch self.lineProgress {
    case LcdMode.oamSearchRange:
      self.status.mode = .oamSearch
      requestInterrupt = self.status.isOamInterruptEnabled

    case LcdMode.pixelTransferRange:
      self.status.mode = .pixelTransfer

    case LcdMode.hBlankRange:
      self.status.mode = .hBlank
      requestInterrupt = self.status.isHBlankInterruptEnabled

    default:
      break
    }

    if requestInterrupt && self.status.mode != previousMode {
      self.hasStatusInterrupt = true
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

  // TODO: process this whole tiles thing when loading carthrige
  private func drawBackgroundLine() {
    let map = self.control.backgroundTileMap

    let tilePixelWidth: UInt8 = 8
    let bytesPerTileLine: UInt16 = 2

    let globalY = self.scrollY + self.line
    let tileRow = globalY / tilePixelWidth
    let tileDataOffset = UInt16(globalY % tilePixelWidth) * bytesPerTileLine

    var x: UInt8 = 0
    while x < Lcd.width {
      let globalX = self.scrollX + x
      let tileColumn = globalX / tilePixelWidth

      let tileIndexAddress = self.getTileIndexAddress(from: map, row: tileRow, column: tileColumn)
      let tileIndex        = self.readVideoRam(tileIndexAddress)

      let tileDataAddress = self.getTileDataAddress(tileIndex: tileIndex)
      let data1 = self.readVideoRam(tileDataAddress + tileDataOffset)
      let data2 = self.readVideoRam(tileDataAddress + tileDataOffset + 1)

      var xOffset = globalX % tilePixelWidth
      while xOffset < 8 {
        let colorBit  = (globalX + xOffset) % 8
        let tileColor = self.getColorValue(data1, data2, bitOffset: colorBit)
        let color     = self.backgroundColors[tileColor]
        self.framebuffer[x + xOffset, self.line] = color
        xOffset += 1
      }

      x += xOffset
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
  internal func getColorValue(_ data1: UInt8,
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
