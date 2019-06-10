// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

// This is AMAZING:
// http://www.codeslinger.co.uk/pages/projects/gameboy/lcd.html

public enum Display {
  public static let width:  UInt8 = 160
  public static let height: UInt8 = 144
}

/// Pixel processing unit
public class Ppu {

  /// How long does it take to draw a line (in cycles)
  private static let lineLength: UInt16 = 456

  /// Length of oam search period (in cycles)
  private static let oamSearchLength: UInt16 = 80

  /// Length of pixel transfer period (in cycles)
  private static let pixelTransferLength: UInt16 = 172

  /// Length of vBlank period (in lines, where 1 line = 'lineLength' cycles)
  private static let vBlankLineCount: UInt8 = 10

  private var lineProgress: UInt16 = 0

  private unowned var memory: PpuMemoryView
  private var lcd: LcdMemory { return self.memory.lcd }
  private var lcdStatus: LcdStatus { return self.lcd.status }
  private var lcdControl: LcdControl { return self.lcd.control }
  private var interrupts: Interrupts { return self.memory.interrupts }

  internal init(memory: PpuMemoryView) {
    self.memory = memory
  }

  // MARK: - Update

  internal func update(cycles: UInt8) {
    self.updateLcdStatus()
    self.requestLineCompareInterruptIfNeeded()

    guard self.lcdControl.isLcdEnabled else {
      return
    }

    self.lineProgress += UInt16(cycles)

    if self.lineProgress >= Ppu.lineLength {
      self.lineProgress -= Ppu.lineLength
      let currentLine = self.lcd.advanceLine()

      if currentLine < Display.height {
        self.drawLine()
      } else if currentLine == Display.height {
        self.interrupts.request(.vBlank)
      } else if currentLine == Display.height + Ppu.vBlankLineCount {
        self.lcd.resetLine()
      }
    }
  }

  private func updateLcdStatus() {
    guard self.lcdControl.isLcdEnabled else {
      // basically go to the beginning
      self.lineProgress = 0
      self.lcd.resetLine()
      self.lcdStatus.mode = .vBlank
      return
    }

    let previousMode = self.lcdStatus.mode
    var requestInterrupt = false

    if self.lcd.line < Display.height {
      if self.lineProgress < Ppu.oamSearchLength {
        self.lcdStatus.mode = .searchingOamRam
        requestInterrupt = self.lcdStatus.isOamInterruptEnabled
      } else if self.lineProgress < Ppu.oamSearchLength + Ppu.pixelTransferLength {
        self.lcdStatus.mode = .pixelTransfer
      } else {
        self.lcdStatus.mode = .hBlank
        requestInterrupt = self.lcdStatus.isHBlankInterruptEnabled
      }
    } else {
      self.lcdStatus.mode = .vBlank
    }

    if requestInterrupt && self.lcdStatus.mode != previousMode {
      self.interrupts.request(.lcdStat)
    }
  }

  private func requestLineCompareInterruptIfNeeded() {
    let isLineEqual = self.lcd.line == self.lcd.lineCompare
    self.lcdStatus.isLineCompareInterrupt = isLineEqual

    if isLineEqual && self.lcdStatus.isLineCompareInterruptEnabled {
      self.interrupts.request(.lcdStat)
    }
  }

  private func drawLine() { }
}
