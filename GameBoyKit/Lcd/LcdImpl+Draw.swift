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

    var progress = 0
    while progress < framebufferSlice.count {
      let globalX = (Int(self.scrollX) + progress) % LcdConstants.backgroundMapWidth
      let tileColumn = globalX / tileWidthInPixels
      let tileIndexRaw = tileMap[tileRow * tilesPerRow + tileColumn]

      var tileIndex = Int(tileIndexRaw)
      if self.tileData == .from8800to97ff {
        tileIndex = 256 + Int(Int8(bitPattern: tileIndexRaw))
      }

      let tileAddress = (tileIndex * tileHeightInPixels + tileLine) * bytesPerTileLine
      let data1 = self.videoRam[tileAddress]
      let data2 = self.videoRam[tileAddress + 1]

      let startBit = globalX % tileWidthInPixels

      var bit = startBit
      while bit < tileWidthInPixels && progress + bit < framebufferSlice.count {
        let tileColor = self.getColorValue(data1, data2, bit: bit)
        let color     = self._backgroundPalette[tileColor]
        framebufferSlice[progress + bit] = color
        bit += 1
      }

      progress += (tileWidthInPixels - startBit)
    }
  }

  /// Part of the framebuffer that should be filled in the current draw operation.
  private func getBackgroundFramebuffer(line: Int) -> UnsafeMutableBufferPointer<UInt8> {
    guard let basePtr = UnsafeMutablePointer(self.framebuffer.baseAddress) else {
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
    guard let basePtr = UnsafeMutablePointer(self.framebuffer.baseAddress) else {
      fatalError("Unable to obtain framebuffer address.")
    }

    let windowX = Int(self.windowX) - 7
    let start = basePtr.advanced(by: line * LcdConstants.width + windowX)

    let count = max(LcdConstants.width - windowX, 0) // we may set window to 250 etc.
    return UnsafeMutableBufferPointer(start: start, count: count)
  }

  // swiftlint:disable:next function_body_length
  private func drawSprites() {
    let line = Int(self.line)
    let spriteHeight = self.spriteHeight

    let sprites = self.getSprites(line: line)
    let framebufferSlice = self.getSpriteFramebuffer(line: line)

    // code taken from 'binjgb'
    for sprite in sprites {
      var tileIndex = Int(sprite.tile)

      var tileLine = line - sprite.realY
      if sprite.flipY {
        tileLine = spriteHeight - tileLine - 1
      }

      if spriteHeight == 16 {
        if tileLine < 8 { // Top tile of 8x16 sprite
          tileIndex &= 0xfe
        } else { // Bottom tile of 8x16 sprite
          tileIndex |= 0x01
          tileLine -= tileHeightInPixels
        }
      }

      let tileDataAddress = (tileIndex * tileHeightInPixels + tileLine) * bytesPerTileLine
      let data1 = self.videoRam[tileDataAddress]
      let data2 = self.videoRam[tileDataAddress + 1]

      let palette = sprite.palette == 0 ? self._spritePalette0 : self._spritePalette1

      // realX < 0 when sprite is partially visible on the left edge of the screen
      let startBit = sprite.realX < 0 ? -sprite.realX : 0

      // TODO: Priority
      var bit = 0
      while startBit + bit < tileWidthInPixels && sprite.realX + bit < framebufferSlice.count {
        let colorBit = sprite.flipX ? 7 - bit : bit
        let rawColor = self.getColorValue(data1, data2, bit: colorBit)
        if rawColor != 0 {
          let color = palette[rawColor]
          framebufferSlice[sprite.realX + bit] = color
        }
        bit += 1
      }
    }
  }

  /// Part of the framebuffer that should be filled in the current draw operation.
  private func getSpriteFramebuffer(line: Int) -> UnsafeMutableBufferPointer<UInt8> {
    guard let basePtr = UnsafeMutablePointer(self.framebuffer.baseAddress) else {
      fatalError("Unable to obtain framebuffer address.")
    }

    let start = basePtr.advanced(by: line * LcdConstants.width)
    return UnsafeMutableBufferPointer(start: start, count: LcdConstants.width)
  }

  internal func getSprites(line: Int) -> [Sprite] {
    // TODO: This is wrong! We should cache sprites from whole line and then select only 1st 10
    if let cached = self.spritesByLineCache[line] {
      return cached
    }

    var sprites = [Sprite]()
    sprites.reserveCapacity(LcdConstants.spriteCountPerLine)

    let spriteHeight = self.spriteHeight

    for sprite in self.sprites {
      let isAfterStart = line >= sprite.realY
      let isBeforeEnd  = line < (sprite.realY + spriteHeight)

      guard isAfterStart && isBeforeEnd else {
        continue
      }

      sprites.append(sprite)
      if sprites.count == LcdConstants.spriteCountPerLine {
        break
      }
    }

    // TODO: that if we already have sprite there? Pokemon intro bug.

    // Sort in REVERSE order (from right to left).
    // Sort in Swift is not stable, so we have to enumerate
    let sortedSprites = sprites
      .enumerated()
      .sorted { lhs, rhs in
        lhs.element.x != rhs.element.x ?
          lhs.element.x > rhs.element.x :
          lhs.offset    > rhs.offset
      }
      .map { $0.element }

    self.spritesByLineCache[line] = sortedSprites
    return sortedSprites
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
