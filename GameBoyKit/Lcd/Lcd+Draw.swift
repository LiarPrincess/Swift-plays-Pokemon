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
      for bit in startPixel..<tileSizeInPixels {
        let tileColor = self.getColorValue(data1, data2, bit: bit)
        let color     = self.backgroundPalette[tileColor] // backgroundPalette

        let pixelX = x + bit
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
      let color     = self.backgroundPalette[tileColor]

      self.framebuffer[x, line] = color
    }
  }

  private func drawSprites() {
    let sprites = self.getSprites()
    let sortedSprites = self.sortFromRightToLeft(sprites)

    let line = Int(self.line)
    let spriteHeigth = Int(self.spriteHeigth)

    // code taken from 'binjgb'
    for sprite in sortedSprites {
      // skip if out of screen x
      // if (x >= SCREEN_WIDTH + OBJ_X_OFFSET) {continue;}

      let palette = sprite.palette == 0 ?
        self.spritePalette0 :
        self.spritePalette1

      var tileIndex = Int(sprite.tile)

      var tileLine = line - Int(sprite.positionY)
      if sprite.flipY {
        tileLine = spriteHeigth - tileLine - 1
      }

      if spriteHeigth == 16 {
        if tileLine < 8 { // Top tile of 8x16 sprite
          tileIndex &= 0xfe
        } else { // Bottom tile of 8x16 sprite
          tileIndex |= 0x01
          tileLine -= tileSizeInPixels
        }
      }

      let tileDataAddress = (tileIndex * tileSizeInPixels + tileLine) * bytesPerTileLine
      let data1 = self.videoRam[tileDataAddress]
      let data2 = self.videoRam[tileDataAddress + 1]

      for x in 0..<tileSizeInPixels {
        let bit = sprite.flipX ? 7 - x : x

        let rawColor = self.getColorValue(data1, data2, bit: bit)
        if rawColor == 0 { continue }

        let color = palette[rawColor]

        let pixelX = Int(sprite.positionX) + x
        if pixelX < Lcd.width {
          // TODO: Priority
          self.framebuffer[pixelX, line] = color
        }
      }
    }
  }

  private var spriteHeigth: UInt8 {
    switch self.control.spriteSize {
    case .size8x8:  return 8
    case .size8x16: return 16
    }
  }

  private func getSprites() -> [Sprite] {
    let line = self.line
    let spriteHeigth = self.spriteHeigth

    var result = [Sprite]()
    result.reserveCapacity(10)

    for sprite in self.sprites {
      let isAfterStart = line >= sprite.positionY
      let isBeforeEnd  = line < (sprite.positionY + spriteHeigth)

      guard isAfterStart && isBeforeEnd else {
        continue
      }

      result.append(sprite)
      if result.count == 10 {
        break
      }
    }

    return result
  }

  /// Sort in REVERSE order (from right to left).
  private func sortFromRightToLeft(_ sprites: [Sprite]) -> [Sprite] {
    // Sort in Swift is not stable, so we have to enumerate
    return sprites
      .enumerated()
      .sorted { lhs, rhs in
        if lhs.element.positionX == rhs.element.positionX {
          return lhs.offset > rhs.offset
        }

        return lhs.element.positionX > rhs.element.positionX
      }
      .map { $0.element }
  }

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

    // TODO: there is an trick in binjgb at line 2941
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
