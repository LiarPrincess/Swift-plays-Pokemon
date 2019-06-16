// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

// TODO: Remove IOPorts and use more specific regions

/// FF00-FF7F I/O Ports
public class IOPorts: ContinuousMemoryRegion {

  public static let start: UInt16 = 0xff00
  public static let end:   UInt16 = 0xff7f

  public var data = [UInt8](repeating: 0, count: IOPorts.size)
}
