// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import GameBoyKit

// swiftlint:disable file_length

private let maxSpriteCountPerLine = SpriteCollection.Constants.maxCountPerLine

/// Test order in which sprites should be drawn on screen
/// (if we are even drawing them).
class SpriteCollectionSpriteSelectionTests: XCTestCase {

  // MARK: - Above/below/on line

  func test_position_onLine_size8() {
    let size = Sprite.Size.size8
    var collection = SpriteCollection(spriteSize: size)

    let line = 68
    var expectedTiles = [UInt8]()

    for i in 0..<size.value {
      let tile = UInt8(i)
      expectedTiles.append(tile)

      self.setSprite(collection: &collection,
                     spriteIndex: 5 + i,
                     line: line - i,
                     tile: tile)
    }

    let sprites = self.getSpritesToDraw(collection: &collection, line: line)
    let tiles = self.getTileNumbers(sprites: sprites)
    XCTAssertEqual(tiles, expectedTiles)
  }

  func test_position_onLine_size16() {
    let size = Sprite.Size.size16
    var collection = SpriteCollection(spriteSize: size)

    let line = 68
    var expectedTiles = [UInt8]()

    for i in 0..<size.value {
      let tile = UInt8(i)
      expectedTiles.append(tile)

      self.setSprite(collection: &collection,
                     spriteIndex: 5 + i,
                     line: line - i,
                     tile: tile)
    }

    let sprites = self.getSpritesToDraw(collection: &collection, line: line)
    let tiles = self.getTileNumbers(sprites: sprites)
    XCTAssertEqual(tiles, Array(expectedTiles[0..<maxSpriteCountPerLine]))
  }

  func test_position_aboveLine() {
    let size = Sprite.Size.size8
    var collection = SpriteCollection(spriteSize: size)

    let line = 68
    self.setSprite(collection: &collection,
                   spriteIndex: 5,
                   line: line - size.value - 1)

    let sprites = self.getSpritesToDraw(collection: &collection, line: line)
    XCTAssertEqual(sprites.count, 0)
  }

  func test_position_belowLine() {
    let size = Sprite.Size.size8
    var collection = SpriteCollection(spriteSize: size)

    let line = 68
    self.setSprite(collection: &collection,
                   spriteIndex: 5,
                   line: line + 1)

    let sprites = self.getSpritesToDraw(collection: &collection, line: line)
    XCTAssertEqual(sprites.count, 0)
  }

  // MARK: - Count

  func test_count_belowMax() {
    let size = Sprite.Size.size8
    var collection = SpriteCollection(spriteSize: size)

    let line = 68
    var expectedTiles = [UInt8]()

    for i in 0..<maxSpriteCountPerLine {
      let tile = UInt8(i)
      expectedTiles.append(tile)

      self.setSprite(collection: &collection,
                     spriteIndex: 5 + i,
                     line: line,
                     tile: tile)
    }

    let sprites = self.getSpritesToDraw(collection: &collection, line: line)
    let tiles = self.getTileNumbers(sprites: sprites)
    XCTAssertEqual(tiles, expectedTiles)
  }

  func test_count_aboveMax() {
    let size = Sprite.Size.size8
    var collection = SpriteCollection(spriteSize: size)

    let line = 68
    var expectedTiles = [UInt8]()

    let spriteCount = maxSpriteCountPerLine + 3
    for i in 0..<spriteCount {
      let tile = UInt8(i)
      expectedTiles.append(tile)

      self.setSprite(collection: &collection,
                     spriteIndex: 5 + i,
                     line: line,
                     tile: tile)
    }

    let sprites = self.getSpritesToDraw(collection: &collection, line: line)
    let tiles = self.getTileNumbers(sprites: sprites)
    XCTAssertEqual(tiles, Array(expectedTiles[0..<maxSpriteCountPerLine]))
  }

  // MARK: - Priority

  func test_priority_noOverlap_sortsByX() {
    let size = Sprite.Size.size8
    var collection = SpriteCollection(spriteSize: size)

    let line = 68
    let columns = [30, 5, 60]

    for (index, column) in columns.enumerated() {
      let tile = UInt8(column)
      self.setSprite(collection: &collection,
                     spriteIndex: 5 + index,
                     line: 68,
                     column: column,
                     tile: tile)
    }

    let sprites = self.getSpritesToDraw(collection: &collection, line: line)
    let tiles = self.getTileNumbers(sprites: sprites)

    let expectedTiles: [UInt8] = [5, 30, 60]
    XCTAssertEqual(tiles, expectedTiles)
  }

  func test_priority_partialOverlap_lowerXWins() {
    assert(Tile.Constants.width == 8)

    let size = Sprite.Size.size8
    var collection = SpriteCollection(spriteSize: size)

    let line = 68
    let columns = [30, 29, 31]

    for (index, column) in columns.enumerated() {
      let tile = UInt8(column)
      self.setSprite(collection: &collection,
                     spriteIndex: 5 + index,
                     line: 68,
                     column: column,
                     tile: tile)
    }

    let sprites = self.getSpritesToDraw(collection: &collection, line: line)
    let tiles = self.getTileNumbers(sprites: sprites)

    let expectedTiles: [UInt8] = [29, 30, 31]
    XCTAssertEqual(tiles, expectedTiles)
  }

  func test_priority_fullOverlap_firstInCollectionWins() {
    assert(Tile.Constants.width == 8)

    let size = Sprite.Size.size8
    var collection = SpriteCollection(spriteSize: size)

    let line = 68
    let column = 30
    let expectedTiles: [UInt8] = [30, 5, 60]

    for (index, tile) in expectedTiles.enumerated() {
      self.setSprite(collection: &collection,
                     spriteIndex: 5 + index,
                     line: 68,
                     column: column,
                     tile: tile)
    }

    let sprites = self.getSpritesToDraw(collection: &collection, line: line)
    let tiles = self.getTileNumbers(sprites: sprites)
    XCTAssertEqual(tiles, expectedTiles)
  }

  // MARK: - Helpers

  private func setSprite(collection: inout SpriteCollection,
                         spriteIndex: Int,
                         line: Int? = nil,
                         column: Int? = nil,
                         tile: UInt8? = nil,
                         flags: UInt8? = nil)
  {
    assert(spriteIndex < Sprite.Constants.count)

    let oamStartAddress = MemoryMap.oam.start
    let spriteSize = Sprite.Constants.byteCount
    let address = oamStartAddress + UInt16(spriteIndex * spriteSize)

    // Sprites are not drawn at 'y', but at 'y - 16'
    if let line = line {
      let y = UInt8(line) + 16
      collection.write(address + 0, value: y)
    }

    // Sprites are not drawn at 'x', but at 'x - 8'
    if let column = column {
      let x = UInt8(column) + 8
      collection.write(address + 1, value: x)
    }

    if let tile = tile {
      collection.write(address + 2, value: tile)
    }

    if let flags = flags {
      collection.write(address + 3, value: flags)
    }
  }

  /// In left to right  order!
  private func getSpritesToDraw(collection: inout SpriteCollection,
                                line: Int) -> [Sprite]
  {
    let sprites = collection.getSpritesToDrawFromRightToLeft(line: line)
    return sprites.reversed()
  }

  private func getTileNumbers(sprites: [Sprite]) -> [UInt8] {
    return sprites.map { $0.tile }
  }
}
