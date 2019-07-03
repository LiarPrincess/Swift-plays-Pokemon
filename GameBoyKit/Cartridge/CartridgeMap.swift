// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public enum CartridgeMap {
  public static let interruptVectors: ClosedRange<UInt16> = 0x0000...0x00ff
  public static let entryPoint:       ClosedRange<UInt16> = 0x0100...0x0103
  public static let nintendoLogo:     ClosedRange<UInt16> = 0x0104...0x0133

  public static let title:            ClosedRange<UInt16> = 0x0134...0x0143
  public static let manufacturerCode: ClosedRange<UInt16> = 0x013f...0x0142
  public static let destinationCode:  UInt16 = 0x014a
  public static let versionNumber:    UInt16 = 0x014c

  public static let newLicenseeCode:  ClosedRange<UInt16> = 0x0144...0x0145
  public static let oldLicenseeCode:  UInt16 = 0x014b

  public static let cgbFlag: UInt16 = 0x0143
  public static let sgbFlag: UInt16 = 0x0146

  public static let type: UInt16 = 0x0147

  public static let romSize: UInt16 = 0x0148
  public static let ramSize: UInt16 = 0x0149

  public static let headerChecksum: UInt16 = 0x014d
  public static let headerChecksumRange: ClosedRange<UInt16> = 0x0134...0x014d
  public static let globalChecksum:      ClosedRange<UInt16> = 0x014e...0x014f
}
