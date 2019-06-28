// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public enum LcdMode: UInt8, RawRepresentable {

  /// Mode 0: The LCD controller is in the H-Blank period.
  /// CPU can access both the display RAM (8000h-9FFFh) and OAM (FE00h-FE9Fh)
  case hBlank = 0b00

  /// Mode 1: The LCD contoller is in the V-Blank period (or the display is disabled).
  /// CPU can access both the display RAM (8000h-9FFFh) and OAM (FE00h-FE9Fh)
  case vBlank = 0b01

  /// Mode 2: The LCD controller is reading from OAM memory.
  /// The CPU <cannot> access OAM memory (FE00h-FE9Fh) during this period.
  case oamSearch = 0b10

  /// Mode 3: The LCD controller is reading from both OAM and VRAM,
  /// The CPU <cannot> access OAM and VRAM during this period.
  case pixelTransfer = 0b11
}
