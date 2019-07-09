// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

/// 8 pixels
private let tileHeightInPixels = 8

/// 8 pixels
private let tileWidthInPixels = 8

/// 1 tile line = 2 bytes
private let bytesPerTileLine = 2

/// Number of tiles in a single row (32).
private let tilesPerRow = 32

extension LcdImpl {

  internal func drawLine() {
    if self.isBackgroundVisible {
      self.drawBackgroundLine()
    }

    if self.isWindowEnabled {
      self.drawWindow()
    }

    if self.isSpriteEnabled {
      self.drawSprites()
    }
  }

  private func drawBackgroundLine() {
    let line     = Int(self.line)
    let globalY  = (Int(self.scrollY) + line) % LcdConstants.backgroundMapHeight
    let tileRow  = globalY / tileHeightInPixels
    let tileLine = globalY % tileHeightInPixels

    let tileMap = self.getTileMap(for: self.backgroundTileMap)
    let framebufferSlice = self.getBackgroundFramebuffer(line: line)

    var x = 0
    while x < framebufferSlice.count {
      let globalX = Int(self.scrollX) + x
      let tileColumn = globalX / tileWidthInPixels
      let tileIndexRaw = tileMap[tileRow * tilesPerRow + tileColumn]

      var tileIndex = Int(tileIndexRaw)
      if self.tileData == .from8800to97ff {
        tileIndex = 256 + Int(Int8(bitPattern: tileIndexRaw))
      }

      let tileAddress = (tileIndex * tileHeightInPixels + tileLine) * bytesPerTileLine
      let data1 = self.videoRam[tileAddress]
      let data2 = self.videoRam[tileAddress + 1]

      let startPixel = globalX % tileWidthInPixels
      for pixel in startPixel..<tileWidthInPixels {
        let pixelX = x + pixel
        guard pixelX < framebufferSlice.count else { break }

        let tileColor = self.getColorValue(data1, data2, bit: pixel)
        let color     = self._backgroundPalette[tileColor]
        framebufferSlice[pixelX] = color
      }

      x += (tileWidthInPixels - startPixel)
    }
  }

  /// Part of the framebuffer that should be filled in the current draw operation.
  private func getBackgroundFramebuffer(line: Int) -> UnsafeMutableBufferPointer<UInt8> {
    guard let basePtr = UnsafeMutablePointer(self.framebuffer.data.baseAddress) else {
      fatalError("Unable to obtain framebuffer address.")
    }

    let start = basePtr.advanced(by: line * LcdConstants.width)

    let usingWindow = self.isWindowEnabled && self.line >= self.windowY
    let count = min(LcdConstants.width, usingWindow ? Int(self.windowX) - 7 : .max)

    return UnsafeMutableBufferPointer(start: start, count: count)
  }

  // swiftlint:disable:next function_body_length
  private func drawWindow() {
    let line = Int(self.line)
    let windowStartY = Int(self.windowY)

    guard line >= windowStartY else {
      return
    }

    let windowY = line - windowStartY
    let tileRow = windowY / tileHeightInPixels
    let tileLine = windowY % tileHeightInPixels

    let tileMap = self.getTileMap(for: self.windowTileMap)
    let framebufferSlice = self.getWindowFramebuffer(line: line)

    var windowX = 0
    while windowX < framebufferSlice.count {
      let tileColumn = windowX / tileWidthInPixels
      let tileIndexRaw = tileMap[tileRow * tilesPerRow + tileColumn]

      var tileIndex = Int(tileIndexRaw)
      if self.tileData == .from8800to97ff {
        tileIndex = 256 + Int(Int8(bitPattern: tileIndexRaw))
      }

      let tileAddress = (tileIndex * tileHeightInPixels + tileLine) * bytesPerTileLine
      let data1 = self.videoRam[tileAddress]
      let data2 = self.videoRam[tileAddress + 1]

      let startPixel = windowX % tileWidthInPixels
      for pixel in startPixel..<tileWidthInPixels {
        let pixelX = windowX + pixel
        guard pixelX < framebufferSlice.count else { break }

        let tileColor = self.getColorValue(data1, data2, bit: pixel)
        let color     = self._backgroundPalette[tileColor]
        framebufferSlice[pixelX] = color
      }

      windowX += (tileWidthInPixels - startPixel)
    }
  }

