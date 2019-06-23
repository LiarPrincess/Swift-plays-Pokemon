// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public class Cartridge {

  /// 0000-3FFF 16KB ROM Bank 00 (in cartridge, fixed at bank 00)
  public internal(set) lazy var rom0 = Data(memoryRange: MemoryMap.rom0)

  /// 4000-7FFF 16KB ROM Bank 01..NN (in cartridge, switchable bank number)
  public internal(set) lazy var rom1 = Data(memoryRange: MemoryMap.rom1)

  /// A000-BFFF 8KB External RAM (in cartridge, switchable bank, if any)
  public internal(set) lazy var ram = Data(memoryRange: MemoryMap.externalRam)

/*
  /// 0000-00FF Restart and Interrupt Vectors
  public var interruptVectors: ArraySlice<UInt8> { return self.rom0[0x0000...0x00ff] }

  /// 0100-0103 NOP / JP $0150
  public var code: ArraySlice<UInt8> { return self.rom0[0x0100...0x0103] }

  /// 0104-0133 Nintendo Logo
  public var nintendoLogo: ArraySlice<UInt8> { return self.rom0[0x0104...0x0133] }

  /// 0134-013E Game Title (Uppercase ASCII)
  public var gameTitle: ArraySlice<UInt8> { return self.rom0[0x0134...0x013E] }

  /// 013F-0142 4-byte Game Designation
  public var gameDesignation: ArraySlice<UInt8> { return self.rom0[0x013F...0x0142] }

  /// 0143 Color Compatibility byte
  public var colorCompatibilityByte: UInt8 { return self.rom0[0x0143] }

  /// 0144-0145 New Licensee Code
  public var newLicenseeCode: ArraySlice<UInt8> { return self.rom0[0x0144...0x0145] }

  /// 0146 SGB Compatibility byte
  public var sgbCompatibilityByte: UInt8 { return self.rom0[0x0146] }

  /// 0147 Cart Type
  public var cardType: UInt8 { return self.rom0[0x0147] }

  /// 0148 Cart ROM size
  public var cartRomSize: UInt8 { return self.rom0[0x0148] }

  /// 0149 Cart RAM size
  public var cartRamSize: UInt8 { return self.rom0[0x0149] }

  /// 014A Destination code
  public var destinationSize: UInt8 { return self.rom0[0x014A] }

  /// 014B Old Licensee code
  public var oldLicenseeCode: UInt8 { return self.rom0[0x014B] }

  /// 014C Mask ROM version
  public var maskRomVersion: UInt8 { return self.rom0[0x014C] }

  /// 014D Complement checksum
  public var complementChecksum: UInt8 { return self.rom0[0x014D] }

  /// 014E-014F Checksum
  public var checksum: ArraySlice<UInt8> { return self.rom0[0x014E...0x014F] }
*/
}
