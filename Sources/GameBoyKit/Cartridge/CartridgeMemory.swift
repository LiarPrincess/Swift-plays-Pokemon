// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

internal protocol CartridgeMemory: AnyObject {

  /// 0000-3FFF 16KB ROM Bank 00 (in cartridge, fixed at bank 00);
  func readRomLowerBank(_ address: UInt16) -> UInt8
  /// 4000-7FFF 16KB ROM Bank 01..NN (in cartridge, switchable bank number)
  func readRomUpperBank(_ address: UInt16) -> UInt8
  func writeRom(_ address: UInt16, value: UInt8)

  /// A000-BFFF External RAM (in cartridge, switchable bank, if any)
  func readRam(_ address: UInt16) -> UInt8
  func writeRam(_ address: UInt16, value: UInt8)
}