  /// Part of the framebuffer that should be filled in the current draw operation.
  private func getWindowFramebuffer(line: Int) -> UnsafeMutableBufferPointer<UInt8> {
    guard let basePtr = UnsafeMutablePointer(self.framebuffer.data.baseAddress) else {
      fatalError("Unable to obtain framebuffer address.")
    }

    let windowX = Int(self.windowX) - 7
    let start = basePtr.advanced(by: line * LcdConstants.width + windowX)

    let count = max(LcdConstants.width - windowX, 0) // we may set window to 250 etc.
    return UnsafeMutableBufferPointer(start: start, count: count)
  }

  private func drawSprites() {
    let line = Int(self.line)
    let spriteHeigth = Int(self.spriteHeigth)

    let sprites = self.getSprites(line: line)
    let sortedSprites = self.sortFromRightToLeft(sprites)

    let framebufferSlice = self.getSpriteFramebuffer(line: line)

    for x in 0..<sprites.count {
      framebufferSlice[x] = 3
    }

    // code taken from 'binjgb'
//    for sprite in sortedSprites {
//      var tileIndex = Int(sprite.tile)
//
//      var tileLine = line - Int(sprite.positionY)
//      if sprite.flipY {
//        tileLine = spriteHeigth - tileLine - 1
//      }
//
//      if spriteHeigth == 16 {
//        if tileLine < 8 { // Top tile of 8x16 sprite
//          tileIndex &= 0xfe
//        } else { // Bottom tile of 8x16 sprite
//          tileIndex |= 0x01
//          tileLine -= tileHeightInPixels
//        }
//      }
//
//      let tileDataAddress = (tileIndex * tileHeightInPixels + tileLine) * bytesPerTileLine
//      let data1 = self.videoRam[tileDataAddress]
//      let data2 = self.videoRam[tileDataAddress + 1]
//
//      let palette = sprite.palette == 0 ? self.spritePalette0 : self.spritePalette1
//      for x in 0..<tileWidthInPixels {
//        let bit = sprite.flipX ? 7 - x : x
//
//        let rawColor = self.getColorValue(data1, data2, bit: bit)
//        if rawColor == 0 { continue }
//
//        let color = palette[rawColor]
//
//        let pixelX = Int(sprite.positionX) + x
//        if pixelX < Lcd.width {
//          // TODO: Priority
//          self.framebuffer[pixelX, line] = color // performance trick
//        }
//      }
//    }
  }

  /// Part of the framebuffer that should be filled in the current draw operation.
  private func getSpriteFramebuffer(line: Int) -> UnsafeMutableBufferPointer<UInt8> {
    guard let basePtr = UnsafeMutablePointer(self.framebuffer.data.baseAddress) else {
      fatalError("Unable to obtain framebuffer address.")
    }

    let start = basePtr.advanced(by: line * LcdConstants.width)
    return UnsafeMutableBufferPointer(start: start, count: LcdConstants.width)
  }

  private var spriteHeigth: UInt8 {
    switch self.spriteSize {
    case .size8x8:  return 8
    case .size8x16: return 16
    }
  }

  internal func getSprites(line: Int) -> [Sprite] {
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

  internal func getTileMap(for map: TileMap) -> UnsafeBufferPointer<UInt8> {
    guard let basePtr = UnsafePointer(self.videoRam.baseAddress) else {
      fatalError("Unable to obtain video ram address.")
    }

    let mapStart: UnsafePointer<UInt8> = {
      let videoRamStart = Int(MemoryMap.videoRam.start)
      switch map {
      case .from9800to9bff: return basePtr.advanced(by: 0x9800 - videoRamStart)
      case .from9c00to9fff: return basePtr.advanced(by: 0x9c00 - videoRamStart)
      }
    }()

    let count = LcdConstants.tileMapCount
    return UnsafeBufferPointer(start: mapStart, count: count)
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
