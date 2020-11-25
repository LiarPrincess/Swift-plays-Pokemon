// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

public final class Lcd: LcdMemory {

  public internal(set) var control = LcdControl(value: 0) {
    didSet {
      let newSize = self.control.spriteSize
      self.sprites.onSpriteSizeChanged(newSize: newSize)
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

  // 'internal' because those are implementation details.
  // 'readVideoRam' and 'readOAM' should be used to interact with it.
  internal lazy var tiles = TileData()
  internal lazy var sprites = SpriteCollection(spriteSize: self.control.spriteSize)
  internal lazy var tileMap9800to9bff = TileMap(variant: .from9800to9bff)
  internal lazy var tileMap9c00to9fff = TileMap(variant: .from9c00to9fff)

  /// Used when drawing sprites (isBehindBackground property).
  internal var isBackgroundZero = LcdLineBitArray(initialValue: false)

  /// Data that should be put on screen
  internal lazy var framebuffer = Framebuffer()

  /// Number of cycles that elapsed since we started current frame.
  private var frameProgress = 0

  /// We can enable/disable diplay only an the start of the frame.
  /// See: http://bgb.bircd.org/pandocs.htm#lcdcontrolregister
  private var isLcdEnabledInCurrentFrame: Bool = false

  private unowned let interrupts: Interrupts

  internal init(interrupts: Interrupts) {
    self.interrupts = interrupts
  }

  deinit {
    self.tiles.deallocate()
    self.tileMap9800to9bff.deallocate()
    self.tileMap9c00to9fff.deallocate()
    self.framebuffer.deallocate()
  }

  // MARK: - Read/write

  public func readVideoRam(_ address: UInt16) -> UInt8 {
    switch address {
    case MemoryMap.VideoRam.tileData:
      return self.tiles.read(address)
    case MemoryMap.VideoRam.tileMap9800to9bff:
      return self.tileMap9800to9bff.read(address)
    case MemoryMap.VideoRam.tileMap9c00to9fff:
      return self.tileMap9c00to9fff.read(address)
    default:
      return 0
    }
  }

  internal func writeVideoRam(_ address: UInt16, value: UInt8) {
    switch address {
    case MemoryMap.VideoRam.tileData:
      self.tiles.write(address, value: value)
    case MemoryMap.VideoRam.tileMap9800to9bff:
      self.tileMap9800to9bff.write(address, value: value)
    case MemoryMap.VideoRam.tileMap9c00to9fff:
      self.tileMap9c00to9fff.write(address, value: value)
    default:
      break
    }
  }

  public func readOAM(_ address: UInt16) -> UInt8 {
    self.sprites.read(address)
  }

  internal func writeOAM(_ address: UInt16, value: UInt8) {
    self.sprites.write(address, value: value)
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
    // draw the whole line at once instead of doing this on every tick.
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

    // No 'truncation' will happen
    let lineInt = self.frameProgress / Constants.cyclesPerLine
    self.line = UInt8(truncatingIfNeeded: lineInt)

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
    // In DEBUG mode this conversion would be visible in Instruments
    // (~12% of overal frame time).
    // We will do it just once.
    enum UpdateModeConstants { // swiftlint:disable:this nesting
      static let lcdHeight = UInt8(Lcd.Constants.height)
    }

    if self.line >= UpdateModeConstants.lcdHeight {
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
