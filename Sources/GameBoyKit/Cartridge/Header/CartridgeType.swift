// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// This should be a product (instead of sum), but cartridge type is something
// that we would want to switch over.

/// http://bgb.bircd.org/pandocs.htm#thecartridgeheader
public struct CartridgeType: CustomStringConvertible {

  // swiftlint:disable line_length
  public static let noMBC = CartridgeType(0x00, "no MBC", value: .noMBC(hasRam: false, hasBattery: false))
  public static let noMBCRam = CartridgeType(0x08, "no MBC (+ram)", value: .noMBC(hasRam: true, hasBattery: false))
  public static let noMBCRamBattery = CartridgeType(0x09, "no MBC (+ram +battery)", value: .noMBC(hasRam: true, hasBattery: true))

  public static let mbc1 = CartridgeType(0x01, "MBC1", value: .mbc1(hasRam: false, hasBattery: false))
  public static let mbc1Ram = CartridgeType(0x02, "MBC1 (+ram)", value: .mbc1(hasRam: true, hasBattery: false))
  public static let mbc1RamBattery = CartridgeType(0x03, "MBC1 (+ram +battery)", value: .mbc1(hasRam: true, hasBattery: true))

  public static let mbc2 = CartridgeType(0x05, "MBC2", value: .mbc2(hasBattery: false))
  public static let mbc2Battery = CartridgeType(0x06, "MBC2 (+battery)", value: .mbc2(hasBattery: true))

  public static let mbc3 = CartridgeType(0x11, "MBC3", value: .mbc3(hasRam: false, hasBattery: false, hasRTC: false))
  public static let mbc3Ram = CartridgeType(0x12, "MBC3 (+ram)", value: .mbc3(hasRam: true, hasBattery: false, hasRTC: false))
  public static let mbc3RamBattery = CartridgeType(0x13, "MBC3 (+ram +battery)", value: .mbc3(hasRam: true, hasBattery: true, hasRTC: false))
  public static let mbc3TimerBattery = CartridgeType(0x0f, "MBC3 (+timer +battery)", value: .mbc3(hasRam: false, hasBattery: true, hasRTC: true))
  public static let mbc3TimerRamBattery = CartridgeType(0x10, "MBC3 (+timer +ram +battery)", value: .mbc3(hasRam: true, hasBattery: true, hasRTC: true))

  public static let mbc4 = CartridgeType(0x15, "MBC4", value: .mbc4(hasRam: false, hasBattery: false))
  public static let mbc4Ram = CartridgeType(0x16, "MBC4 (+ram)", value: .mbc4(hasRam: true, hasBattery: false))
  public static let mbc4RamBattery = CartridgeType(0x17, "MBC4 (+ram +battery)", value: .mbc4(hasRam: true, hasBattery: true))

  public static let mbc5 = CartridgeType(0x19, "MBC5", value: .mbc5(hasRam: false, hasBattery: false, hasRumble: false))
  public static let mbc5Ram = CartridgeType(0x1a, "MBC5 (+ram)", value: .mbc5(hasRam: true, hasBattery: false, hasRumble: false))
  public static let mbc5RamBattery = CartridgeType(0x1b, "MBC5 (+ram +battery)", value: .mbc5(hasRam: true, hasBattery: true, hasRumble: false))
  public static let mbc5Rumble = CartridgeType(0x1c, "MBC5 (+rumble)", value: .mbc5(hasRam: false, hasBattery: false, hasRumble: true))
  public static let mbc5RumbleRam = CartridgeType(0x1d, "MBC5 (+rumble +ram)", value: .mbc5(hasRam: true, hasBattery: false, hasRumble: true))
  public static let mbc5RumbleRamBattery = CartridgeType(0x1e, "MBC5 (+rumble +ram +battery)", value: .mbc5(hasRam: true, hasBattery: true, hasRumble: true))

  public static let mbc6 = CartridgeType(0x20, "MBC6", value: .mbc6)
  public static let mbc7 = CartridgeType(0x22, "MBC7", value: .mbc7)
  public static let huc1 = CartridgeType(0xff, "HUC1 (+ram +battery)", value: .huc1)
  public static let huc3 = CartridgeType(0xfe, "HUC3", value: .huc3)
  // swiftlint:enable line_length

