// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

/// FF01 and FF02 Serial Data Transfer (Link Cable)
public class SerialPort {

  /// Serial transfer data
  public internal(set) var sb: UInt8 = 0x00

  /// Serial Transfer Control
  public internal(set) var sc: UInt8 = 0x00
}
