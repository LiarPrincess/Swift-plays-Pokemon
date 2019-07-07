// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

/// width = height = 8 pixels
private let tileSizeInPixels = 8

/// 1 tile line = 2 bytes
private let bytesPerTileLine = 2

/// Number of tiles in a single row.
private let tilesPerRow = 32

/// Address of the 1st byte of video ram in memory.
private let videoRamStart = Int(MemoryMap.videoRam.start)

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

    if self.control.isSpriteEnabled {
      self.drawSprites()
    }
  }

  private func drawBackgroundLine() {
    let line    = Int(self.line)
    let globalY = (Int(self.scrollY) + line) % LcdConstants.backgroundMapHeight
    let tileRow = globalY / tileSizeInPixels
    let tileDataOffset = (globalY % tileSizeInPixels) * bytesPerTileLine

    let tileMap = self.getTileMap(for: self.control.backgroundTileMap)

    let usingWindow = self.control.isWindowEnabled && self.line >= self.windowY
    let maxX = min(Lcd.width, usingWindow ? Int(self.windowX) - 7 : .max)

    var x = 0
    while x < maxX {
      let globalX = Int(self.scrollX) + x
      let tileColumn = globalX / tileSizeInPixels
      let tileIndex  = tileMap[tileRow * tilesPerRow + tileColumn]

      let tileDataAddress = self.getTileDataAddress(tileIndex: tileIndex)
      let data1 = self.videoRam[tileDataAddress + tileDataOffset]
      let data2 = self.videoRam[tileDataAddress + tileDataOffset + 1]

      let startPixel = globalX % tileSizeInPixels
      for pixel in startPixel..<tileSizeInPixels {
        let tileColor = self.getColorValue(data1, data2, bit: pixel)
        let color     = self.backgroundColors[tileColor]

        let pixelX = x + pixel
        if pixelX < maxX {
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

    let tileMap = self.getTileMap(for: self.control.windowTileMap)

    // TODO: Performance
    for x in windowStartX..<Lcd.width {
      let windowX = x - windowStartX
      let tileColumn = windowX / tileSizeInPixels
      let tileIndex  = tileMap[tileRow * tilesPerRow + tileColumn]

      let tileDataAddress = self.getTileDataAddress(tileIndex: tileIndex)
      let data1 = self.videoRam[tileDataAddress + tileDataOffset]
      let data2 = self.videoRam[tileDataAddress + tileDataOffset + 1]

      let pixel = windowX % tileSizeInPixels
      let tileColor = self.getColorValue(data1, data2, bit: pixel)
      let color     = self.backgroundColors[tileColor]

      self.framebuffer[x, line] = color
    }
  }

  private func drawSprites() { }

  // MARK: - Helpers

  private func getTileMap(for map: TileMap) -> UnsafeBufferPointer<UInt8> {
    guard let basePtr = UnsafePointer(self.videoRam.baseAddress) else {
      fatalError("Unable to obtain video ram address.")
    }

    let mapStart: UnsafePointer<UInt8> = {
      switch map {
      case .from9800to9bff: return basePtr.advanced(by: 0x9800 - videoRamStart)
      case .from9c00to9fff: return basePtr.advanced(by: 0x9c00 - videoRamStart)
      }
    }()

    let count = LcdConstants.tileMapCount
    return UnsafeBufferPointer(start: mapStart, count: count)
  }

  /// Address (in vram) of a tile data.
  /// Can be used as index in self.videoRam.
  internal func getTileDataAddress(tileIndex: UInt8) -> Int {
    let tileSize: Int = 16 // bits

    switch self.control.tileData {
    case .from8000to8fff:
      let start = 0x8000 - videoRamStart
      return start + Int(tileIndex) * tileSize

    case .from8800to97ff:
      let middle = 0x9000 - videoRamStart
      let signedTileNumber = Int8(bitPattern: tileIndex)
      return middle + Int(signedTileNumber) * tileSize
    }
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
