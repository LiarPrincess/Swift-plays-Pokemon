//// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//// If a copy of the MPL was not distributed with this file,
//// You can obtain one at http://mozilla.org/MPL/2.0/.
//
//// swiftlint:disable function_body_length
//
//private let tileRowCount:    UInt8 = 18 // 144 pixels / 8 pixels
//private let tileColumnCount: UInt8 = 20 // 160 pixels / 8 pixels
//
//// MARK: - Tile indices
//
//extension LineDrawer {
//
//  internal func dumpTileIndices(from map: TileMap) {
//    // horizontal markers
//    print("    | " , separator: "", terminator: "")
//    for tileColumn in 0..<tileColumnCount {
//      let text = String(describing: tileColumn)
//      let padding = String(repeating: " ", count: 2 - text.count)
//      print(padding + text, separator: "", terminator: " ")
//    }
//    print()
//
//    print("----+" , separator: "", terminator: "")
//    for _ in 0..<tileColumnCount {
//      print("---", separator: "", terminator: "")
//    }
//    print()
//
//    // data
//    for tileRow in 0..<tileRowCount {
//      let rowText = String(describing: tileRow)
//      let rowPadding = String(repeating: " ", count: 2 - rowText.count)
//      print("\(rowPadding) \(rowText) |", separator: "", terminator: " ")
//
//      for tileColumn in 0..<tileColumnCount {
//        let tileIndexAddress = self.getTileIndexAddress(from: map, tileRow: tileRow, tileColumn: tileColumn)
//        let tileIndex = self.memory.read(tileIndexAddress)
//
//        let text = String(tileIndex, radix: 16, uppercase: false)
//        let padding = String(repeating: "0", count: 2 - text.count)
//        print(padding + text, separator: "", terminator: " ")
//      }
//      print()
//    }
//  }
//}
//
//// MARK: - Tile data
//
//extension LineDrawer {
//
//  internal func dumpTileData(region: TileData) {
//    let range = self.getTileDataRange(region: region)
//
//    var address: UInt16 = range.start
//    while address < range.end {
//      let data1 = self.memory.read(address)
//      let data2 = self.memory.read(address + 1)
//
//      if data1 != 0 || data2 != 0 {
//        print("\(address.hex): \(data1.bin) & \(data2.bin) -> \(data1.hex) & \(data2.hex) -> ", separator: "", terminator: "")
//        for i in 0..<8 {
//          let color = self.getRawColorValue(data1, data2, bitOffset: UInt8(i))
//          let sColor = color == 0 ? " " : String(describing: color)
//          print(sColor, separator: "", terminator: "")
//        }
//        print()
//      }
//
//      address += 2
//    }
//  }
//
//  private typealias TileDataRange = (start: UInt16, end: UInt16)
//
//  private func getTileDataRange(region: TileData) -> TileDataRange {
//    switch  region {
//    case .from8000to8fff: return (start: 0x8000, end: 0x8fff)
//    case .from8800to97ff: return (start: 0x8800, end: 0x97ff)
//    }
//  }
//}
//
//// MARK: - Background
//
//extension LineDrawer {
//
//  internal func dumpBackground() {
////    let rowRange:    ClosedRange<UInt8> = 8...9
////    let columnRange: ClosedRange<UInt8> = 4...5 // 16 for R
//
//    let rowRange:    ClosedRange<UInt8> = 0...tileRowCount
//    let columnRange: ClosedRange<UInt8> = 0...tileColumnCount
//
//    let linesPerTile = 8
//
//    // horizontal markers
//    print(" t  l | " , separator: "", terminator: "")
//    for tileColumn in columnRange {
//      let text = String(describing: tileColumn)
//      let padding = String(repeating: " ", count: 8 - text.count)
//      print(padding + text, separator: "", terminator: " ")
//    }
//    print("|")
//
//    print("------+" , separator: "", terminator: "")
//    for _ in columnRange {
//      print("---------", separator: "", terminator: "")
//    }
//    print("|")
//
//    // data
//    for tileRow in rowRange {
//      for tileLine in 0..<linesPerTile {
//        let tileRowText = String(describing: tileRow)
//        let tileRowPadding = String(repeating: " ", count: 2 - tileRowText.count)
//        print(tileRowPadding + tileRowText, separator: "", terminator: " ")
//
//        let tileLineText = String(describing: tileLine)
//        let tileLinePadding = String(repeating: " ", count: 2 - tileLineText.count)
//        print(tileLinePadding + tileLineText, separator: "", terminator: " ")
//
//        print("|", separator: "", terminator: " ")
//
//        for tileColumn in columnRange {
//          self.drawTileLine(tileRow: tileRow, tileColumn: tileColumn, line: UInt8(tileLine))
//        }
//        print()
//      }
//
//      print("-------" , separator: "", terminator: "")
//      for _ in columnRange {
//        print("---------", separator: "", terminator: "")
//      }
//      print("|")
//    }
//  }
//
//  private func drawTileLine(tileRow: UInt8, tileColumn: UInt8, line: UInt8) {
//    let map = self.lcdControl.backgroundTileMap
//
//    let tileIndexAddress = self.getTileIndexAddress(from: map, tileRow: tileRow, tileColumn: tileColumn)
//    let tileIndex = self.memory.read(tileIndexAddress)
//
//    let bytesPerLine: UInt16 = 2
//    let lineInsideTile = UInt16(line) * bytesPerLine
//
//    let tileDataAddress = self.getTileDataAddress(tileIndex: tileIndex)
//    let data1 = self.memory.read(tileDataAddress + lineInsideTile)
//    let data2 = self.memory.read(tileDataAddress + lineInsideTile + 1)
//
//    for i in 0..<8 {
//      let color = self.getRawColorValue(data1, data2, bitOffset: UInt8(i))
//      let sColor = color == 0 ? " " : String(describing: color)
//      print(sColor, separator: "", terminator: "")
//    }
//    print("|", separator: "", terminator: "")
//  }
//}
