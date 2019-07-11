// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

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
    let tileRow  = globalY / TileConstants.height
    let tileLine = globalY % TileConstants.height

    let tileMap = self.getTileMap(for: self.backgroundTileMap)
    let framebufferSlice = self.getBackgroundFramebuffer(line: line)

    var progress = 0
    while progress < framebufferSlice.count {
      let globalX = (Int(self.scrollX) + progress) % LcdConstants.backgroundMapWidth
      let tileColumn = globalX / TileConstants.width
      let tileIndexRaw = tileMap[tileRow * TileConstants.tilesPerRow + tileColumn]

      var tileIndex = Int(tileIndexRaw)
      if self.tileDataSelect == .from8800to97ff {
        tileIndex = 256 + Int(Int8(bitPattern: tileIndexRaw))
      }

      let tile = self.tiles[tileIndex]
      let tilePixels = tile.getPixels(in: tileLine)

      let startBit = globalX % TileConstants.width

      var bit = startBit
      while bit < TileConstants.width && progress + bit < framebufferSlice.count {
        let tileColor = tilePixels[bit]
        let color     = self._backgroundPalette[tileColor]
        framebufferSlice[progress + bit] = color
        bit += 1
      }

      progress += (TileConstants.width - startBit)
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
    let tileRow = windowY / TileConstants.height
    let tileLine = windowY % TileConstants.height

    let tileMap = self.getTileMap(for: self.windowTileMap)
    let framebufferSlice = self.getWindowFramebuffer(line: line)

    var windowX = 0
    while windowX < framebufferSlice.count {
      let tileColumn = windowX / TileConstants.width
      let tileIndexRaw = tileMap[tileRow * TileConstants.tilesPerRow + tileColumn]

      var tileIndex = Int(tileIndexRaw)
      if self.tileDataSelect == .from8800to97ff {
        tileIndex = 256 + Int(Int8(bitPattern: tileIndexRaw))
      }

      let tile = self.tiles[tileIndex]
      let tilePixels = tile.getPixels(in: tileLine)

      let startPixel = windowX % TileConstants.width
      for pixel in startPixel..<TileConstants.width {
        let pixelX = windowX + pixel
        guard pixelX < framebufferSlice.count else { break }

        let tileColor = tilePixels[pixel]
        let color     = self._backgroundPalette[tileColor]
        framebufferSlice[pixelX] = color
      }

      windowX += (TileConstants.width - startPixel)
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
          tileLine -= TileConstants.height
        }
      }

      let tile = self.tiles[tileIndex]
      let tilePixels = tile.getPixels(in: tileLine)

      let palette = sprite.palette == 0 ? self._spritePalette0 : self._spritePalette1

      // realX < 0 when sprite is partially visible on the left edge of the screen
      let startBit = sprite.realX < 0 ? -sprite.realX : 0

      // TODO: Priority
      var bit = 0
      while startBit + bit < TileConstants.width && sprite.realX + bit < framebufferSlice.count {
        let colorBit = sprite.flipX ? 7 - bit : bit
        let rawColor = tilePixels[colorBit]
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
    // TODO: This is wrong! We should cache sprites from whole line
    // and then select only 1st 10 (check rs - cache_sprite/render_sprite)
    if let cached = self.spritesByLineCache[line] {
      return cached
    }

    var sprites = [Sprite]()
    sprites.reserveCapacity(SpriteConstants.countPerLine)

    let spriteHeight = self.spriteHeight

    for sprite in self.sprites {
      let isAfterStart = line >= sprite.realY
      let isBeforeEnd  = line < (sprite.realY + spriteHeight)

      guard isAfterStart && isBeforeEnd else {
        continue
      }

      sprites.append(sprite)
      if sprites.count == SpriteConstants.countPerLine {
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

  internal func getTileMap(for map: TileMap) -> MemoryData {
    switch map {
    case .from9800to9bff: return self.tileMap9800to9bff
    case .from9c00to9fff: return self.tileMap9c00to9fff
    }
  }
}
