// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

/// Normally when drawing the line we would:
/// 1. Iterate over all of the sprites
/// 2. Select the first 10 sprites (*)
/// 3. Draw selected sprites
///
/// Most of the time the sprites do not move between frames, so we can reuse
/// the data from the previous frame. This entity will do just that.
///
/// Of course OAM writes should clean the entries for modified lines.
///
/// (*) http://bgb.bircd.org/pandocs.htm#vramspriteattributetableoam
internal struct SpritesPerLineInPreviousFrame {

  internal typealias SpritesInLine = [Sprite]
  private static let lineCount = Lcd.Constants.backgroundMapHeight

  private var data = [SpritesInLine?](repeating: nil, count: Self.lineCount)

  internal func get(line: Int) -> SpritesInLine? {
    return self.data[line]
  }

  internal mutating func set(line: Int, sprites: SpritesInLine) {
    self.data[line] = sprites
  }

  internal mutating func remove(line: Int) {
    self.data[line] = nil
  }

  internal mutating func removeAll() {
    for line in 0..<Self.lineCount {
      self.remove(line: line)
    }
  }
}
