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

  private var sprites = (0..<Constants.count).map { Sprite(id: $0) }

  /// Cache, so we don't recalculate sprites on every line draw.
  /// Writes will clear appropriate entries.
  private var spritesInLine = SpritesPerLineInPreviousFrame()

  internal init(spriteSize: Sprite.Size) {
    self.spriteSize = spriteSize
  }

  // MARK: - Sprite size

  internal mutating func onSpriteSizeChanged(newSize: Sprite.Size) {
    let hasSizeChanged = self.spriteSize != newSize
    if hasSizeChanged {
      self.spritesInLine.removeAll()
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
        self.clearSpriteCache(fromLine: sprite.realY)
        sprite.y = value
        self.clearSpriteCache(fromLine: sprite.realY)
      }

    case 1:
      if sprite.x != value {
        sprite.x = value
        self.clearSpriteCache(fromLine: sprite.realY)
      }

    case 2:
      sprite.tile = value

    case 3:
      sprite.flags = value

    default:
      break
    }
  }

  private mutating func clearSpriteCache(fromLine startLine: Int) {
    let height = self.spriteSize.value

    let startLine = max(startLine, 0)
    let endLine = min(startLine + height, Lcd.Constants.backgroundMapHeight)

    for line in startLine..<endLine {
      self.spritesInLine.remove(line: line)
    }
  }

  // MARK: - Draw

  /// Sort in REVERSE order (from right to left).
  internal mutating func getSpritesToDrawFromRightToLeft(line: Int) -> [Sprite] {
    // Do we have data from previous frame?
    if let fromPreviosFrame = self.spritesInLine.get(line: line) {
      return fromPreviosFrame
    }

    // Find which sprites should be displayed in the current line.
    var result = [Sprite]()
    result.reserveCapacity(Constants.maxCountPerLine)

    let spriteHeight = self.spriteSize.value

    for sprite in self.sprites {
      let spriteMinY = sprite.realY
      let spriteMaxY = sprite.realY + spriteHeight
      let spriteContainsLine = spriteMinY <= line && line < spriteMaxY

      guard spriteContainsLine else {
        continue
      }

      // TODO: Find the insertion index
      result.append(sprite)
      if result.count == Constants.maxCountPerLine {
        break
      }
    }

    // Sort in Swift is not stable! Thats why we have to use sprite.id.
    result.sort { lhs, rhs in
      lhs.x == rhs.x ? lhs.id > rhs.id : lhs.x > rhs.x
    }

    self.spritesInLine.set(line: line, sprites: result)
    return result
  }
}
