// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

/// http://bgb.bircd.org/pandocs.htm#thecartridgeheader
public struct CartridgeRomSize: CustomStringConvertible {

  public static let size32KB = CartridgeRomSize(0x00, "32KB (no ROM banking)", bankCount: 2)
  public static let size64KB = CartridgeRomSize(0x01, "64KB", bankCount: 4)
  public static let size128KB = CartridgeRomSize(0x02, "128KB", bankCount: 8)
  public static let size256KB = CartridgeRomSize(0x03, "256KB", bankCount: 16)
  public static let size512KB = CartridgeRomSize(0x04, "512KB", bankCount: 32)
  public static let size1MB = CartridgeRomSize(0x05, "1MB", bankCount: 64)
  public static let size2MB = CartridgeRomSize(0x06, "2MB", bankCount: 128)
  public static let size4MB = CartridgeRomSize(0x07, "4MB", bankCount: 256)
  public static let size8MB = CartridgeRomSize(0x08, "8MB", bankCount: 512)
  public static let size1_1MB = CartridgeRomSize(0x52, "1.1MB", bankCount: 72)
  public static let size1_2MB = CartridgeRomSize(0x53, "1.2MB", bankCount: 80)
  public static let size1_5MB = CartridgeRomSize(0x54, "1.5MB", bankCount: 96)

  public let headerValue: UInt8
  private let bankCount: Int
  public let description: String

  public var byteCount: Int {
    return self.bankCount * CartridgeConstants.romBankSizeInBytes
  }

  private init(_ headerValue: UInt8, _ description: String, bankCount: Int) {
    self.headerValue = headerValue
    self.bankCount = bankCount
    self.description = description
  }

  // swiftlint:disable:next cyclomatic_complexity
  internal init(headerValue: UInt8) throws {
    switch headerValue {
    case CartridgeRomSize.size32KB.headerValue: self = CartridgeRomSize.size32KB
    case CartridgeRomSize.size64KB.headerValue: self = CartridgeRomSize.size64KB
    case CartridgeRomSize.size128KB.headerValue: self = CartridgeRomSize.size128KB
    case CartridgeRomSize.size256KB.headerValue: self = CartridgeRomSize.size256KB
    case CartridgeRomSize.size512KB.headerValue: self = CartridgeRomSize.size512KB
    case CartridgeRomSize.size1MB.headerValue: self = CartridgeRomSize.size1MB
    case CartridgeRomSize.size2MB.headerValue: self = CartridgeRomSize.size2MB
    case CartridgeRomSize.size4MB.headerValue: self = CartridgeRomSize.size4MB
    case CartridgeRomSize.size8MB.headerValue: self = CartridgeRomSize.size8MB
    case CartridgeRomSize.size1_1MB.headerValue: self = CartridgeRomSize.size1_1MB
    case CartridgeRomSize.size1_2MB.headerValue: self = CartridgeRomSize.size1_2MB
    case CartridgeRomSize.size1_5MB.headerValue: self = CartridgeRomSize.size1_5MB
    default:
      throw CartridgeError.unsupportedRomSize(headerValue)
    }
  }
}