  public enum Value {
    case noMBC(hasRam: Bool, hasBattery: Bool)
    case mbc1(hasRam: Bool, hasBattery: Bool)
    case mbc2(hasBattery: Bool)
    case mbc3(hasRam: Bool, hasBattery: Bool, hasRTC: Bool)
    case mbc4(hasRam: Bool, hasBattery: Bool)
    case mbc5(hasRam: Bool, hasBattery: Bool, hasRumble: Bool)
    case mbc6
    case mbc7
    case huc1
    case huc3
  }

  public let headerValue: UInt8
  public let value: Value
  public let description: String

  internal var hasRam: Bool {
    switch self.value {
    case .noMBC(let hasRam, _),
         .mbc1(let hasRam, _),
         .mbc3(let hasRam, _, _),
         .mbc4(let hasRam, _),
         .mbc5(let hasRam, _, _):
      return hasRam
    case .mbc2:
      // From 'mooneye':
      // MBC2 has internal RAM and doesn't use a RAM chip
      return false
    case .mbc6, .mbc7, .huc1, .huc3:
      return false
    }
  }

  private init(_ headerValue: UInt8, _ description: String, value: Value) {
    self.headerValue = headerValue
    self.value = value
    self.description = description
  }

  // swiftlint:disable:next cyclomatic_complexity function_body_length
  internal init(headerValue: UInt8) throws {
    switch headerValue {
    case CartridgeType.noMBC.headerValue: self = CartridgeType.noMBC
    case CartridgeType.noMBCRam.headerValue: self = CartridgeType.noMBCRam
    case CartridgeType.noMBCRamBattery.headerValue: self = CartridgeType.noMBCRamBattery
    case CartridgeType.mbc1.headerValue: self = CartridgeType.mbc1
    case CartridgeType.mbc1Ram.headerValue: self = CartridgeType.mbc1Ram
    case CartridgeType.mbc1RamBattery.headerValue: self = CartridgeType.mbc1RamBattery
    case CartridgeType.mbc2.headerValue: self = CartridgeType.mbc2
    case CartridgeType.mbc2Battery.headerValue: self = CartridgeType.mbc2Battery
    case CartridgeType.mbc3.headerValue: self = CartridgeType.mbc3
    case CartridgeType.mbc3Ram.headerValue: self = CartridgeType.mbc3Ram
    case CartridgeType.mbc3RamBattery.headerValue: self = CartridgeType.mbc3RamBattery
    case CartridgeType.mbc3TimerBattery.headerValue: self = CartridgeType.mbc3TimerBattery
    case CartridgeType.mbc3TimerRamBattery.headerValue: self = CartridgeType.mbc3TimerRamBattery
    case CartridgeType.mbc4.headerValue: self = CartridgeType.mbc4
    case CartridgeType.mbc4Ram.headerValue: self = CartridgeType.mbc4Ram
    case CartridgeType.mbc4RamBattery.headerValue: self = CartridgeType.mbc4RamBattery
    case CartridgeType.mbc5.headerValue: self = CartridgeType.mbc5
    case CartridgeType.mbc5Ram.headerValue: self = CartridgeType.mbc5Ram
    case CartridgeType.mbc5RamBattery.headerValue: self = CartridgeType.mbc5RamBattery
    case CartridgeType.mbc5Rumble.headerValue: self = CartridgeType.mbc5Rumble
    case CartridgeType.mbc5RumbleRam.headerValue: self = CartridgeType.mbc5RumbleRam
    case CartridgeType.mbc5RumbleRamBattery.headerValue: self = CartridgeType.mbc5RumbleRamBattery
    case CartridgeType.mbc6.headerValue: self = CartridgeType.mbc6
    case CartridgeType.mbc7.headerValue: self = CartridgeType.mbc7
    case CartridgeType.huc1.headerValue: self = CartridgeType.huc1
    case CartridgeType.huc3.headerValue: self = CartridgeType.huc3
    default:
      throw CartridgeError.unsupportedType(headerValue)
    }
  }
}
