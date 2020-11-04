// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftlint:disable function_body_length

private let tileSize        = 8 // pixels
private let tileRowCount    = 32
private let tileColumnCount = 32
private let tilesPerRow = 32

extension LcdImpl {

  // MARK: - Properties

  internal func dumpProperties() {
    print("LCDC: \(self.control.bin)")
    print("  isLcdEnabled: \(self.isLcdEnabled)")
    print("  isBackgroundVisible: \(self.isBackgroundVisible)")
    print("  isWindowEnabled: \(self.isWindowEnabled)")
    print("  isSpriteEnabled: \(self.isSpriteEnabled)")
    print("  windowTileMap: \(self.windowTileMap)")
    print("  backgroundTileMap: \(self.backgroundTileMap)")
    print("  tileDataSelect: \(self.tileDataSelect)")
    print("  spriteHeight: \(self.spriteHeight)")

    print("STAT: \(self.status.bin)")
    print("  isLineCompareInterruptEnabled: \(self.isLineCompareInterruptEnabled)")
    print("  isOamInterruptEnabled: \(self.isOamInterruptEnabled)")
    print("  isVBlankInterruptEnabled: \(self.isVBlankInterruptEnabled)")
    print("  isHBlankInterruptEnabled: \(self.isHBlankInterruptEnabled)")
    print("  isLineCompareInterrupt: \(self.isLineCompareInterrupt)")
    print("  mode: \(self.mode)")

    print("ScrollY: \(self.scrollY.hex)")
    print("ScrollX: \(self.scrollX.hex)")
    print("Line: \(self.line.hex)")
    print("LineCompare: \(self.lineCompare.hex)")
    print("WindowY: \(self.windowY.hex)")
    print("WindowX: \(self.windowX.hex)")
    print("BackgroundPalette: \(self.backgroundPalette.hex)")
    print("SpritePalette0: \(self.spritePalette0.hex)")
    print("SpritePalette1: \(self.spritePalette1.hex)")
  }

  // MARK: - Tile indices

  internal func dumpTileIndices(_ map: TileMap) {
    print("Tile indices \(map):")

    // horizontal markers
    print("    | " , separator: "", terminator: "")
    for tileColumn in 0..<tileColumnCount {
      let text = String(describing: tileColumn)
      let padding = String(repeating: " ", count: 2 - text.count)
      print(padding + text, separator: "", terminator: " ")
    }
    print()

    print("----+" , separator: "", terminator: "")
    for _ in 0..<tileColumnCount {
      print("---", separator: "", terminator: "")
    }
    print()

    // data
    let tileMap = self.getTileMap(for: map)
    for tileRow in 0..<tileRowCount {
      let rowText = String(describing: tileRow)
      let rowPadding = String(repeating: " ", count: 2 - rowText.count)
      print("\(rowPadding) \(rowText) |", separator: "", terminator: " ")

      for tileColumn in 0..<tileColumnCount {
        let tileIndex = tileMap[tileRow * tilesPerRow + tileColumn]

        let text = String(tileIndex, radix: 16, uppercase: false)
        let textPadding = String(repeating: "0", count: 2 - text.count)
        print(textPadding + text, separator: "", terminator: " ")
      }
      print()
    }
  }

  // MARK: - Tile data

  internal func dumpTileData(_ data: TileData) {
    let columnCount = 16
    print("Tile data \(data):")

    // horizontal markers
    print("    |" , separator: "", terminator: "")
    for tileColumn in 0..<columnCount {
      let text = UInt8(tileColumn).hex
      print("    \(text)|", separator: "", terminator: "")
    }
    print()

    print("----+" , separator: "", terminator: "")
    for _ in 0..<columnCount {
      print("--------+", separator: "", terminator: "")
    }
    print()

    let start = data == .from8000to8fff ?   0 : 128
    let end   = data == .from8000to8fff ? 256 : 384
    let tiles = self.tiles[start..<end]

    let rowCount = tiles.count / columnCount
    for row in 0..<rowCount {
      for line in 0..<tileSize {
        if line == 0 {
          let text = UInt8(row).hex
          print(text, separator: "", terminator: "|")
        } else {
          print("    |", separator: "", terminator: "")
        }

        for column in 0..<columnCount {
          let tileIndex = start + row * columnCount + column
          let tile = tiles[tileIndex]

          for pixel in tile.getPixels(in: line) {
            let color = pixel == 0 ? " " : String(describing: pixel)
            print(color, separator: "", terminator: "")
          }
          print("|", separator: "", terminator: "")
        }
        print()
      }
      print("----+" , separator: "", terminator: "")
      for _ in 0..<columnCount {
        print("--------+", separator: "", terminator: "")
      }
      print()
    }
  }

  // MARK: - Background

  internal func dumpBackground(_ map: TileMap, _ data: TileData) {
    print("Background for map: \(map), data: \(data)")

    let rowRange    = 0..<tileRowCount
    let columnRange = 0..<tileColumnCount

    let linesPerTile = 8

    // horizontal markers
    print(" t  l | " , separator: "", terminator: "")
    for tileColumn in columnRange {
      let text = String(describing: tileColumn)
      let padding = String(repeating: " ", count: 8 - text.count)
      print(padding + text, separator: "", terminator: "|")
    }
    print()

    print("------+" , separator: "", terminator: "")
    for _ in columnRange {
      print("---------", separator: "", terminator: "")
    }
    print("|")

    // data
    for tileRow in rowRange {
      for tileLine in 0..<linesPerTile {
        let tileRowText = String(describing: tileRow)
        let tileRowPadding = String(repeating: " ", count: 2 - tileRowText.count)
        print(tileRowPadding + tileRowText, separator: "", terminator: " ")

        let tileLineText = String(describing: tileLine)
        let tileLinePadding = String(repeating: " ", count: 2 - tileLineText.count)
        print(tileLinePadding + tileLineText, separator: "", terminator: " ")

        print("|", separator: "", terminator: " ")

        for tileColumn in columnRange {
          self.drawTile(map, data, tileRow, tileColumn, tileLine)
        }
        print()
      }

      print("-------" , separator: "", terminator: "")
      for _ in columnRange {
        print("---------", separator: "", terminator: "")
      }
      print("|")
    }
  }

  private func drawTile(_ map:  TileMap,
                        _ data: TileData,
                        _ tileRow:    Int,
                        _ tileColumn: Int,
                        _ tileLine:   Int) {

    let tileMap = self.getTileMap(for: map)
    let tileIndexRaw = tileMap[tileRow * tilesPerRow + tileColumn]

    var tileIndex = Int(tileIndexRaw)
    if data == .from8800to97ff {
      tileIndex = 256 + Int(Int8(bitPattern: tileIndexRaw))
    }

    let tile = self.tiles[tileIndex]
    let tilePixels = tile.getPixels(in: tileLine)

    for pixel in tilePixels {
      let color = pixel == 0 ? " " : String(describing: pixel)
      print(color, separator: "", terminator: "")
    }
    print("|", separator: "", terminator: "")
  }
}
