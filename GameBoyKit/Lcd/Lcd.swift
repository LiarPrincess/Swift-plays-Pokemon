// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

// swiftlint:disable file_length

public class Lcd {

  /// 160 px = 20 tiles
  public static let width = LcdConstants.width

  /// 144 px = 18 tiles
  public static let height = LcdConstants.height

  /// FF40 - LCDC - LCD Control
  public internal(set) var control = LcdControl()

  /// FF41 - STAT - LCDC Status
  public internal(set) var status = LcdStatus()

  /// FF42 - SCY - Scroll Y
  public internal(set) var scrollY: UInt8 = 0

  /// FF43 - SCX - Scroll X
  public internal(set) var scrollX: UInt8 = 0

  /// FF44 - LY - LCDC Y-Coordinate
  public internal(set) var line: UInt8 {
    get { return self.isLcdEnabledInCurrentFrame ?
      UInt8(self.frameProgress / LcdConstants.cyclesPerLine) :
      0
    }
    set { self.frameProgress = 0 }
  }

  /// FF45 - LYC - LY Compare
  public internal(set) var lineCompare: UInt8 = 0

  /// FF4A - WY - Window Y Position
  public internal(set) var windowY: UInt8 = 0

  /// FF4B - WX - Window X Position minus 7
  public internal(set) var windowX: UInt8 = 0

  /// FF47 - BGP - BG Palette Data
  public internal(set) var backgroundColors = BackgroundColorPalette()

  /// FF48 - OBP0 - Object Palette 0 Data
  public internal(set) var objectColors0 = ObjectColorPalette()

  /// FF49 - OBP1 - Object Palette 1 Data
  public internal(set) var objectColors1 = ObjectColorPalette()

  /// 8000-9FFF 8KB Video RAM (VRAM) (switchable bank 0-1 in CGB Mode)
  public internal(set) lazy var videoRam = Data(memoryRange: MemoryMap.videoRam)

  /// FE00-FE9F Sprite Attribute Table (OAM)
  public internal(set) lazy var oam = Data(memoryRange: MemoryMap.oam)

  /// Data that should be put on screen
  public internal(set) var framebuffer = Framebuffer()

  /// Progress in the current frame (in cycles)
  private var frameProgress: Int = 0

  /// We can enable/disable diplay only an the end of the frame.
  /// See: http://bgb.bircd.org/pandocs.htm#lcdcontrolregister
  private var isLcdEnabledInCurrentFrame: Bool = false

  private let interrupts: Interrupts

  internal init(interrupts: Interrupts) {
    self.interrupts = interrupts
  }

  // MARK: - Tick

  internal func startFrame() {
    self.frameProgress = 0
    self.isLcdEnabledInCurrentFrame = self.control.isLcdEnabled
  }

  internal func tick(cycles: Int) {
    self.advanceFrameProgress(cycles: cycles)

    guard self.isLcdEnabledInCurrentFrame else {
      self.framebuffer.clear()
      self.status.mode = .hBlank
      return
    }

    let previousMode = self.status.mode
    self.updateMode()

    let hasFinishedTransfer = previousMode == .pixelTransfer && self.status.mode == .hBlank
    if hasFinishedTransfer {
      self.drawLine()
    }
  }

  /// Advance progress (possibly moving to new line/frame)
  /// Will also request LYC interrupt if needed.
  private func advanceFrameProgress(cycles: Int) {
    let previousLine = self.line

    self.frameProgress += cycles

    let currentLine = self.line
    if currentLine != previousLine {
      // TODO: PyBoy is wrong? we reset line progress on every new line?
      self.frameProgress = Int(currentLine) * LcdConstants.cyclesPerLine

      let hasInterrupt = currentLine == self.lineCompare

      self.status.isLineCompareInterrupt = hasInterrupt
      if hasInterrupt && self.status.isLineCompareInterruptEnabled {
        self.interrupts.lcdStat = true
      }
    }
  }

