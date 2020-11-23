// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftlint:disable file_length

import Foundation

private typealias VideoRamMap = MemoryMap.VideoRam

public final class Lcd: LcdMemory {

  private var _control = LcdControl(value: 0)
  public internal(set) var control: LcdControl {
    get { return self._control }
    set {
      let oldValue = self._control
      self._control = newValue

      let hasSizeChanged = oldValue.spriteSize != newValue.spriteSize
      if hasSizeChanged {
        self.spritesByLineCache.removeAll(keepingCapacity: true)
      }
    }
  }

  public internal(set) var status = LcdStatus(value: 0)

  public internal(set) var scrollY: UInt8 = 0
  public internal(set) var scrollX: UInt8 = 0

  public internal(set) var line: UInt8 = 0
  public internal(set) var lineCompare: UInt8 = 0

  public internal(set) var windowY: UInt8 = 0
  public internal(set) var windowX: UInt8 = 0

  public internal(set) var backgroundColorPalette = BackgroundColorPalette(value: 0)
  public internal(set) var spriteColorPalette0 = SpriteColorPalette(value: 0)
  public internal(set) var spriteColorPalette1 = SpriteColorPalette(value: 0)

  public internal(set) var tileMap9800to9bff = MemoryBuffer(region: VideoRamMap.tileMap9800to9bff)
  public internal(set) var tileMap9c00to9fff = MemoryBuffer(region: VideoRamMap.tileMap9c00to9fff)

  internal lazy var tiles = (0..<Tile.Constants.count).map { _ in Tile() }
  internal lazy var sprites = (0..<Sprite.Constants.count).map { Sprite(id: $0) }

  /// Cache, so we don't recalculate sprites on every line draw.
  /// Writes to OAM will clear appropriate entries.
  internal lazy var spritesByLineCache = [Int: [Sprite]]()

  /// Data that should be put on screen
  internal lazy var framebuffer = Framebuffer()

  /// Number of cycles that elapsed since we started current frame.
  private var frameProgress = 0

  /// Used when drawing sprites (isBehindBackground property).
  internal var isBackgroundZero = [Bool](repeating: true, count: Constants.width)

  /// We can enable/disable diplay only an the start of the frame.
  /// See: http://bgb.bircd.org/pandocs.htm#lcdcontrolregister
  private var isLcdEnabledInCurrentFrame: Bool = false

  private unowned let interrupts: Interrupts

  internal init(interrupts: Interrupts) {
    self.interrupts = interrupts
  }

  deinit {
    for tile in self.tiles {
      tile.deallocate()
    }

    self.tileMap9800to9bff.deallocate()
    self.tileMap9c00to9fff.deallocate()
    self.framebuffer.deallocate()
  }

  // MARK: - Read/write

  public func readVideoRam(_ address: UInt16) -> UInt8 {
    switch address {

    case VideoRamMap.tileData:
      let relativeAddress = Int(address - VideoRamMap.tileData.start)
      let index = relativeAddress / Tile.Constants.byteCount
      let byte = relativeAddress % Tile.Constants.byteCount

      let tile = self.tiles[index]
      return tile.data[byte]

    case VideoRamMap.tileMap9800to9bff:
      let index = address - VideoRamMap.tileMap9800to9bff.start
      return self.tileMap9800to9bff[index]

    case VideoRamMap.tileMap9c00to9fff:
      let index = address - VideoRamMap.tileMap9c00to9fff.start
      return self.tileMap9c00to9fff[index]

    default:
      return 0
    }
  }

  internal func writeVideoRam(_ address: UInt16, value: UInt8) {
    switch address {

    case VideoRamMap.tileData:
      let relativeAddress = Int(address - VideoRamMap.tileData.start)
      let index = relativeAddress / Tile.Constants.byteCount
      let byte = relativeAddress % Tile.Constants.byteCount

      let tile = self.tiles[index]
      tile.setByte(byte, value: value)

    case VideoRamMap.tileMap9800to9bff:
      let index = address - VideoRamMap.tileMap9800to9bff.start
      self.tileMap9800to9bff[index] = value

    case VideoRamMap.tileMap9c00to9fff:
      let index = address - VideoRamMap.tileMap9c00to9fff.start
      self.tileMap9c00to9fff[index] = value

    default:
      break
    }
  }

  public func readOAM(_ address: UInt16) -> UInt8 {
    let oamAddress = Int(address - MemoryMap.oam.start)

    let index = oamAddress / Sprite.Constants.byteCount
    let byte = oamAddress % Sprite.Constants.byteCount

    let sprite = self.sprites[index]
    switch byte {
    case 0: return sprite.y
    case 1: return sprite.x
    case 2: return sprite.tile
    case 3: return sprite.flags
    default: return 0
    }
  }

