// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftlint:disable function_body_length

private let tileSize        = 8 // pixels
private let tileRowCount    = Int(LcdConstants.width)  / tileSize // 18
private let tileColumnCount = Int(LcdConstants.height) / tileSize // 20
private let tilesPerRow = 32

extension LcdImpl {

  // MARK: - Properties

  internal func dumpProperties() {
    print("LCDC: \(self.control.bin)")
    print("isLcdEnabled: \(self.isLcdEnabled)")
    print("isBackgroundVisible: \(self.isBackgroundVisible)")
    print("isWindowEnabled: \(self.isWindowEnabled)")
    print("isSpriteEnabled: \(self.isSpriteEnabled)")
    print("windowTileMap: \(self.windowTileMap)")
    print("backgroundTileMap: \(self.backgroundTileMap)")
    print("tileData: \(self.tileData)")
    print("spriteHeight: \(self.spriteHeight)")

    print("STAT: \(self.status.bin)")
    print("isLineCompareInterruptEnabled: \(self.isLineCompareInterruptEnabled)")
    print("isOamInterruptEnabled: \(self.isOamInterruptEnabled)")
    print("isVBlankInterruptEnabled: \(self.isVBlankInterruptEnabled)")
    print("isHBlankInterruptEnabled: \(self.isHBlankInterruptEnabled)")
    print("isLineCompareInterrupt: \(self.isLineCompareInterrupt)")
    print("mode: \(self.mode)")

    print("scrollY: \(self.scrollY.hex)")
    print("scrollX: \(self.scrollX.hex)")
    print("line: \(self.line.hex)")
    print("lineCompare: \(self.lineCompare.hex)")
    print("windowY: \(self.windowY.hex)")
    print("windowX: \(self.windowX.hex)")
    print("backgroundPalette: \(self.backgroundPalette.hex)")
    print("spritePalette0: \(self.spritePalette0.hex)")
    print("spritePalette1: \(self.spritePalette1.hex)")
  }

  // MARK: - Tile indices

  internal func dumpTileIndices(_ map: TileMap) {
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

  internal func dumpTileData(_ tileData: TileData) {
    let range = self.addressRange(tileData)

    var address = range.start
    while address < range.end {
      let data1 = self.readVideoRam(address)
      let data2 = self.readVideoRam(address + 1)

      print("\(UInt16(address).hex): \(data1.bin) & \(data2.bin) -> ", separator: "", terminator: "")
      for i in 0..<8 {
        let color = self.getColorValue(data1, data2, bit: i)
        let sColor = color == 0 ? " " : String(describing: color)
        print(sColor, separator: "", terminator: "")
      }

      let indexFromStart = (address - range.start) / 2
      let isTileStart = indexFromStart % 8 == 0
      if isTileStart {
        let tileIndex = UInt16(indexFromStart / 8)
        print(" | Starting tile: \(tileIndex.hex)", separator: "", terminator: "")
      }

      print()

      address += 2
    }
  }

  /// Read data from video ram.
  private func readVideoRam(_ address: Int) -> UInt8 {
    let start = Int(MemoryMap.videoRam.start)
    return self.videoRam[address - start]
  }

  private func addressRange(_ data: TileData) -> ClosedRange<Int> {
    switch data {
    case .from8800to97ff: return 0x8800...0x97ff
    case .from8000to8fff: return 0x8000...0x8fff
    }
  }

  // MARK: - Background

  internal func dumpBackground(_ map: TileMap, _ data: TileData) {
    let rowRange:    ClosedRange<Int> = 0...tileRowCount
    let columnRange: ClosedRange<Int> = 0...tileColumnCount

    let linesPerTile = 8

    // horizontal markers
    print(" t  l | " , separator: "", terminator: "")
    for tileColumn in columnRange {
      let text = String(describing: tileColumn)
      let padding = String(repeating: " ", count: 8 - text.count)
      print(padding + text, separator: "", terminator: " ")
    }
    print("|")

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
          self.drawTile(map, data, tileRow: tileRow, tileColumn: tileColumn, line: tileLine)
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

  private func drawTile(_ map: TileMap, _ data: TileData, tileRow: Int, tileColumn: Int, line: Int) {
    let tileMap = self.getTileMap(for: map)
    let tileIndexRaw = tileMap[tileRow * tilesPerRow + tileColumn]

    var tileIndex = Int(tileIndexRaw)
    if data == .from8800to97ff {
      tileIndex = 256 + Int(Int8(bitPattern: tileIndexRaw))
    }

    let bytesPerLine = 2
    let tileAddress = (tileIndex * tileSize + line) * bytesPerLine
    let data1 = self.videoRam[tileAddress]
    let data2 = self.videoRam[tileAddress + 1]

    for i in 0..<8 {
      let color = self.getColorValue(data1, data2, bit: i)
      let sColor = color == 0 ? " " : String(describing: color)
      print(sColor, separator: "", terminator: "")
    }
    print("|", separator: "", terminator: "")
  }
}
