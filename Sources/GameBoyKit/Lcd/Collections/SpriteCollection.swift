// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

private let oamStartAddress = MemoryMap.oam.start

/// OAM
internal struct SpriteCollection {

  internal enum Constants {
    /// Total number of sprites (40)
    internal static let count: UInt8 = 40
    /// 1 line = max 10 sprites
    internal static let maxCountPerLine = 10
    /// 1 sprite = 4 bytes
    internal static let byteCount = 4
  }

  private var spriteSize: Sprite.Size

  private var sprites = (0..<Constants.count).map { _ in Sprite() }

  /// Cache, so we don't recalculate sprites on every line draw.
  /// Writes will clear appropriate entries.
  private var lineCache = SpritesPerLineInPreviousFrame()

  internal init(spriteSize: Sprite.Size) {
    self.spriteSize = spriteSize
  }

  // MARK: - Sprite size

  internal mutating func onSpriteSizeChanged(newSize: Sprite.Size) {
    let hasSizeChanged = self.spriteSize != newSize
    if hasSizeChanged {
      self.lineCache.removeAll()
    }
  }

  // MARK: - Read

  internal func read(_ address: UInt16) -> UInt8 {
    let oamAddress = Int(address - oamStartAddress)

    let index = oamAddress / Constants.byteCount
    let byte = oamAddress % Constants.byteCount

    let sprite = self.sprites[index]
    switch byte {
    case 0: return sprite.y
    case 1: return sprite.x
    case 2: return sprite.tile
    case 3: return sprite.flags
    default: return 0
    }
  }

  // MARK: - Write

  internal mutating func write(_ address: UInt16, value: UInt8) {
    let oamAddress = Int(address - oamStartAddress)

    let index = oamAddress / Constants.byteCount
    let byte = oamAddress % Constants.byteCount

    let sprite = self.sprites[index]
    switch byte {
    case 0:
      if sprite.y != value {
        // We need to clear both old and new lines
        self.clearSpriteCache(fromLine: sprite.realY)
        self.sprites[index].y = value
        self.clearSpriteCache(fromLine: self.sprites[index].realY)
      }

    case 1:
      if sprite.x != value {
        self.sprites[index].x = value
        self.clearSpriteCache(fromLine: sprite.realY)
      }

    case 2:
      if sprite.tile != value {
        self.sprites[index].tile = value
        self.clearSpriteCache(fromLine: sprite.realY)
      }

    case 3:
      if sprite.flags != value {
        self.sprites[index].flags = value
        self.clearSpriteCache(fromLine: sprite.realY)
      }

    default:
      break
    }
  }

  private mutating func clearSpriteCache(fromLine startLine: Int) {
    let height = self.spriteSize.value

    let startLine = max(startLine, 0)
    let endLine = min(startLine + height, Lcd.Constants.backgroundMapHeight)

    for line in startLine..<endLine {
      self.lineCache.remove(line: line)
    }
  }

  // MARK: - Draw

  // Most of the lines will not contain sprites.
  // We will use Swift COW, so that they share the same buffer
  // and copy only when line actually has some sprites.
  //
  // Techically Swift will share buffer if collection is empty,
  // but it may not work with 'reserveCapacity'.
  private static var lineWithoutSprites: [Sprite] = {
    var result = [Sprite]()
    result.reserveCapacity(Constants.maxCountPerLine)
    return result
  }()

  /// Sort in REVERSE order (from right to left), this is the order in which
  /// sprites should be drawn on screen.
  ///
  /// From http://bgb.bircd.org/pandocs.htm#vramspriteattributetableoam:
  ///
  /// Sprite Priorities and Conflicts
  ///
  /// When sprites with different `x coordinate` values overlap, the one with the
  /// smaller `x coordinate` (closer to the left) will have priority and appear
  /// above any others. This applies in Non CGB Mode only.
  ///
  /// When sprites with the same `x coordinate` values overlap, they have priority
  /// according to table ordering. (i.e. `$FE00` - highest, `$FE04` - next highest, etc.)
  /// In CGB Mode priorities are always assigned like this.
  ///
  /// Only 10 sprites can be displayed on any one line.
  /// When this limit is exceeded, the lower priority sprites (priorities listed above)
  /// won't be displayed.
  internal mutating func getSpritesToDrawFromRightToLeft(line: Int) -> [Sprite] {
    // Do we have data from previous frame?
    if let fromPreviosFrame = self.lineCache.get(line: line) {
      return fromPreviosFrame
    }

    // Find which sprites should be displayed in the current line.
    var result = Self.lineWithoutSprites
    let spriteHeight = self.spriteSize.value

    for sprite in self.sprites {
      let spriteMinY = sprite.realY
      let spriteMaxY = sprite.realY + spriteHeight
      let spriteContainsLine = spriteMinY <= line && line < spriteMaxY

      guard spriteContainsLine else {
        continue
      }

      // Insertion sort on 'x' (stable, but in reverse order, anti-stable?).
      let index = self.getRightToLeftInsertionIndex(collection: result, sprite: sprite)
      result.insert(sprite, at: index)

      if result.count == Constants.maxCountPerLine {
        break
      }
    }

    self.lineCache.set(line: line, sprites: result)
    return result
  }

  private func getRightToLeftInsertionIndex(collection: [Sprite],
                                            sprite: Sprite) -> Int {
    // Remember that we have to sort them in right-to-left order!
    // This is the sprite drawing order. It is basically a reversal.
    for (i, s) in collection.enumerated() {
      // Equal 'x'
      // 'sprite' is later than 's' in 'SpriteCollection' which means
      // that it should be put after 's'.
      // But since we have to return in 'drawing order' we will put it before.
      //
      // Example:
      // | x                || 60 | 30 | 30 | 0 |
      // | Collection index ||  0 |  3 |  2 | 5 |
      //
      // We are inserting sprite with x: 30, collection index: 8.
      //
      // Expected result:
      // | x                || 60 | 30 | 30 | 30 | 0 |
      // | Collection index ||  0 |  8 |  3 |  2 | 5 |
      //                             ^ inserted element
      if sprite.x == s.x {
        return i
      }

      // Non-equal 'x'
      // Lower 'x' should be first, but since we do this in drawing order,
      // they should be put last.
      //
      // Example:
      // | x                || 60 | 30 | 0 |
      // | Collection index ||  0 |  3 | 5 |
      //
      // We are inserting sprite with x: 45, collection index: 8.
      //
      // Expected result:
      // | x                || 60 | 45 | 30 | 0 |
      // | Collection index ||  0 |  8 |  3 | 5 |
      //                             ^ inserted element
      if sprite.x > s.x {
        return i
      }

      // Otherwise: sprite.x < s.x
      // Which means that we need to put it further to the back.
    }

    // Put it at the end
    return collection.count
  }
}
