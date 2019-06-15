// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

/// 8000-9FFF 8KB Video RAM (VRAM) (switchable bank 0-1 in CGB Mode)
public class VideoRam: ContinuousMemoryRegion {

  public static let start: UInt16 = 0x8000
  public static let end:   UInt16 = 0x9fff

  public var data = [UInt8](repeating: 0, count: VideoRam.size)

  /// 8000-8FFF: Tile set #1
  public var tileSet8000: ArraySlice<UInt8> { return self.data[0x0000...0x0FFF] }

  /// 8800-97FF: Tile set #2
  public var tileSet8800: ArraySlice<UInt8> { return self.data[0x0800...0x17FF] }
}
