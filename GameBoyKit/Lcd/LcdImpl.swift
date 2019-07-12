// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftlint:disable file_length

import Foundation

private typealias VideoRamMap = MemoryMap.VideoRam

internal class LcdImpl: WritableLcd {

  internal var control: UInt8 = 0 {
    didSet {
      self.clearSpriteCacheIfSpriteSizeChanged(oldControl: oldValue, newControl: self.control)
    }
  }

  internal var status: UInt8 = 0

  internal var scrollY: UInt8 = 0
  internal var scrollX: UInt8 = 0

  internal var line:        UInt8 = 0
  internal var lineCompare: UInt8 = 0

  internal var windowY: UInt8 = 0
  internal var windowX: UInt8 = 0

  internal var _backgroundPalette = BackgroundPalette()
  internal var _spritePalette0 = SpritePalette()
  internal var _spritePalette1 = SpritePalette()

  internal var backgroundPalette: UInt8 {
    get { return self._backgroundPalette.value }
    set { self._backgroundPalette.value = newValue }
  }
  internal var spritePalette0: UInt8 {
    get { return self._spritePalette0.value }
    set { self._spritePalette0.value = newValue }
  }
  internal var spritePalette1: UInt8 {
    get { return self._spritePalette1.value }
    set { self._spritePalette1.value = newValue }
  }

  internal lazy var tileMap9800to9bff = MemoryData.allocate(VideoRamMap.tileMap9800to9bff)
  internal lazy var tileMap9c00to9fff = MemoryData.allocate(VideoRamMap.tileMap9c00to9fff)

  internal lazy var tiles   = (0..<TileConstants.count).map { _ in Tile() }
  internal lazy var sprites = (0..<SpriteConstants.count).map { _ in Sprite() }

  /// Cache, so we don't recalculate sprites on every line draw.
  /// Writes to OAM will clear appropriate entries.
  internal lazy var spritesByLineCache = [Int:[Sprite]]()

