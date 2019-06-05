// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

/// 8000-9FFF 8KB Video RAM (VRAM) (switchable bank 0-1 in CGB Mode)
public class VideoRam: ContinuousMemoryRegion {

  public static let start: UInt16 = 0x8000
  public static let end:   UInt16 = 0x9fff

  public var data = [UInt8](repeating: 0, count: VideoRam.size)

  /// 8000-87FF: Tile set #1
  public var tileSet1: ArraySlice<UInt8> { return self.data[0x0000...0x07FF] }

  /// 8800-8FFF: Tile set #1 #2 - shared
  public var tileSet12: ArraySlice<UInt8> { return self.data[0x0800...0x0FFF] }

  /// 9000-97FF: Tile set #2
  public var tileSet2: ArraySlice<UInt8> { return self.data[0x1000...0x17FF] }
}
