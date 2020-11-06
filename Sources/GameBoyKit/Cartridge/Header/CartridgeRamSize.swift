// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

/// http://bgb.bircd.org/pandocs.htm#thecartridgeheader
public struct CartridgeRamSize: CustomStringConvertible {

  public static let noRam = CartridgeRamSize(0x00, "noRam", byteCount: 0)
  public static let size2KB = CartridgeRamSize(0x01, "2KB", byteCount: 2_048)
  public static let size8KB = CartridgeRamSize(0x02, "8KB", byteCount: 8_192)
  public static let size32KB = CartridgeRamSize(0x03, "32KB", byteCount: 32_768)
  public static let size128KB = CartridgeRamSize(0x04, "128KB", byteCount: 131_072)
  public static let size64KB = CartridgeRamSize(0x05, "64KB", byteCount: 65_536)

  public let headerValue: UInt8
  public let byteCount: Int
  public let description: String

  private init(_ headerValue: UInt8, _ description: String, byteCount: Int) {
    self.headerValue = headerValue
    self.byteCount = byteCount
    self.description = description
  }

  internal init(headerValue: UInt8) throws {
    switch headerValue {
    case CartridgeRamSize.noRam.headerValue: self = CartridgeRamSize.noRam
    case CartridgeRamSize.size2KB.headerValue: self = CartridgeRamSize.size2KB
    case CartridgeRamSize.size8KB.headerValue: self = CartridgeRamSize.size8KB
    case CartridgeRamSize.size32KB.headerValue: self = CartridgeRamSize.size32KB
    case CartridgeRamSize.size128KB.headerValue: self = CartridgeRamSize.size128KB
    case CartridgeRamSize.size64KB.headerValue: self = CartridgeRamSize.size64KB
    default:
      throw CartridgeError.unsupportedRamSize(headerValue)
    }
  }
}