  /// Update STAT with new mode (after updating progress).
  /// Will also request any needed interrupt.
  private func updateMode() {
    if self.line >= Lcd.height {
      if self.status.mode != .vBlank {
        self.status.mode = .vBlank
        self.interrupts.vBlank  ||= self.status.isVBlankInterruptEnabled
        self.interrupts.lcdStat ||= self.status.isVBlankInterruptEnabled
      }
      return
    }

    let lineProgress = self.frameProgress % LcdConstants.cyclesPerLine

    let previousMode = self.status.mode
    var requestInterrupt = false

    if lineProgress < LcdConstants.oamSearchEnd {
      self.status.mode = .oamSearch
      requestInterrupt = self.status.isOamInterruptEnabled
    } else if lineProgress < LcdConstants.pixelTransferEnd {
      self.status.mode = .pixelTransfer
    } else {
      self.status.mode = .hBlank
      requestInterrupt = self.status.isHBlankInterruptEnabled
    }

    if requestInterrupt && self.status.mode != previousMode {
      self.interrupts.lcdStat = true
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
    let tileSizeInPixels = 8 // width = height = 8 pixels
    let bytesPerTileLine = 2

    let line = Int(self.line)
    let globalY = Int(self.scrollY) + line
    let tileRow = globalY / tileSizeInPixels
    let tileDataOffset = (globalY % tileSizeInPixels) * bytesPerTileLine

    var x = 0
    while x < Int(Lcd.width) {
      let globalX = Int(self.scrollX) + x
      let tileColumn = globalX / tileSizeInPixels

      let map = self.control.backgroundTileMap
      let tileIndexAddress = self.getTileIndexAddress(from: map, row: tileRow, column: tileColumn)
      let tileIndex        = self.readVideoRam(tileIndexAddress)

      let tileDataAddress = self.getTileDataAddress(tileIndex: tileIndex)
      let data1 = self.readVideoRam(tileDataAddress + tileDataOffset)
      let data2 = self.readVideoRam(tileDataAddress + tileDataOffset + 1)

      let startPixel = globalX % tileSizeInPixels
      for pixel in startPixel..<tileSizeInPixels {
        let tileColor = self.getColorValue(data1, data2, bit: pixel)
        let color     = self.backgroundColors[tileColor]
        self.framebuffer[x + pixel, line] = color
      }

      x += (tileSizeInPixels - startPixel)
    }
  }

  /// Address (in vram) of a tile index at given row and column.
  internal func getTileIndexAddress(from map: TileMap,
                                    row:      Int,
                                    column:   Int) -> Int {
    let tilesPerRow = 32
    let offset = row * tilesPerRow + column
    return Int(map.range.start) + offset
  }

  /// Address (in vram) of a tile data.
  internal func getTileDataAddress(tileIndex: UInt8) -> Int {
    let tileSize: Int = 16 // bits

    switch self.control.tileData {
    case .from8000to8fff:
      let start = 0x8000
      return start + Int(tileIndex) * tileSize

    case .from8800to97ff:
      let middle: Int = 0x9000
      let signedTileNumber = Int8(bitPattern: tileIndex)
      return middle + Int(signedTileNumber) * tileSize
    }
  }

  /// Read data from video ram.
  internal func readVideoRam(_ address: Int) -> UInt8 {
    let start = Int(MemoryMap.videoRam.start)
    return self.videoRam[address - start]
  }

  /// Color before applying palette.
  /// Bit offset is counted from left starting from 0.
  internal func getColorValue(_ data1:  UInt8,
                              _ data2:  UInt8,
                              bit:      Int) -> UInt8 {
    let shift = 7 - bit
    let data1Bit = (data1 >> shift) & 0x1
    let data2Bit = (data2 >> shift) & 0x1
    return (data2Bit << 1) | data1Bit
  }
}

// MARK: - Restorable

extension Lcd: Restorable {
  internal func save(to state: inout GameBoyState) {
    state.lcd.control = self.control.value
    state.lcd.status = self.status.value

    state.lcd.scrollY = self.scrollY
    state.lcd.scrollX = self.scrollX

    state.lcd.line = self.line
    state.lcd.lineCompare = self.lineCompare

    state.lcd.windowY = self.windowY
    state.lcd.windowX = self.windowX

    state.lcd.backgroundColors = self.backgroundColors.value
    state.lcd.objectColors0 = self.objectColors0.value
    state.lcd.objectColors1 = self.objectColors1.value

    state.lcd.frameProgress = self.frameProgress

    state.lcd.videoRam = self.videoRam
    state.lcd.oam = self.oam
  }

  internal func load(from state: GameBoyState) {
    self.control.value = state.lcd.control
    self.status.value = state.lcd.status

    self.scrollY = state.lcd.scrollY
    self.scrollX = state.lcd.scrollX

    self.line = state.lcd.line
    self.lineCompare = state.lcd.lineCompare

    self.windowY = state.lcd.windowY
    self.windowX = state.lcd.windowX

    self.backgroundColors.value = state.lcd.backgroundColors
    self.objectColors0.value = state.lcd.objectColors0
    self.objectColors1.value = state.lcd.objectColors1

    self.frameProgress = state.lcd.frameProgress

    self.videoRam = state.lcd.videoRam
    self.oam = state.lcd.oam
  }
}
