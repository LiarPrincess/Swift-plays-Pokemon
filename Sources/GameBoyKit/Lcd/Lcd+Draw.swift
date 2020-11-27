// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftlint:disable file_length

extension Lcd {

  internal func drawLine() {
    if self.control.isBackgroundVisible {
      self.drawBackgroundLine()
    }

    if self.control.isWindowEnabled {
      self.drawWindow()
    }

    if self.control.isSpriteEnabled {
      self.drawSprites()
    }
  }

  // MARK: - Background line

  // swiftlint:disable:next function_body_length
  private func drawBackgroundLine() {
    let line = Int(self.line)
    let globalY = (Int(self.scrollY) + line) % Constants.backgroundMapHeight
    let tileRow = globalY / Tile.Constants.height
    let tileLine = globalY % Tile.Constants.height

    let tileData = self.control.tileDataSelect
    let tileMap = self.getTileMap(for: self.control.backgroundTileMap)
    let framebufferSlice = self.getBackgroundFramebuffer(line: line)

    var progress = 0
    while progress < framebufferSlice.count {
      let globalX = (Int(self.scrollX) + progress) % Constants.backgroundMapWidth
      let tileColumn = globalX / Tile.Constants.width

      let tileIndex = self.getTileIndex(map: tileMap,
                                        data: tileData,
                                        row: tileRow,
                                        column: tileColumn)

      let tile = self.tiles[tileIndex]
      let tilePixels = tile.getPixels(in: tileLine)

      let pixelsToEnd = framebufferSlice.count - progress
      let startBit = globalX % Tile.Constants.width
      let lastBit = min(Tile.Constants.width, pixelsToEnd)

      // This could be rewritten as for-loop.
      // But that would drop 16 fps in DEBUG (look for 'IndexIterator' in Instruments).
      var bit = startBit
      while bit != lastBit {
        let tileColor = tilePixels[bit]
        let color = self.backgroundColorPalette.getColor(index: tileColor)

        let targetX = progress + (bit - startBit)
        framebufferSlice[targetX] = color
        self.tileColorInLine.set(x: targetX, color: tileColor)
        bit += 1
      }

      progress += (Tile.Constants.width - startBit)
    }
  }

  /// Part of the framebuffer that should be filled in the current draw operation.
  private func getBackgroundFramebuffer(line: Int) -> UnsafeMutableBufferPointer<UInt8> {
    let framebufferStart = self.framebuffer.baseAddress

    let lineOffset = line * Constants.width
    let start = framebufferStart.advanced(by: lineOffset)
    var count = Constants.width

    let isUsingWindow = self.control.isWindowEnabled && self.line >= self.windowY
    if isUsingWindow {
      // http://bgb.bircd.org/pandocs.htm#lcdpositionandscrolling
      // desc                 |wx |with shift   | count
      // ---------------------+---+-------------+------
      // 1st tile (last pixel)|  0|  0 - 7 =  -7|     0
      // 1st tile (full)      |  7|  7 - 7 =   0|     0
      // last tile (1 pixel)  |166|166 - 7 = 159|   159

      let windowX = max(self.shiftedWindowX, 0)
      count = min(count, windowX)
    }

    return UnsafeMutableBufferPointer(start: start, count: count)
  }

  // MARK: - Draw window

  // swiftlint:disable:next function_body_length
  private func drawWindow() {
    let line = Int(self.line)
    let windowStartY = Int(self.windowY)

    guard line >= windowStartY else {
      return
    }

    let windowY = line - windowStartY
    let tileRow = windowY / Tile.Constants.height
    let tileLine = windowY % Tile.Constants.height

    let tileData = self.control.tileDataSelect
    let tileMap = self.getTileMap(for: self.control.windowTileMap)
    let framebufferSlice = self.getWindowFramebuffer(line: line)

    var progress = 0 // windowX
    while progress < framebufferSlice.count {
      let tileColumn = progress / Tile.Constants.width

      let tileIndex = self.getTileIndex(map: tileMap,
                                        data: tileData,
                                        row: tileRow,
                                        column: tileColumn)

      let tile = self.tiles[tileIndex]
      let tilePixels = tile.getPixels(in: tileLine)

      let pixelsToEnd = framebufferSlice.count - progress
      let startBit = progress % Tile.Constants.width
      let lastBit = min(Tile.Constants.width, pixelsToEnd)

      var bit = startBit
      while bit != lastBit {
        let tileColor = tilePixels[bit]
        let color = self.backgroundColorPalette.getColor(index: tileColor)

        let targetX = progress + (bit - startBit)
        framebufferSlice[targetX] = color
        self.tileColorInLine.set(x: targetX, color: tileColor)

        bit += 1
      }

      progress += (Tile.Constants.width - startBit)
    }
  }

