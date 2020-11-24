// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftlint:disable function_body_length

private let tileSize = 8 // pixels
private let tileRowCount = 32
private let tileColumnCount = 32
private let tilesPerRow = 32

extension Debugger {

  // MARK: - Properties

  public func dumpLcdState() {
    let lcd = self.lcd
    let control = self.lcd.control
    let status = self.lcd.status

    print("""
Lcd
  LCDC: \(control.value.bin)
    isLcdEnabled: \(control.isLcdEnabled)
    isBackgroundVisible: \(control.isBackgroundVisible)
    isWindowEnabled: \(control.isWindowEnabled)
    isSpriteEnabled: \(control.isSpriteEnabled)
    windowTileMap: \(control.windowTileMap)
    backgroundTileMap: \(control.backgroundTileMap)
    tileDataSelect: \(control.tileDataSelect)
    spriteHeight: \(control.spriteHeight)

  STAT: \(status.value.bin)
    isLineCompareInterruptEnabled: \(status.isLineCompareInterruptEnabled)
    isOamInterruptEnabled: \(status.isOamInterruptEnabled)
    isVBlankInterruptEnabled: \(status.isVBlankInterruptEnabled)
    isHBlankInterruptEnabled: \(status.isHBlankInterruptEnabled)
    isLineCompareInterrupt: \(status.isLineCompareInterrupt)
    mode: \(status.mode)

  ScrollY: \(lcd.scrollY.hex)
  ScrollX: \(lcd.scrollX.hex)
  Line: \(lcd.line.hex)
  LineCompare: \(lcd.lineCompare.hex)
  WindowY: \(lcd.windowY.hex)
  WindowX: \(lcd.windowX.hex)
  BackgroundPalette: \(lcd.backgroundColorPalette.value.hex)
  SpritePalette0: \(lcd.spriteColorPalette0.value.hex)
  SpritePalette1: \(lcd.spriteColorPalette1.value.hex)
""")
  }

  // MARK: - Tile indices

  public func dumpTileIndices(tileMap: TileMap.Variant) {
    print("Tile indices \(tileMap):")

    // horizontal markers
    print("    | ", separator: "", terminator: "")
    for tileColumn in 0..<tileColumnCount {
      let text = String(describing: tileColumn)
      let padding = String(repeating: " ", count: 2 - text.count)
      print(padding + text, separator: "", terminator: " ")
    }
    print()

    print("----+", separator: "", terminator: "")
    for _ in 0..<tileColumnCount {
      print("---", separator: "", terminator: "")
    }
    print()

    // data
    let tileMapBuffer = self.lcd.getTileMap(for: tileMap)
    for tileRow in 0..<tileRowCount {
      let rowText = String(describing: tileRow)
      let rowPadding = String(repeating: " ", count: 2 - rowText.count)
      print("\(rowPadding) \(rowText) |", separator: "", terminator: " ")

      for tileColumn in 0..<tileColumnCount {
        let tileIndex = tileMapBuffer[tileRow * tilesPerRow + tileColumn]

        let text = String(tileIndex, radix: 16, uppercase: false)
        let textPadding = String(repeating: "0", count: 2 - text.count)
        print(textPadding + text, separator: "", terminator: " ")
      }
      print()
    }
  }

  // MARK: - Tile data

  public func dumpTileData(tileData: TileData.Variant) {
    let columnCount = 16
    print("Tile data \(tileData):")

    // horizontal markers
    print("    |", separator: "", terminator: "")
    for tileColumn in 0..<columnCount {
      let text = UInt8(tileColumn).hex
      print("    \(text)|", separator: "", terminator: "")
    }
    print()

    print("----+", separator: "", terminator: "")
    for _ in 0..<columnCount {
      print("--------+", separator: "", terminator: "")
    }
    print()

    let start = tileData == .from8000to8fff ? 0 : 128
    let end = tileData == .from8000to8fff ? 256 : 384
    let tiles = self.lcd.tiles[start..<end]

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
      print("----+", separator: "", terminator: "")
      for _ in 0..<columnCount {
        print("--------+", separator: "", terminator: "")
      }
      print()
    }
  }

  // MARK: - Background

  public func dumpBackground(tileMap: TileMap.Variant, tileData: TileData.Variant) {
    print("Background for map: \(tileMap), data: \(tileData)")

    let rowRange = 0..<tileRowCount
    let columnRange = 0..<tileColumnCount

    let linesPerTile = 8

    // horizontal markers
    print(" t  l | ", separator: "", terminator: "")
    for tileColumn in columnRange {
      let text = String(describing: tileColumn)
      let padding = String(repeating: " ", count: 8 - text.count)
      print(padding + text, separator: "", terminator: "|")
    }
    print()

    print("------+", separator: "", terminator: "")
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
          self.drawTile(map: tileMap,
                        data: tileData,
                        row: tileRow,
                        column: tileColumn,
                        line: tileLine)
        }
        print()
      }

      print("-------", separator: "", terminator: "")
      for _ in columnRange {
        print("---------", separator: "", terminator: "")
      }
      print("|")
    }
  }

  private func drawTile(map: TileMap.Variant,
                        data: TileData.Variant,
                        row tileRow: Int,
                        column tileColumn: Int,
                        line tileLine: Int)
  {
    let tileMap = self.lcd.getTileMap(for: map)
    let tileIndexRaw = tileMap[tileRow * tilesPerRow + tileColumn]

    var tileIndex = Int(tileIndexRaw)
    if data == .from8800to97ff {
      tileIndex = 256 + Int(Int8(bitPattern: tileIndexRaw))
    }

    let tile = self.lcd.tiles[tileIndex]
    let tilePixels = tile.getPixels(in: tileLine)

    for pixel in tilePixels {
      let color = pixel == 0 ? " " : String(describing: pixel)
      print(color, separator: "", terminator: "")
    }
    print("|", separator: "", terminator: "")
  }
}
