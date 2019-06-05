// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

/// FE00-FE9F Sprite Attribute Table (OAM)
public class Oam: ContinuousMemoryRegion {

  public static let start: UInt16 = 0xfe00
  public static let end:   UInt16 = 0xfe9f

  public var data = [UInt8](repeating: 0, count: Oam.size)
}
