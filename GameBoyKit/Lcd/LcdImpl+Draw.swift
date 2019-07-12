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

      let pixelsToEnd = framebufferSlice.count - progress
      let startBit = globalX % TileConstants.width
      let lastBit  = min(TileConstants.width, pixelsToEnd)

      for bit in startBit..<lastBit {
        let tileColor = tilePixels[bit]
        let color     = self._backgroundPalette[tileColor]
        framebufferSlice[progress + bit] = color
      }

      progress += lastBit
    }
  }

  /// Part of the framebuffer that should be filled in the current draw operation.
  private func getBackgroundFramebuffer(line: Int) -> UnsafeMutableBufferPointer<UInt8> {
    guard let basePtr = UnsafeMutablePointer(self.framebuffer.baseAddress) else {
      fatalError("Unable to obtain framebuffer address.")
    }

    let start = basePtr.advanced(by: line * LcdConstants.width)
    var count = LcdConstants.width

    let isUsingWindow = self.isWindowEnabled && self.line >= self.windowY
    if isUsingWindow {
      // TODO: Convert to tests
      // http://bgb.bircd.org/pandocs.htm#lcdpositionandscrolling
      // desc                 |wx |with shift   | count
      // ---------------------+---+-------------+------
      // 1st tile (last pixel)|  0|  0 - 7 =  -7|     0
      // 1st tile (full)      |  7|  7 - 7 =   0|     0
      // no window            |166|166 - 7 = 159|   160

      let windowX = max(Int(self.windowX) - LcdConstants.windowXShift, 0)
      count = min(count, windowX + 1)
    }

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

    var progress = 0 // windowX
    while progress < framebufferSlice.count {
      let tileColumn = progress / TileConstants.width
      let tileIndexRaw = tileMap[tileRow * TileConstants.tilesPerRow + tileColumn]

      var tileIndex = Int(tileIndexRaw)
      if self.tileDataSelect == .from8800to97ff {
        tileIndex = 256 + Int(Int8(bitPattern: tileIndexRaw))
      }

      let tile = self.tiles[tileIndex]
      let tilePixels = tile.getPixels(in: tileLine)

      let pixelsToEnd = framebufferSlice.count - progress
      let startBit = progress % TileConstants.width
      let lastBit  = min(TileConstants.width, pixelsToEnd)

      for bit in startBit..<lastBit {
        let tileColor = tilePixels[bit]
        let color     = self._backgroundPalette[tileColor]
        framebufferSlice[progress + bit] = color
      }

      progress += lastBit
    }
  }

  /// Part of the framebuffer that should be filled in the current draw operation.
  private func getWindowFramebuffer(line: Int) -> UnsafeMutableBufferPointer<UInt8> {
    guard let basePtr = UnsafeMutablePointer(self.framebuffer.baseAddress) else {
      fatalError("Unable to obtain framebuffer address.")
    }

    // TODO: Convert to tests
    // http://bgb.bircd.org/pandocs.htm#lcdpositionandscrolling
    // desc                 |wx |with shift   |start*|count
    // ---------------------+---+-------------+------+-----
    // 1st tile (last pixel)|  0|  0 - 7 =  -7|     0|  160
    // 1st tile (full)      |  7|  7 - 7 =   0|     0|  160
    // no window            |166|166 - 7 = 159|   160|    0
    // * - relative to line start

    let windowX = Int(self.windowX) - LcdConstants.windowXShift

    let relativeStart = max(windowX, 0)
    let start = basePtr.advanced(by: line * LcdConstants.width + relativeStart)
    let count = max(LcdConstants.width - relativeStart, 0)

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
