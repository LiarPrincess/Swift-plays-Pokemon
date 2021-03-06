// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

//  byte | line |        | byte +1
// ------+------+--------+--------
//      0|     0|00000000|00000000
//      2|     1|00000000|00000000
//      4|     2|00000000|00000000
//      6|     3|00000000|00000000
//      8|     4|00000000|00000000
//     10|     5|00000000|00000000
//     12|     6|00000000|00000000
//     14|     7|00000000|00000000

internal struct Tile {

  internal typealias Constants = TileData.Constants

  internal let data = MemoryBuffer(count: Constants.byteCount)
  // Processed `self.data`
  private let pixels = MemoryBuffer(count: Constants.width * Constants.height)

  internal func deallocate() {
    self.data.deallocate()
    self.pixels.deallocate()
  }

  internal func setByte(_ byte: Int, value: UInt8) {
    guard self.data[byte] != value else {
      return
    }

    self.data[byte] = value

    // Recalculate pixels
    let line = byte / Constants.bytesPerLine
    let data1 = self.data[line * Constants.bytesPerLine]
    let data2 = self.data[line * Constants.bytesPerLine + 1]

    for bit in 0..<Constants.width {
      let color = Self.getColorValue(data1, data2, bit: bit)
      let pixelIndex = (line * Constants.width) + bit
      self.pixels[pixelIndex] = color
    }
  }

  internal func getPixels(in line: Int) -> UnsafeBufferPointer<UInt8> {
    guard let basePtr = UnsafePointer(self.pixels.ptr.baseAddress) else {
      fatalError("Unable to obtain tile pixels address.")
    }

    let start = basePtr.advanced(by: line * Constants.width)
    return UnsafeBufferPointer(start: start, count: Constants.width)
  }

  /// Single color encoded in tile.
  /// Bit offset is counted from left starting from 0.
  internal static func getColorValue(_ data1: UInt8,
                                     _ data2: UInt8,
                                     bit: Int) -> UInt8
  {
    let shift = 7 - bit
    let data1Bit = (data1 >> shift) & 0x1
    let data2Bit = (data2 >> shift) & 0x1
    return (data2Bit << 1) | data1Bit
  }
}
