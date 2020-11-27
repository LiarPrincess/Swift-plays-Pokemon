// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import GameBoyKit

private let rom0Range = MemoryMap.rom0
private let rom1Range = MemoryMap.rom1
private let ramRange = MemoryMap.externalRam
private let defaultRamValue = CartridgeConstants.defaultRam

class NoMBCTests: CartridgeTestCase {

  // MARK: - Rom

  func test_readRom() throws {
    let cartridge = try self.createCartridge(
      romSize: .size32KB,
      ramSize: .noRam,
      romData: [
        rom0Range.start: 1,
        rom0Range.end: 2,
        rom1Range.start: 3,
        rom1Range.end: 4
      ]
    )

    XCTAssertEqual(cartridge.readRomLowerBank(rom0Range.start), 1)
    XCTAssertEqual(cartridge.readRomLowerBank(rom0Range.end), 2)
    XCTAssertEqual(cartridge.readRomUpperBank(rom1Range.start), 3)
    XCTAssertEqual(cartridge.readRomUpperBank(rom1Range.end), 4)
  }

  func test_writeRom_doesNothing() throws {
    let cartridge = try self.createCartridge(romSize: .size32KB,
                                             ramSize: .noRam)

    // Just check if it does not crash
    cartridge.writeRom(rom0Range.start, value: 1)
    cartridge.writeRom(rom0Range.end, value: 2)
    cartridge.writeRom(rom1Range.start, value: 3)
    cartridge.writeRom(rom1Range.end, value: 4)
  }

  // MARK: - Ram

  func test_readRam_cartridgeWithRam() throws {
    let ramSize = CartridgeRamSize.size8KB
    var cartridge = try self.createCartridge(romSize: .size32KB,
                                             ramSize: ramSize)

    cartridge.ram[0] = 1
    cartridge.ram[ramSize.byteCount - 1] = 5

    XCTAssertEqual(cartridge.readRam(ramRange.start), 1)
    XCTAssertEqual(cartridge.readRam(ramRange.end), 5)
  }

  func test_writeRam_cartridgeWithRam() throws {
    let ramSize = CartridgeRamSize.size8KB
    var cartridge = try self.createCartridge(romSize: .size32KB,
                                             ramSize: ramSize)

    cartridge.writeRam(ramRange.start, value: 1)
    cartridge.writeRam(ramRange.end, value: 5)

    XCTAssertEqual(cartridge.ram[0], 1)
    XCTAssertEqual(cartridge.ram[ramSize.byteCount - 1], 5)
  }

  // MARK: - Ram - no ram in header

  func test_readRam_cartridgeWithoutRam_returnsDefaultValue() throws {
    let cartridge = try self.createCartridge(romSize: .size32KB,
                                             ramSize: .noRam)

    XCTAssertEqual(cartridge.readRam(ramRange.start), defaultRamValue)
    XCTAssertEqual(cartridge.readRam(ramRange.end), defaultRamValue)
  }

  func test_writeRam_cartridgeWithoutRam_doesNothing() throws {
    var cartridge = try self.createCartridge(romSize: .size32KB,
                                             ramSize: .noRam)

    // Just check if it does not crash
    cartridge.writeRam(ramRange.start, value: 1)
    cartridge.writeRam(ramRange.end, value: 2)
  }

  // MARK: - Helpers

  private func createCartridge(romSize: CartridgeRomSize,
                               ramSize: CartridgeRamSize,
                               romData: [UInt16: UInt8] = [:]) throws -> NoMBC
  {
    let type: CartridgeType = ramSize.byteCount == 0 ? .noMBC : .noMBCRam

    var data = self.createRom(title: "ROM",
                              manufacturerCode: "MAN",
                              type: type,
                              destinationCode: .nonJapanese,
                              romSize: romSize,
                              ramSize: ramSize,
                              checksum: 0)

    for (address, value) in romData {
      data[address] = value
    }

    let header = try CartridgeHeader(rom: data, skipChecks: true)
    return NoMBC(header: header, rom: data, ram: nil)
  }
}
