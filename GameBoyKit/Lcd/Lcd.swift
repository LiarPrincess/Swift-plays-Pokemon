// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

public class Lcd: LcdMemory {

  /// 160 px = 20 tiles
  public static let width = LcdConstants.width

  /// 144 px = 18 tiles
  public static let height = LcdConstants.height

  /// FF40 - LCDC - LCD Control
  public internal(set) var control = LcdControl()

  /// FF41 - STAT - LCDC Status
  public internal(set) var status = LcdStatus()

  /// FF42 - SCY - Scroll Y
  public internal(set) var scrollY: UInt8 = 0

  /// FF43 - SCX - Scroll X
  public internal(set) var scrollX: UInt8 = 0

  /// FF44 - LY - LCDC Y-Coordinate
  public internal(set) var line: UInt8 {
    get { return self.isLcdEnabledInCurrentFrame ?
      UInt8(self.frameProgress / LcdConstants.cyclesPerLine) :
      0
    }
    set { self.frameProgress = 0 }
  }

  /// FF45 - LYC - LY Compare
  public internal(set) var lineCompare: UInt8 = 0

  /// FF4A - WY - Window Y Position
  public internal(set) var windowY: UInt8 = 0

  /// FF4B - WX - Window X Position minus 7
  public internal(set) var windowX: UInt8 = 0

  /// FF47 - BGP - BG Palette Data
  public internal(set) var backgroundColors = BackgroundColorPalette()

  /// FF48 - OBP0 - Object Palette 0 Data
  public internal(set) var objectColors0 = ObjectColorPalette()

  /// FF49 - OBP1 - Object Palette 1 Data
  public internal(set) var objectColors1 = ObjectColorPalette()

  /// 8000-9FFF 8KB Video RAM (VRAM) (switchable bank 0-1 in CGB Mode)
  public internal(set) lazy var videoRam = Data(memoryRange: MemoryMap.videoRam)

  /// FE00-FE9F Sprite Attribute Table (OAM)
  public internal(set) lazy var oam = Data(memoryRange: MemoryMap.oam)

  /// Data that should be put on screen
  public internal(set) var framebuffer = Framebuffer()

  /// Progress in the current frame (in cycles)
  private var frameProgress: Int = 0

  /// We can enable/disable diplay only an the start of the frame.
  /// See: http://bgb.bircd.org/pandocs.htm#lcdcontrolregister
  private var isLcdEnabledInCurrentFrame: Bool = false

  private let interrupts: Interrupts

  internal init(interrupts: Interrupts) {
    self.interrupts = interrupts
  }

  // MARK: - Tick

  internal func startFrame() {
    self.frameProgress = 0
    self.isLcdEnabledInCurrentFrame = self.control.isLcdEnabled
  }

  internal func tick(cycles: Int) {
    self.advanceFrameProgress(cycles: cycles)

    guard self.isLcdEnabledInCurrentFrame else {
      self.framebuffer.clear()
      self.status.mode = .hBlank
      return
    }

    let previousMode = self.status.mode
    self.updateMode()

    let currentMode = self.status.mode
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

      self.status.isLineCompareInterrupt = hasInterrupt
      if hasInterrupt && self.status.isLineCompareInterruptEnabled {
        self.interrupts.lcdStat = true
      }
    }
  }

  /// Update STAT with new mode (after updating progress).
  /// Will also request any needed interrupt.
  private func updateMode() {
    if self.line >= Lcd.height {
      if self.status.mode != .vBlank {
        self.status.mode = .vBlank
        self.interrupts.vBlank = true
        self.interrupts.lcdStat ||= self.status.isVBlankInterruptEnabled
      }
      return
    }

    let lineProgress = self.frameProgress % LcdConstants.cyclesPerLine

    let previousMode = self.status.mode
    var requestInterrupt = false

    // This is not exactly correct, but for perfomance we will
    // draw the whole line at once instead on every tick.
    if lineProgress < LcdConstants.oamSearchEnd {
      self.status.mode = .oamSearch
      requestInterrupt = self.status.isOamInterruptEnabled
    } else if lineProgress < LcdConstants.pixelTransferEnd {
      self.status.mode = .pixelTransfer
    } else {
      self.status.mode = .hBlank
      requestInterrupt = self.status.isHBlankInterruptEnabled
    }

    if requestInterrupt && self.status.mode != previousMode {
      self.interrupts.lcdStat = true
    }
  }
}