  /// Part of the framebuffer that should be filled in the current draw operation.
  private func getWindowFramebuffer(line: Int) -> UnsafeMutableBufferPointer<UInt8> {
    let framebufferStart = self.framebuffer.baseAddress

    // http://bgb.bircd.org/pandocs.htm#lcdpositionandscrolling
    // desc                 |wx |with shift   |start*|count
    // ---------------------+---+-------------+------+-----
    // 1st tile (last pixel)|  0|  0 - 7 =  -7|     0|  160
    // 1st tile (full)      |  7|  7 - 7 =   0|     0|  160
    // no window            |166|166 - 7 = 159|   160|    0
    // * - relative to line start

    let relativeStart = max(self.shiftedWindowX, 0)
    let start = framebufferStart.advanced(by: line * Constants.width + relativeStart)
    let count = max(Constants.width - relativeStart, 0)

    return UnsafeMutableBufferPointer(start: start, count: count)
  }

  // MARK: - Draw sprites

  // swiftlint:disable:next function_body_length
  private func drawSprites() {
    let line = Int(self.line)
    let spriteHeight = self.control.spriteHeight.value

    let sprites = self.sprites.getSpritesToDrawFromRightToLeft(line: line)
    let framebufferSlice = self.getSpriteFramebuffer(line: line)

    // code taken from 'binjgb'
    for sprite in sprites {
      let inScreenLeft = sprite.realX + Tile.Constants.width >= 0
      let inScreenRight = sprite.realX < Constants.width
      guard inScreenLeft && inScreenRight else {
        continue
      }

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
          tileLine -= Tile.Constants.height
        }
      }

      let tile = self.tiles[tileIndex]
      let tilePixels = tile.getPixels(in: tileLine)

      let palette = sprite.palette == 0 ?
        self.spriteColorPalette0 :
        self.spriteColorPalette1

      // realX < 0 when sprite is partially visible on the left edge of the screen
      let startBit = sprite.realX < 0 ? -sprite.realX : 0

      let lcdEnd = min(framebufferSlice.count, sprite.realX + Tile.Constants.width)
      let lastBit = lcdEnd - sprite.realX

      for bit in startBit..<lastBit {
        let colorBit = sprite.flipX ? 7 - bit : bit
        let rawColor = tilePixels[colorBit]

        let targetX = sprite.realX + bit

        let isTransparent = rawColor == 0
        let isBackgroundZero = self.tileColorInLine.isColorZero(x: targetX)
        let isAboveBackground = sprite.isAboveBackground || isBackgroundZero

        if !isTransparent && isAboveBackground {
          let color = palette.getColor(index: rawColor)
          framebufferSlice[targetX] = color
        }
      }
    }
  }

  /// Part of the framebuffer that should be filled in the current draw operation.
  private func getSpriteFramebuffer(line: Int) -> UnsafeMutableBufferPointer<UInt8> {
    let framebufferStart = self.framebuffer.baseAddress
    let start = framebufferStart.advanced(by: line * Constants.width)
    return UnsafeMutableBufferPointer(start: start, count: Constants.width)
  }

  // MARK: - Helpers

  /// windowX - 7
  private var shiftedWindowX: Int {
    return Int(self.windowX) - Constants.windowXShift
  }

  internal func getTileMap(for map: TileMap.Variant) -> TileMap {
    switch map {
    case .from9800to9bff: return self.tileMap9800to9bff
    case .from9c00to9fff: return self.tileMap9c00to9fff
    }
  }

  private func getTileIndex(map: TileMap,
                            data: TileData.Variant,
                            row: Int,
                            column: Int) -> Int
  {
    let tileIndexRaw = map[row * Tile.Constants.tilesPerRow + column]

    switch data {
    case .from8000to8fff:
      return Int(tileIndexRaw)
    case .from8800to97ff:
      return 256 + Int(Int8(bitPattern: tileIndexRaw))
    }
  }
}
