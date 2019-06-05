// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

/// FF80-FFFE High RAM (HRAM)
public class HighRam: ContinuousMemoryRegion {
  public static let start: UInt16 = 0xff80
  public static let end:   UInt16 = 0xfffe

  public var data = [UInt8](repeating: 0, count: HighRam.size)
}
