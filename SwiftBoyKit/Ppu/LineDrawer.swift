// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

// TODO: Rename (+ property in ppu)
internal class LineDrawer {

  private unowned var memory: PpuMemoryView
  private var lcd: LcdMemory { return self.memory.lcd }
  private var lcdStatus: LcdStatus { return self.lcd.status }
  private var lcdControl: LcdControl { return self.lcd.control }

  internal init(memory: PpuMemoryView) {
    self.memory = memory
  }

  internal func drawBackgroundLine(into data: inout [UInt8]) {
    let map = self.lcdControl.backgroundTileMap

    for pixel in 0..<Display.width {
      let globalX = self.lcd.scrollX + pixel
      let globalY = self.lcd.scrollY + self.lcd.line

      let tileIndexAddress = self.getTileIndexAddress(from: map, globalX: globalX, globalY: globalY)
      let tileIndex = self.memory.read(tileIndexAddress)

      let bytesPerLine: UInt8 = 2
      let lineInsideTile = UInt16((globalY % 8) * bytesPerLine)

      let tileDataAddress = self.getTileDataAddress(tileIndex: tileIndex)
      let data1 = self.memory.read(tileDataAddress + lineInsideTile)
      let data2 = self.memory.read(tileDataAddress + lineInsideTile + 1)

      //      let colorBit = 7 - (xPos % 8)
      //
      //      //int colourNum = BitGetVal(data2,colourBit) ;
      //      //colourNum <<= 1;
      //      //colourNum |= BitGetVal(data1,colourBit) ;
      //
      //      // or this:
    }
  }

  /// Tile index address (means: draw tile from this index)
  private func getTileIndexAddress(from map: TileMap, globalX: UInt8, globalY: UInt8) -> UInt16 {
    let tileRow = globalY / 8
    let tileColumn = globalX / 8

    let tilesPerRow: UInt16 = 32
    let offset = UInt16(tileRow) * tilesPerRow + UInt16(tileColumn)

    switch map {
    case .from9800to9bff: return 0x9800 + offset
    case .from9c00to9fff: return 0x9c00 + offset
    }
  }

  /// Start of the tile in memory
  internal func getTileDataAddress(tileIndex: UInt8) -> UInt16 {
    // internal, so we can test it separatelly (it was hard to write)
    let tileSize: UInt16 = 16

    switch self.lcdControl.tileData {
    case .from8000to8fff:
      let start: UInt16 = 0x8000
      return start + UInt16(tileIndex) * tileSize

    case .from8800to97ff:
      let middle: Int = 0x9000
      let signedTileNumber = Int8(bitPattern: tileIndex)
      return UInt16(middle + Int(signedTileNumber) * Int(tileSize))
    }
  }
}
