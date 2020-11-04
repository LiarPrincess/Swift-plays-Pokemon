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

internal class Tile {

  internal lazy var data = MemoryData.allocate(capacity: TileConstants.byteCount)

  private lazy var pixels: UnsafeMutableBufferPointer<UInt8> = {
    let count = TileConstants.width * TileConstants.height
    let result = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: count)
    result.assign(repeating: 0)
    return result
  }()

  deinit {
    self.data.deallocate()
    self.pixels.deallocate()
  }

  internal func setByte(_ byte: Int, value: UInt8) {
    guard self.data[byte] != value else {
      return
    }

    self.data[byte] = value

    // recalculate pixels
    let line = byte / TileConstants.bytesPerLine
    let data1 = self.data[line * TileConstants.bytesPerLine]
    let data2 = self.data[line * TileConstants.bytesPerLine + 1]

    for bit in 0..<TileConstants.width {
      let color = getColorValue(data1, data2, bit: bit)
      let pixelIndex = (line * TileConstants.width) + bit
      self.pixels[pixelIndex] = color
    }
  }

  internal func getPixels(in line: Int) -> UnsafeBufferPointer<UInt8> {
    guard let basePtr = UnsafePointer(self.pixels.baseAddress) else {
      fatalError("Unable to obtain tile pixels address.")
    }

    let start = basePtr.advanced(by: line * TileConstants.width)
    let count = TileConstants.width
    return UnsafeBufferPointer(start: start, count: count)
  }
}

/// Single color encoded in tile.
/// Bit offset is counted from left starting from 0.
private func getColorValue(_ data1:  UInt8,
                           _ data2:  UInt8,
                           bit:      Int) -> UInt8 {
  let shift = 7 - bit
  let data1Bit = (data1 >> shift) & 0x1
  let data2Bit = (data2 >> shift) & 0x1
  return (data2Bit << 1) | data1Bit
}
