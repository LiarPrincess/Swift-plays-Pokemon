// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

private let vBlankMask:  UInt8 = 1 << 0
private let lcdStatMask: UInt8 = 1 << 1
private let timerMask:   UInt8 = 1 << 2
private let serialMask:  UInt8 = 1 << 3
private let joypadMask:  UInt8 = 1 << 4

internal enum InterruptType {
  case vBlank
  case lcdStat
  case timer
  case serial
  case joypad
}

/// FF0F Interrupt Flag;
/// FFFF Interrupt Enable
public class Interrupts {

  internal var vBlank  = false
  internal var lcdStat = false
  internal var timer   = false
  internal var serial  = false
  internal var joypad  = false

  internal var isVBlankEnabled  = false
  internal var isLcdStatEnabled = false
  internal var isTimerEnabled   = false
  internal var isSerialEnabled  = false
  internal var isJoypadEnabled  = false

  /// FF0F - IF - Interrupt Flag
  public internal(set) var flag: UInt8 {
    get {
      var result: UInt8 = 0
      result |= self.vBlank  ? vBlankMask  : 0
      result |= self.lcdStat ? lcdStatMask : 0
      result |= self.timer   ? timerMask   : 0
      result |= self.serial  ? serialMask  : 0
      result |= self.joypad  ? joypadMask  : 0
      return result
    }
    set {
      self.vBlank  = (newValue & vBlankMask)  == vBlankMask
      self.lcdStat = (newValue & lcdStatMask) == lcdStatMask
      self.timer   = (newValue & timerMask)   == timerMask
      self.serial  = (newValue & serialMask)  == serialMask
      self.joypad  = (newValue & joypadMask)  == joypadMask
    }
  }

  /// FFFF - IE - Interrupt Enable
  public internal(set) var enable: UInt8 {
    get {
      var result: UInt8 = 0
      result |= self.isVBlankEnabled  ? vBlankMask  : 0
      result |= self.isLcdStatEnabled ? lcdStatMask : 0
      result |= self.isTimerEnabled   ? timerMask   : 0
      result |= self.isSerialEnabled  ? serialMask  : 0
      result |= self.isJoypadEnabled  ? joypadMask  : 0
      return result
    }
    set {
      self.isVBlankEnabled  = (newValue & vBlankMask)  == vBlankMask
      self.isLcdStatEnabled = (newValue & lcdStatMask) == lcdStatMask
      self.isTimerEnabled   = (newValue & timerMask)   == timerMask
      self.isSerialEnabled  = (newValue & serialMask)  == serialMask
      self.isJoypadEnabled  = (newValue & joypadMask)  == joypadMask
    }
  }

  internal func clear(_ type: InterruptType) {
    let mask = getMask(type)
    self.flag &= ~mask
  }
}

private func getMask(_ type: InterruptType) -> UInt8 {
  switch type {
  case .vBlank:  return vBlankMask
  case .lcdStat: return lcdStatMask
  case .timer:   return timerMask
  case .serial:  return serialMask
  case .joypad:  return joypadMask
  }
}
