// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import GameBoyKit

private let rom0Range = MemoryMap.rom0
private let rom1Range = MemoryMap.rom1
private let ramRange = MemoryMap.externalRam
private let defaultRamValue = CartridgeConstants.defaultRam

class MBC1Tests: CartridgeTestCase {

  // MARK: - Read rom

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

  // MARK: - Write rom - rom bank

  func test_writeRom_selectRomBank() throws {
    let romSize = CartridgeRomSize.size64KB
    let bankSize = UInt16(CartridgeConstants.romBankSizeInBytes)

    var cartridge = try self.createCartridge(
      romSize: romSize,
      ramSize: .noRam,
      romData: [
        rom1Range.start: 1,
        rom1Range.end: 2,
        bankSize + rom1Range.start: 3,
        bankSize + rom1Range.end: 4
      ]
    )

    // By default bank 1 is selected
    XCTAssertEqual(cartridge.readRomUpperBank(rom1Range.start), 1)
    XCTAssertEqual(cartridge.readRomUpperBank(rom1Range.end), 2)

    // Select 2 bank
    cartridge.writeRom(0x3000, value: 2)
    XCTAssertEqual(cartridge.readRomUpperBank(rom1Range.start), 3)
    XCTAssertEqual(cartridge.readRomUpperBank(rom1Range.end), 4)

    // Back to 1st bank (also test if 0 will be replaced by 1)
    cartridge.writeRom(0x3000, value: 0)
    XCTAssertEqual(cartridge.readRomUpperBank(rom1Range.start), 1)
    XCTAssertEqual(cartridge.readRomUpperBank(rom1Range.end), 2)
  }

  // MARK: - Write rom - enable ram

  func test_writeRom_enableRam() throws {
    let ramSize = CartridgeRamSize.size8KB
    var cartridge = try self.createCartridge(romSize: .size32KB,
                                             ramSize: ramSize)

    cartridge.ram[0] = 1
    cartridge.ram[ramSize.byteCount - 1] = 5

    // Ram is disabled by default
    XCTAssertEqual(cartridge.readRam(ramRange.start), defaultRamValue)
    XCTAssertEqual(cartridge.readRam(ramRange.end), defaultRamValue)

    // Enable ram
    self.enableRam(cartridge: &cartridge)
    XCTAssertEqual(cartridge.readRam(ramRange.start), 1)
    XCTAssertEqual(cartridge.readRam(ramRange.end), 5)

    // Disable the ram again
    self.disableRam(cartridge: &cartridge)
    XCTAssertEqual(cartridge.readRam(ramRange.start), defaultRamValue)
    XCTAssertEqual(cartridge.readRam(ramRange.end), defaultRamValue)
  }

  private func enableRam(cartridge: inout MBC1) {
    cartridge.writeRom(0x1000, value: 0xa)
  }

  private func disableRam(cartridge: inout MBC1) {
    cartridge.writeRom(0x1000, value: 0x0)
  }

  // MARK: - Write rom - ram bank

  func test_writeRom_selectRamBank_read() throws {
    let ramSize = CartridgeRamSize.size32KB
    var cartridge = try self.createCartridge(romSize: .size32KB,
                                             ramSize: ramSize)

    let bankSize = CartridgeConstants.ramBankSizeInBytes
    cartridge.ram[0] = 1
    cartridge.ram[bankSize - 1] = 2
    cartridge.ram[bankSize] = 3
    cartridge.ram[bankSize + bankSize - 1] = 4

    // Ram is disabled by default
    self.enableRam(cartridge: &cartridge)

    // By default bank 1 is selected
    XCTAssertEqual(cartridge.readRam(ramRange.start), 1)
    XCTAssertEqual(cartridge.readRam(ramRange.end), 2)

    // Select 2 bank
    self.setRamBank1(cartridge: &cartridge)
    XCTAssertEqual(cartridge.readRam(ramRange.start), 3)
    XCTAssertEqual(cartridge.readRam(ramRange.end), 4)

    // Back to 1st bank (also test if 0 will be replaced by 1)
    self.goBackToRamBank0(cartridge: &cartridge)
    XCTAssertEqual(cartridge.readRam(ramRange.start), 1)
    XCTAssertEqual(cartridge.readRam(ramRange.end), 2)
  }

  // swiftlint:disable:next function_body_length
  func test_writeRom_selectRamBank_write() throws {
    let ramSize = CartridgeRamSize.size32KB
    var cartridge = try self.createCartridge(romSize: .size32KB,
                                             ramSize: ramSize)

    let bankSize = CartridgeConstants.ramBankSizeInBytes
    let bank0StartIndex = 0
    let bank0EndIndex = bankSize - 1
    let bank1StartIndex = bankSize
    let bank1EndIndex = bankSize + bankSize - 1

    // Ram is disabled by default
    self.enableRam(cartridge: &cartridge)

    // By default bank 1 is selected
    cartridge.writeRam(ramRange.start, value: 1)
    cartridge.writeRam(ramRange.end, value: 2)
    XCTAssertEqual(cartridge.ram[bank0StartIndex], 1)
    XCTAssertEqual(cartridge.ram[bank0EndIndex], 2)
    XCTAssertEqual(cartridge.ram[bank1StartIndex], 0)
    XCTAssertEqual(cartridge.ram[bank1EndIndex], 0)

    // Select 2 bank
    self.setRamBank1(cartridge: &cartridge)
    cartridge.writeRam(ramRange.start, value: 3)
    cartridge.writeRam(ramRange.end, value: 4)
    XCTAssertEqual(cartridge.ram[bank0StartIndex], 1)
    XCTAssertEqual(cartridge.ram[bank0EndIndex], 2)
    XCTAssertEqual(cartridge.ram[bank1StartIndex], 3)
    XCTAssertEqual(cartridge.ram[bank1EndIndex], 4)

    // Back to 1st bank (also test if 0 will be replaced by 1)
    self.goBackToRamBank0(cartridge: &cartridge)
    cartridge.writeRam(ramRange.start, value: 5)
    cartridge.writeRam(ramRange.end, value: 6)
    XCTAssertEqual(cartridge.ram[bank0StartIndex], 5)
    XCTAssertEqual(cartridge.ram[bank0EndIndex], 6)
    XCTAssertEqual(cartridge.ram[bank1StartIndex], 3)
    XCTAssertEqual(cartridge.ram[bank1EndIndex], 4)
  }

  private func setRamBank1(cartridge: inout MBC1) {
    cartridge.writeRom(0x5000, value: 1) // bank2 <- 1
    cartridge.writeRom(0x6000, value: 1) // mode <- true
  }

  private func goBackToRamBank0(cartridge: inout MBC1) {
    cartridge.writeRom(0x5000, value: 0)
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
                               romData: [UInt16:UInt8] = [:]) throws -> MBC1 {
    let type: CartridgeType = ramSize.byteCount == 0 ? .mbc1 : .mbc1Ram

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
    return MBC1(header: header, rom: data)
  }
}
