// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public struct TileMap {

  public enum Variant {
    case from9800to9bff
    case from9c00to9fff

    fileprivate var range: ClosedRange<UInt16> {
      switch self {
      case .from9800to9bff:
        return MemoryMap.VideoRam.tileMap9800to9bff
      case .from9c00to9fff:
        return MemoryMap.VideoRam.tileMap9c00to9fff
      }
    }
  }

  private let range: ClosedRange<UInt16>
  private let data: MemoryBuffer

  internal init(variant: Variant) {
    self.range = variant.range
    self.data = MemoryBuffer(region: self.range)
  }

  // MARK: - Read

  internal func read(_ address: UInt16) -> UInt8 {
    let index = address - self.range.start
    return self.data[index]
  }

  // MARK: - Write

  internal func write(_ address: UInt16, value: UInt8) {
    let index = address - self.range.start
    self.data[index] = value
  }

  // MARK: - Subscripts

  subscript(index: Int) -> UInt8 {
    return self.data[index]
  }

  // MARK: - Deallocate

  internal func deallocate() {
    self.data.deallocate()
  }
}
