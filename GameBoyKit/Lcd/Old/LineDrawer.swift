// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

//internal class LineDrawer {
//
//  internal unowned var memory: PpuMemoryView
//  internal var lcd: LcdMemory { return self.memory.lcd }
//  internal var lcdStatus:  LcdStatus  { return self.lcd.status }
//  internal var lcdControl: LcdControl { return self.lcd.control }
//  internal var videoRam: VideoRam { return self.memory.videoRam }
//
//  internal init(memory: PpuMemoryView) {
//    self.memory = memory
//  }
//
//  internal func drawBackgroundLine(into data: inout [UInt8]) {
//    let map = self.lcdControl.backgroundTileMap
//    let globalY = self.lcd.scrollY + self.lcd.line
//
//    for x in 0..<Screen.width {
//      let globalX = self.lcd.scrollX + x
//
//      let tileIndexAddress = self.getTileIndexAddress(from: map, globalX: globalX, globalY: globalY)
//      let tileIndex = self.memory.read(tileIndexAddress)
//
//      let bytesPerLine: UInt8 = 2
//      let lineInsideTile = UInt16((globalY % 8) * bytesPerLine)
//
//      let tileDataAddress = self.getTileDataAddress(tileIndex: tileIndex)
//      let data1 = self.memory.read(tileDataAddress + lineInsideTile)
//      let data2 = self.memory.read(tileDataAddress + lineInsideTile + 1)
//
//      let colorOffset = globalX % 8
//      let color = self.getRawColorValue(data1, data2, bitOffset: colorOffset)
//    }
//  }
//
//  /// Tile index address (means: draw tile from this index)
//  internal func getTileIndexAddress(from map: TileMap, globalX: UInt8, globalY: UInt8) -> UInt16 {
//    let tileRow = globalY / 8
//    let tileColumn = globalX / 8
//    return self.getTileIndexAddress(from: map, tileRow: tileRow, tileColumn: tileColumn)
//  }
//
//  /// Tile index address (means: draw tile from this index)
//  internal func getTileIndexAddress(from map: TileMap, tileRow: UInt8, tileColumn: UInt8) -> UInt16 {
//    let tilesPerRow: UInt16 = 32
//    let offset = UInt16(tileRow) * tilesPerRow + UInt16(tileColumn)
//
//    switch map {
//    case .from9800to9bff: return 0x9800 + offset
//    case .from9c00to9fff: return 0x9c00 + offset
//    }
//  }
//
//  /// Start of the tile in memory
//  internal func getTileDataAddress(tileIndex: UInt8) -> UInt16 {
//    let tileSize: UInt16 = 16
//
//    switch self.lcdControl.tileData {
//    case .from8000to8fff:
//      let start: UInt16 = 0x8000
//      return start + UInt16(tileIndex) * tileSize
//
//    case .from8800to97ff:
//      let middle: Int = 0x9000
//      let signedTileNumber = Int8(bitPattern: tileIndex)
//      return UInt16(middle + Int(signedTileNumber) * Int(tileSize))
//    }
//  }
//
//  /// Color before applying palette.
//  /// Bit offset is counted from left starting from 0.
//  internal func getRawColorValue(_ data1: UInt8, _ data2: UInt8, bitOffset: UInt8) -> UInt8 {
//    let shift = 7 - bitOffset
//    let data1Bit = (data1 >> shift) & 0x1
//    let data2Bit = (data2 >> shift) & 0x1
//
//    var color: UInt8 = 0
//    color |= data2Bit
//    color <<= 1
//    color |= data1Bit
//    return color
//  }
//}
