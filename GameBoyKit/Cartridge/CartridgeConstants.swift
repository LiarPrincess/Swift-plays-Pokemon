// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

internal enum CartridgeConstants {

  /// Size of single rom bank (16384 bytes).
  internal static let romBankSizeInBytes = 0x4000

  /// Size of single ram bank (8192 bytes).
  internal static let ramBankSizeInBytes = 0x2000

  /// Final value of the bootrom checksum routine.
  internal static let checksumCompare: UInt8 = 0

  /// Value to use if RAM is not present/enabled.
  internal static let defaultRam: UInt8 = 0xff
}
