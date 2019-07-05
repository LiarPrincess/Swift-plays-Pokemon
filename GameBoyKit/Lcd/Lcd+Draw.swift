// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

/// width = height = 8 pixels
private let tileSizeInPixels = 8
private let bytesPerTileLine = 2

extension Lcd {

  internal func drawLine() {
    guard self.control.spriteSize == .size8x8 else {
      fatalError("Tile size 8x16 is not yet supported.")
    }

    if self.control.isBackgroundVisible {
      self.drawBackgroundLine()
    } else {
      self.drawWhiteBackgroundLine()
    }

    if self.control.isWindowEnabled {
      self.drawWindow()
    }

//    if self.control.isSpriteEnabled {
//      self.drawSprites()
//    }
  }

  private func drawBackgroundLine() {
    let line    = Int(self.line)
    let globalY = (Int(self.scrollY) + line) % LcdConstants.backgroundMapHeight
    let tileRow = globalY / tileSizeInPixels
    let tileDataOffset = (globalY % tileSizeInPixels) * bytesPerTileLine

    let map = self.control.backgroundTileMap

    let usingWindow = self.control.isWindowEnabled && self.line >= self.windowY
    let maxX = min(Lcd.width, usingWindow ? Int(self.windowX) - 7 : .max)

    var x = 0
    while x < maxX {
      let globalX = Int(self.scrollX) + x
      let tileColumn = globalX / tileSizeInPixels

      let tileIndexAddress = self.getTileIndexAddress(from: map, row: tileRow, column: tileColumn)
      let tileIndex        = self.readVideoRam(tileIndexAddress)

      let tileDataAddress = self.getTileDataAddress(tileIndex: tileIndex)
      let data1 = self.readVideoRam(tileDataAddress + tileDataOffset)
      let data2 = self.readVideoRam(tileDataAddress + tileDataOffset + 1)

      let startPixel = globalX % tileSizeInPixels
      for pixel in startPixel..<tileSizeInPixels {
        let tileColor = self.getColorValue(data1, data2, bit: pixel)
        let color     = self.backgroundColors[tileColor]

        // we may draw a bit of window, but thats ok,
        // since we will over-draw it later
        let pixelX = x + pixel
        if pixelX < Lcd.width {
          self.framebuffer[pixelX, line] = color
        }
      }

      x += (tileSizeInPixels - startPixel)
    }
  }

  private func drawWhiteBackgroundLine() {
    let line = Int(self.line)
    for x in 0..<Lcd.width {
      self.framebuffer[x, line] = 0x00
    }
  }

  private func drawWindow() {
    let line = Int(self.line)
    let windowStartY = Int(self.windowY)
    let windowStartX = Int(self.windowX) - 7

    guard line >= windowStartY else {
      return
    }

    let windowLine = line - windowStartY
    let tileRow = windowLine / tileSizeInPixels
    let tileDataOffset = (windowLine % tileSizeInPixels) * bytesPerTileLine

    let map = self.control.windowTileMap

    // TODO: Performance
    for x in windowStartX..<Lcd.width {
      let windowX = x - windowStartX
      let tileColumn = windowX / tileSizeInPixels

      let tileIndexAddress = self.getTileIndexAddress(from: map, row: tileRow, column: tileColumn)
      let tileIndex        = self.readVideoRam(tileIndexAddress)

      let tileDataAddress = self.getTileDataAddress(tileIndex: tileIndex)
      let data1 = self.readVideoRam(tileDataAddress + tileDataOffset)
      let data2 = self.readVideoRam(tileDataAddress + tileDataOffset + 1)

      let pixel = windowX % tileSizeInPixels
      let tileColor = self.getColorValue(data1, data2, bit: pixel)
      let color     = self.backgroundColors[tileColor]

      self.framebuffer[x, line] = color
    }
  }

  // MARK: - Helpers

  /// Address (in vram) of a tile index at given row and column.
  internal func getTileIndexAddress(from map: TileMap,
                                    row:      Int,
                                    column:   Int) -> Int {
    let start: Int = {
      switch map {
      case .from9800to9bff: return 0x9800
      case .from9c00to9fff: return 0x9c00
      }
    }()

    let tilesPerRow = 32
    let offset = row * tilesPerRow + column

    return start + offset
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