  internal lazy var framebuffer: UnsafeMutableBufferPointer<UInt8> = {
    let size = LcdConstants.width * LcdConstants.height
    let result = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: size)
    result.assign(repeating: 0)
    return result
  }()

  /// Number of cycles that elapsed since we started current frame.
  private var frameProgress = 0

  /// We can enable/disable diplay only an the start of the frame.
  /// See: http://bgb.bircd.org/pandocs.htm#lcdcontrolregister
  private var isLcdEnabledInCurrentFrame: Bool = false

  private let interrupts: Interrupts

  internal init(interrupts: Interrupts) {
    self.interrupts = interrupts
  }

  deinit {
    self.tileMap9800to9bff.deallocate()
    self.tileMap9c00to9fff.deallocate()
    self.framebuffer.deallocate()
  }

  // MARK: - Read/write

  internal func readVideoRam(_ address: UInt16) -> UInt8 {
    switch address {

    case VideoRamMap.tileData:
      let relativeAddress = Int(address - VideoRamMap.tileData.start)
      let index = relativeAddress / TileConstants.byteCount
      let byte  = relativeAddress % TileConstants.byteCount

      let tile = self.tiles[index]
      return tile.data[byte]

    case VideoRamMap.tileMap9800to9bff:
      let index = Int(address - VideoRamMap.tileMap9800to9bff.start)
      return self.tileMap9800to9bff[index]

    case VideoRamMap.tileMap9c00to9fff:
      let index = Int(address - VideoRamMap.tileMap9c00to9fff.start)
      return self.tileMap9c00to9fff[index]

    default:
      return 0
    }
  }

  internal func writeVideoRam(_ address: UInt16, value: UInt8) {
    switch address {

    case VideoRamMap.tileData:
      let relativeAddress = Int(address - VideoRamMap.tileData.start)
      let index = relativeAddress / TileConstants.byteCount
      let byte  = relativeAddress % TileConstants.byteCount

      let tile = self.tiles[index]
      tile.setByte(byte, value: value)

    case VideoRamMap.tileMap9800to9bff:
      let index = Int(address - VideoRamMap.tileMap9800to9bff.start)
      self.tileMap9800to9bff[index] = value

    case VideoRamMap.tileMap9c00to9fff:
      let index = Int(address - VideoRamMap.tileMap9c00to9fff.start)
      self.tileMap9c00to9fff[index] = value

    default:
      break
    }
  }

  internal func readOAM(_ address: UInt16) -> UInt8 {
    let oamAddress = Int(address - MemoryMap.oam.start)

    let index = oamAddress / SpriteConstants.byteCount
    let byte  = oamAddress % SpriteConstants.byteCount

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

    let index = oamAddress / SpriteConstants.byteCount
    let byte  = oamAddress % SpriteConstants.byteCount

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
    let height = self.spriteHeight

    let startLine = max(startLine, 0)
    let endLine   = min(startLine + height, LcdConstants.backgroundMapHeight)

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

    let previousMode = self.mode
    self.updateMode()

    // This is not exactly correct, but for perfomance we will
    // draw the whole line at once instead on every tick.
    let hasFinishedTransfer = self.mode != previousMode && previousMode == .pixelTransfer
    if hasFinishedTransfer {
      self.drawLine()
    }
  }

  private func updateFrameProgress(cycles: Int) {
    self.frameProgress += cycles

    if self.frameProgress > LcdConstants.cyclesPerFrame {
      self.frameProgress -= LcdConstants.cyclesPerFrame

      self.isLcdEnabledInCurrentFrame = self.isLcdEnabled
      if !self.isLcdEnabledInCurrentFrame {
        self.line = 0
        self.framebuffer.assign(repeating: 0) // clear
        self.setMode(.hBlank) // 0
      }
    }
  }

  private func updateLine() {
    let previousLine = self.line
    self.line = UInt8(self.frameProgress / LcdConstants.cyclesPerLine)

    if self.line != previousLine {
      let hasInterrupt = self.line == self.lineCompare

      self.setIsLineCompareInterrupt(hasInterrupt)
      if hasInterrupt && self.isLineCompareInterruptEnabled {
        self.interrupts.set(.lcdStat)
      }
    }
  }

  /// Update STAT with new mode (after updating progress).
  /// Will also request any needed interrupt.
  private func updateMode() {
    if self.line >= LcdConstants.height {
      if self.mode != .vBlank {
        self.setMode(.vBlank)
        self.interrupts.set(.vBlank)
        if self.isVBlankInterruptEnabled {
          self.interrupts.set(.lcdStat)
        }
      }
      return
    }

    let lineProgress = self.frameProgress % LcdConstants.cyclesPerLine

    let previousMode = self.mode
    var requestInterrupt = false

    if lineProgress < LcdConstants.oamSearchEnd {
      self.setMode(.oamSearch)
      requestInterrupt = self.isOamInterruptEnabled
    } else if lineProgress < LcdConstants.pixelTransferEnd {
      self.setMode(.pixelTransfer)
    } else {
      self.setMode(.hBlank)
      requestInterrupt = self.isHBlankInterruptEnabled
    }

    if requestInterrupt && self.mode != previousMode {
      self.interrupts.set(.lcdStat)
    }
  }

  // MARK: - Setters

  private func clearSpriteCacheIfSpriteSizeChanged(oldControl: UInt8, newControl: UInt8) {
    let oldSize = oldControl & LcdControlMasks.spriteSize
    let newSize = newControl & LcdControlMasks.spriteSize

    let hasSizeChanged = oldSize != newSize
    if hasSizeChanged {
      self.spritesByLineCache.removeAll(keepingCapacity: true)
    }
  }

  private func setIsLineCompareInterrupt(_ value: Bool) {
    let clear = ~LcdStatusMasks.isLineCompareInterrupt
    var newStatus = self.status & clear

    if value {
      newStatus |= LcdStatusMasks.isLineCompareInterrupt
    }

    self.status = newStatus
  }

  private func setMode(_ mode: LcdMode) {
    let clear = ~LcdStatusMasks.mode
    var newStatus = self.status & clear

    switch mode {
    case .hBlank:        newStatus |= LcdModeValues.hBlank
    case .vBlank:        newStatus |= LcdModeValues.vBlank
    case .oamSearch:     newStatus |= LcdModeValues.oamSearch
    case .pixelTransfer: newStatus |= LcdModeValues.pixelTransfer
    }

    self.status = newStatus
  }
}
