// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

public enum WindowTileMap {
  case from9800to9bff
  case from9c00to9fff
}

public enum BackgroundTileMap {
  case from9000to9bff
  case from9c00to9fff
}

public enum TileData {
  case from8800to97ff
  case from8000to8fff
}

public enum SpriteSize {
  case size8x8
  case size8x16
}

public enum LcdMode {

  /// Mode 0: The LCD controller is in the H-Blank period.
  /// CPU can access both the display RAM (8000h-9FFFh) and OAM (FE00h-FE9Fh)
  case hBlank

  /// Mode 1: The LCD contoller is in the V-Blank period (or the display is disabled).
  /// CPU can access both the display RAM (8000h-9FFFh) and OAM (FE00h-FE9Fh)
  case vBlank

  /// Mode 2: The LCD controller is reading from OAM memory.
  /// The CPU <cannot> access OAM memory (FE00h-FE9Fh) during this period.
  case searchingOamRam

  /// Mode 3: The LCD controller is reading from both OAM and VRAM,
  /// The CPU <cannot> access OAM and VRAM during this period.
  case transferingDataToLcdDriver
}

public protocol LcdControl {
  var isLcdEnabled: Bool { get }
  var isWindowEnabled: Bool { get }
  var windowTileMap: WindowTileMap { get }
  var backgroundTileMap: BackgroundTileMap { get }
  var tileData: TileData { get }
  var spriteSize: SpriteSize { get }
  var isSpriteEnabled: Bool { get }
  var isBackgroundVisible: Bool { get }
}

public protocol LcdStatus {
  var mode: LcdMode { get }
}

public class LcdMemory: ContinuousMemoryRegion, LcdControl, LcdStatus {

  public static let start: UInt16 = 0xff40
  public static let end:   UInt16 = 0xff4b

  public var data = [UInt8](repeating: 0, count: LcdMemory.size)

  /// FF42 - SCY - Scroll Y
  public var scrollY: UInt8 { return self.read(globalAddress: 0xff42) }

  /// FF43 - SCX - Scroll X
  public var scrollX: UInt8 { return self.read(globalAddress: 0xff43) }

  /// FF44 - LY - LCDC Y-Coordinate (R)
  public var lineCoordinate: UInt8 { return self.read(globalAddress: 0xff44) }

  /// FF45 - LYC - LY Compare (R/W)
  public var lineCompare: UInt8 { return self.read(globalAddress: 0xff45) }

  /// FF4A - WY - Window Y Position (R/W)
  public var windowY: UInt8 { return self.read(globalAddress: 0xff4a) }

  /// FF4B - WX - Window X Position minus 7 (R/W)
  public var windowX: UInt8 { return self.read(globalAddress: 0xff4b) }

  // MARK: - Lcd control

  /// FF40 - LCDC - LCD Control
  public var control: LcdControl { return self }

  private var controlByte: UInt8 { return self.read(globalAddress: 0xff40) }

  public var isLcdEnabled: Bool {
    let mask: UInt8 = 1 << 7
    return (self.controlByte & mask) == mask
  }

  public var isWindowEnabled: Bool {
    let mask: UInt8 = 1 << 5
    return (self.controlByte & mask) == mask
  }

  public var windowTileMap: WindowTileMap {
    let mask: UInt8 = 1 << 6
    return (self.controlByte & mask) == mask ? .from9800to9bff : .from9c00to9fff
  }

  public var backgroundTileMap: BackgroundTileMap {
    let mask: UInt8 = 1 << 3
    return (self.controlByte & mask) == mask ? .from9000to9bff : .from9c00to9fff
  }

  public var tileData: TileData {
    let mask: UInt8 = 1 << 4
    return (self.controlByte & mask) == mask ? .from8800to97ff : .from8000to8fff
  }

  public var spriteSize: SpriteSize {
    let mask: UInt8 = 1 << 2
    return (self.controlByte & mask) == mask ? .size8x8 : .size8x16
  }

  public var isSpriteEnabled: Bool {
    let mask: UInt8 = 1 << 1
    return (self.controlByte & mask) == mask
  }

  public var isBackgroundVisible: Bool {
    let mask: UInt8 = 1 << 0
    return (self.controlByte & mask) == mask
  }

  // MARK: - Lcd Status

  /// FF41 - STAT - LCDC Status
  public var status: LcdStatus { return self }

  private var statusByte: UInt8 { return self.read(globalAddress: 0xff41) }

  /// (1=Enable) (Read/Write)
  /// LYC=LY Coincidence Interrupt
  //  public var LYC=LY Coincidence Interrupt: Bool {
  //    let mask: UInt8 = 1 << 6
  //    return (self.value & mask) == mask
  //  }

  /// (1=Enable) (Read/Write)
  //  public var Mode 2 OAM Interrupt: Bool {
  //  let mask: UInt8 = 1 << 5
  //  return (self.value & mask) == mask
  //  }

  /// (1=Enable) (Read/Write)
  //  public var Mode 1 V-Blank Interrupt: Bool {
  //  let mask: UInt8 = 1 << 4
  //  return (self.value & mask) == mask
  //  }

  /// (1=Enable) (Read/Write)
  //  public var Mode 0 H-Blank Interrupt: Bool {
  //  let mask: UInt8 = 1 << 3
  //  return (self.value & mask) == mask
  //  }

  /// (0:LYC<>LY, 1:LYC=LY) (Read Only)
  //  public var Coincidence Flag: Bool {
  //    let mask: UInt8 = 1 << 2
  //    return (self.value & mask) == mask
  //  }

  public var mode: LcdMode {
    let mask: UInt8 = 0b11
    switch self.statusByte & mask {
    case 0b00: return .hBlank
    case 0b01: return .vBlank
    case 0b10: return .searchingOamRam
    case 0b11: return .transferingDataToLcdDriver
    default:
      fatalError("Invalid lcd mode value.")
    }
  }

  // MARK: - MemoryRegion

  public func write(globalAddress address: UInt16, value: UInt8) {
    assert(self.contains(globalAddress: address))

    let lineCoordinateAddress: UInt16 = 0xf44
    let newValue = address == lineCoordinateAddress ? 0x00 : value

    let localAddress = self.localAddress(from: address)
    self.data[localAddress] = newValue
  }
}
