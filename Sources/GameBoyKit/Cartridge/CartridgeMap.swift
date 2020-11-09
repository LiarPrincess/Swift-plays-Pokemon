// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftformat:disable consecutiveSpaces
// swiftformat:disable redundantSelf

internal enum CartridgeMap {
  internal static let interruptVectors: ClosedRange<UInt16> = 0x0000...0x00ff
  internal static let entryPoint:       ClosedRange<UInt16> = 0x0100...0x0103
  internal static let nintendoLogo:     ClosedRange<UInt16> = 0x0104...0x0133

  internal static let newTitle: ClosedRange<UInt16> = 0x0134...0x013f
  internal static let oldTitle: ClosedRange<UInt16> = 0x0134...0x0143

  internal static let manufacturerCode: ClosedRange<UInt16> = 0x013f...0x0142
  internal static let destinationCode:  UInt16 = 0x014a
  internal static let versionNumber:    UInt16 = 0x014c

  internal static let newLicenseeCode:  ClosedRange<UInt16> = 0x0144...0x0145
  internal static let oldLicenseeCode:  UInt16 = 0x014b

  internal static let cgbFlag: UInt16 = 0x0143
  internal static let sgbFlag: UInt16 = 0x0146

  internal static let type: UInt16 = 0x0147

  internal static let romSize: UInt16 = 0x0148
  internal static let ramSize: UInt16 = 0x0149

  internal static let headerChecksum: UInt16 = 0x014d
  internal static let headerChecksumRange: ClosedRange<UInt16> = 0x0134...0x014d
  internal static let globalChecksum:      ClosedRange<UInt16> = 0x014e...0x014f
}
