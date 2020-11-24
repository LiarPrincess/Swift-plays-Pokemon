// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

private let tileDataStartAddress = MemoryMap.VideoRam.tileData.start

public struct TileData {

  public enum Variant {
    case from8800to97ff
    case from8000to8fff
  }

  internal enum Constants {
    /// Total number of tiles (3 * 128)
    internal static let count = 3 * 128
    /// 8 pixels
    internal static let height = 8
    /// 8 pixels
    internal static let width = 8
    /// 1 tile line = 2 bytes
    internal static let bytesPerLine = 2
    /// 1 tile = 16 bytes
    internal static let byteCount = height * bytesPerLine
    /// 1 row (in background map) = 32 tiles
    internal static let tilesPerRow = 32
  }

  private var tiles = (0..<Constants.count).map { _ in Tile() }

  // MARK: - Read

  internal func read(_ address: UInt16) -> UInt8 {
    let relativeAddress = Int(address - tileDataStartAddress)
    let index = relativeAddress / Constants.byteCount
    let byte = relativeAddress % Constants.byteCount

    let tile = self.tiles[index]
    return tile.data[byte]
  }

  // MARK: - Write

  internal func write(_ address: UInt16, value: UInt8) {
    let relativeAddress = Int(address - tileDataStartAddress)
    let index = relativeAddress / Constants.byteCount
    let byte = relativeAddress % Constants.byteCount

    let tile = self.tiles[index]
    tile.setByte(byte, value: value)
  }

  // MARK: - Subscripts

  subscript(index: Int) -> Tile {
    return self.tiles[index]
  }

  subscript(index: Range<Int>) -> ArraySlice<Tile> {
    return self.tiles[index]
  }

  // MARK: - Deallocate

  internal func deallocate() {
    for tile in self.tiles {
      tile.deallocate()
    }
  }
}
