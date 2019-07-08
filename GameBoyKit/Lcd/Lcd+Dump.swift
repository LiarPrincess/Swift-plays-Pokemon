// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftlint:disable function_body_length

private let tileSize        = 8 // pixels
private let tileRowCount    = Int(Lcd.width)  / tileSize // 18
private let tileColumnCount = Int(Lcd.height) / tileSize // 20

// MARK: - Tile indices

extension Lcd {

  internal func dumpBackgroundTileIndices() {
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
    for tileRow in 0..<tileRowCount {
      let rowText = String(describing: tileRow)
      let rowPadding = String(repeating: " ", count: 2 - rowText.count)
      print("\(rowPadding) \(rowText) |", separator: "", terminator: " ")

      for tileColumn in 0..<tileColumnCount {
        let map = self.control.backgroundTileMap
        let tileIndexAddress = self.getTileIndexAddress(from: map, row: tileRow, column: tileColumn)
        let tileIndex        = self.readVideoRam(tileIndexAddress)

        let text = String(tileIndex, radix: 16, uppercase: false)
        let padding = String(repeating: "0", count: 2 - text.count)
        print(padding + text, separator: "", terminator: " ")
      }
      print()
    }
  }

  /// Address (in vram) of a tile index at given row and column.
  private func getTileIndexAddress(from map: TileMap,
                                   row:      Int,
                                   column:   Int) -> Int {
    let start: Int = {
      switch map {
      case .from9800to9bff: return 0x9800
      case .from9c00to9fff: return 0x9c00
      }
    }()

    let tilesPerRow = 32
    let offset = row * tilesPerRow + column

    return start + offset
  }
}

// MARK: - Tile data

extension Lcd {

  internal func dumpTileData() {
    let region = self.control.tileData
    let range = self.range(region: region)

    var address = range.start

    while address < range.end {
      let data1 = self.readVideoRam(address)
      let data2 = self.readVideoRam(address + 1)

      if data1 != 0 || data2 != 0 {
        print("\(UInt16(address).hex): \(data1.bin) & \(data2.bin) -> ", separator: "", terminator: "")
        for i in 0..<8 {
          let color = self.getColorValue(data1, data2, bit: i)
          let sColor = color == 0 ? " " : String(describing: color)
          print(sColor, separator: "", terminator: "")
        }
        print()
      }

      address += 2
    }
  }

  /// Read data from video ram.
  private func readVideoRam(_ address: Int) -> UInt8 {
    let start = Int(MemoryMap.videoRam.start)
    return self.videoRam[address - start]
  }

  private func range(region: TileData) -> ClosedRange<Int> {
    switch region {
    case .from8800to97ff: return 0x8800...0x97ff
    case .from8000to8fff: return 0x8000...0x8fff
    }
  }
}

// MARK: - Background

extension Lcd {

  internal func dumpBackground() {
    //    let rowRange:    ClosedRange<Int> = 8...9
    //    let columnRange: ClosedRange<Int> = 4...5 // 16 for R

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
          self.drawTileLine(tileRow: tileRow, tileColumn: tileColumn, line: tileLine)
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

  private func drawTileLine(tileRow: Int, tileColumn: Int, line: Int) {
    let map = self.control.backgroundTileMap
    let tileIndexAddress = self.getTileIndexAddress(from: map, row: tileRow, column: tileColumn)
    let tileIndex        = self.readVideoRam(tileIndexAddress)

    let bytesPerLine = 2
    let lineInsideTile = line * bytesPerLine

    let tileDataAddress = self.getTileDataAddress(tileIndex: tileIndex)
    let data1 = self.readVideoRam(tileDataAddress + lineInsideTile)
    let data2 = self.readVideoRam(tileDataAddress + lineInsideTile + 1)

    for i in 0..<8 {
      let color = self.getColorValue(data1, data2, bit: i)
      let sColor = color == 0 ? " " : String(describing: color)
      print(sColor, separator: "", terminator: "")
    }
    print("|", separator: "", terminator: "")
  }

  /// Address (in vram) of a tile data.
  /// Can be used as index in self.videoRam.
  private func getTileDataAddress(tileIndex: UInt8) -> Int {
    let tileSize: Int = 16 // bits
    let videoRamStart = Int(MemoryMap.videoRam.start)

    // TODO: there is an trick in binjgb at line 2941
    switch self.control.tileData {
    case .from8000to8fff:
      let start = 0x8000 - videoRamStart
      return start + Int(tileIndex) * tileSize

    case .from8800to97ff:
      let middle = 0x9000 - videoRamStart
      let signedTileNumber = Int8(bitPattern: tileIndex)
      return middle + Int(signedTileNumber) * tileSize
    }
  }
}