  internal func writeOAM(_ address: UInt16, value: UInt8) {
    let oamAddress = Int(address - MemoryMap.oam.start)

    let index = oamAddress / Sprite.Constants.byteCount
    let byte = oamAddress % Sprite.Constants.byteCount

    let sprite = self.sprites[index]
    switch byte {
    case 0:
      if sprite.y != value {
        self.clearSpriteCache(fromLine: sprite.realY)
        sprite.y = value
        self.clearSpriteCache(fromLine: sprite.realY)
      }
    case 1:
      if sprite.x != value {
        sprite.x = value
        self.clearSpriteCache(fromLine: sprite.realY)
      }
    case 2: sprite.tile = value
    case 3: sprite.flags = value
    default: break
    }
  }

  private func clearSpriteCache(fromLine startLine: Int) {
    let height = self.control.spriteHeight

    let startLine = max(startLine, 0)
    let endLine = min(startLine + height, Constants.backgroundMapHeight)

    for line in startLine..<endLine {
      self.spritesByLineCache[line] = nil
    }
  }

  // MARK: - Tick

  internal func tick(cycles: Int) {
    self.updateFrameProgress(cycles: cycles)

    guard self.isLcdEnabledInCurrentFrame else {
      return
    }

    self.updateLine()

    let previousMode = self.status.mode
    self.updateMode()

    // This is not exactly correct, but for perfomance we will
    // draw the whole line at once instead on every tick.
    let hasFinishedTransfer = self.status.mode != previousMode && previousMode == .pixelTransfer
    if hasFinishedTransfer {
      self.drawLine()
    }
  }

  private func updateFrameProgress(cycles: Int) {
    self.frameProgress += cycles

    if self.frameProgress > Constants.cyclesPerFrame {
      self.frameProgress -= Constants.cyclesPerFrame

      self.isLcdEnabledInCurrentFrame = self.control.isLcdEnabled
      if !self.isLcdEnabledInCurrentFrame {
        self.line = 0
        self.framebuffer.clear()
        self.setMode(.hBlank) // 0
      }
    }
  }

  private func updateLine() {
    let previousLine = self.line
    self.line = UInt8(self.frameProgress / Constants.cyclesPerLine)

    if self.line != previousLine {
      let hasInterrupt = self.line == self.lineCompare

      self.setIsLineCompareInterrupt(hasInterrupt)
      if hasInterrupt && self.status.isLineCompareInterruptEnabled {
        self.interrupts.set(.lcdStat)
      }
    }
  }

  /// Update STAT with new mode (after updating progress).
  /// Will also request any needed interrupt.
  private func updateMode() {
    if self.line >= Constants.height {
      if self.status.mode != .vBlank {
        self.setMode(.vBlank)
        self.interrupts.set(.vBlank)

        if self.status.isVBlankInterruptEnabled {
          self.interrupts.set(.lcdStat)
        }
      }
      return
    }

    let lineProgress = self.frameProgress % Constants.cyclesPerLine

    let previousMode = self.status.mode
    var requestInterrupt = false

    if lineProgress < Constants.oamSearchEnd {
      self.setMode(.oamSearch)
      requestInterrupt = self.status.isOamInterruptEnabled
    } else if lineProgress < Constants.pixelTransferEnd {
      self.setMode(.pixelTransfer)
    } else {
      self.setMode(.hBlank)
      requestInterrupt = self.status.isHBlankInterruptEnabled
    }

    if requestInterrupt && self.status.mode != previousMode {
      self.interrupts.set(.lcdStat)
    }
  }

  // MARK: - Setters

  private func setIsLineCompareInterrupt(_ value: Bool) {
    let clear = ~LcdStatus.Masks.isLineCompareInterrupt
    var newStatus = self.status.value & clear

    if value {
      newStatus |= LcdStatus.Masks.isLineCompareInterrupt
    }

    self.status = LcdStatus(value: newStatus)
  }

  private func setMode(_ mode: LcdMode) {
    let clear = ~LcdStatus.Masks.mode
    var newStatus = self.status.value & clear

    switch mode {
    case .hBlank: newStatus |= LcdMode.hBlankValue
    case .vBlank: newStatus |= LcdMode.vBlankValue
    case .oamSearch: newStatus |= LcdMode.oamSearchValue
    case .pixelTransfer: newStatus |= LcdMode.pixelTransferValue
    }

    self.status = LcdStatus(value: newStatus)
  }
}
