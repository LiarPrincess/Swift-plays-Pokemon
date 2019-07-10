// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

internal class LcdImpl: WritableLcd {

  internal var control: UInt8 = 0
  internal var status:  UInt8 = 0

  internal var scrollY: UInt8 = 0
  internal var scrollX: UInt8 = 0

  internal var line: UInt8 {
    get { return self.isLcdEnabledInCurrentFrame ?
      UInt8(self.frameProgress / LcdConstants.cyclesPerLine) : 0
    }
    set { self.frameProgress = 0 }
  }

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

  internal lazy var videoRam = MemoryData.allocate(MemoryMap.videoRam)
  internal lazy var sprites  = [Sprite](repeating: Sprite(), count: LcdConstants.spriteCount)

  /// Data that should be put on screen
  internal var framebuffer = Framebuffer()

  /// Progress in the current frame (in cycles)
  private var frameProgress: Int = 0

  /// We can enable/disable diplay only an the start of the frame.
  /// See: http://bgb.bircd.org/pandocs.htm#lcdcontrolregister
  private var isLcdEnabledInCurrentFrame: Bool = false

  private let interrupts: Interrupts

  internal init(interrupts: Interrupts) {
    self.interrupts = interrupts
  }

  deinit {
    self.videoRam.deallocate()
  }

  // MARK: - Read/write

  internal func readVideoRam(_ address: UInt16) -> UInt8 {
    let index = Int(address - MemoryMap.videoRam.start)
    return self.videoRam[index]
  }

  internal func writeVideoRam(_ address: UInt16, value: UInt8) {
    let index = Int(address - MemoryMap.videoRam.start)
    self.videoRam[index] = value
  }

  internal func readOAM(_ address: UInt16) -> UInt8 {
    let oamAddress = Int(address - MemoryMap.oam.start)

    let index = oamAddress / LcdConstants.spriteByteCount
    let byte  = oamAddress % LcdConstants.spriteByteCount

    switch byte {
    case 0: return self.sprites[index].y
    case 1: return self.sprites[index].x
    case 2: return self.sprites[index].tile
    case 3: return self.sprites[index].flags
    default: return 0
    }
  }

  internal func writeOAM(_ address: UInt16, value: UInt8) {
    let oamAddress = Int(address - MemoryMap.oam.start)

    let index = oamAddress / LcdConstants.spriteByteCount
    let byte  = oamAddress % LcdConstants.spriteByteCount

    switch byte {
    case 0: self.sprites[index].y = value
    case 1: self.sprites[index].x = value
    case 2: self.sprites[index].tile = value
    case 3: self.sprites[index].flags = value
    default: break
    }
  }

  // MARK: - Tick

  internal func startFrame() {
    self.frameProgress = 0
    self.isLcdEnabledInCurrentFrame = self.isLcdEnabled
  }

  internal func tick(cycles: Int) {
    self.advanceFrameProgress(cycles: cycles)

    guard self.isLcdEnabledInCurrentFrame else {
      self.framebuffer.clear()
      self.setMode(.hBlank)
      return
    }

    let previousMode = self.mode
    self.updateMode()

    let currentMode = self.mode
    let hasChangedMode = currentMode != previousMode

    let hasFinishedTransfer = hasChangedMode && currentMode == .hBlank
    if hasFinishedTransfer {
      self.drawLine()
    }
  }

  /// Advance progress (possibly moving to new line).
  /// Will also request LYC interrupt if needed.
  private func advanceFrameProgress(cycles: Int) {
    let previousLine = self.line

    self.frameProgress += cycles

    let currentLine = self.line
    if currentLine != previousLine {
      let hasInterrupt = currentLine == self.lineCompare

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

    // This is not exactly correct, but for perfomance we will
    // draw the whole line at once instead on every tick.
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
