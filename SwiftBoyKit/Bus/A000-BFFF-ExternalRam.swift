// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

/// A000-BFFF 8KB External RAM (in cartridge, switchable bank, if any)
public class ExternalRam: ContinuousMemoryRegion {

  public static let start: UInt16 = 0xa000
  public static let end:   UInt16 = 0xbfff

  public var data = [UInt8](repeating: 0, count: ExternalRam.size)
}
