// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftlint:disable type_name

public enum MemoryMap {

  public static let bootrom: ClosedRange<UInt16> = 0x0000...0x00ff

  public static let rom0:            ClosedRange<UInt16> = 0x0000...0x3fff
  public static let rom1:            ClosedRange<UInt16> = 0x4000...0x7fff
  public static let videoRam:        ClosedRange<UInt16> = 0x8000...0x9fff
  public static let externalRam:     ClosedRange<UInt16> = 0xa000...0xbfff
  public static let internalRam:     ClosedRange<UInt16> = 0xc000...0xdfff
  public static let internalRamEcho: ClosedRange<UInt16> = 0xe000...0xfdff
  public static let oam:             ClosedRange<UInt16> = 0xfe00...0xfe9f
  public static let notUsable:       ClosedRange<UInt16> = 0xfea0...0xfeff
  public static let io:              ClosedRange<UInt16> = 0xff00...0xff7f
  public static let highRam:         ClosedRange<UInt16> = 0xff80...0xfffe
  public static let interruptEnable: UInt16 = 0xffff

  public enum IO {
    public static let joypad: UInt16 = 0xff00
    public static let sb:     UInt16 = 0xff01
    public static let sc:     UInt16 = 0xff02
    public static let unmapBootrom:  UInt16 = 0xff50
    public static let interruptFlag: UInt16 = 0xff0f
  }

  public enum Timer {
    public static let div:  UInt16 = 0xff04
    public static let tima: UInt16 = 0xff05
    public static let tma:  UInt16 = 0xff06
    public static let tac:  UInt16 = 0xff07
  }

  public enum Audio {
    public static let nr10:          UInt16 = 0xff10
    public static let nr11:          UInt16 = 0xff11
    public static let nr12:          UInt16 = 0xff12
    public static let nr13:          UInt16 = 0xff13
    public static let nr14:          UInt16 = 0xff14
    public static let nr21:          UInt16 = 0xff16
    public static let nr22:          UInt16 = 0xff17
    public static let nr23:          UInt16 = 0xff18
    public static let nr24:          UInt16 = 0xff19
    public static let nr30:          UInt16 = 0xff1a
    public static let nr31:          UInt16 = 0xff1b
    public static let nr32:          UInt16 = 0xff1c
    public static let nr33:          UInt16 = 0xff1d
    public static let nr34:          UInt16 = 0xff1e
    public static let nr41:          UInt16 = 0xff20
    public static let nr42:          UInt16 = 0xff21
    public static let nr43:          UInt16 = 0xff22
    public static let nr44:          UInt16 = 0xff23
    public static let nr50:          UInt16 = 0xff24
    public static let nr51:          UInt16 = 0xff25
    public static let nr52:          UInt16 = 0xff26
    public static let nr3_ram_start: UInt16 = 0xff30
    public static let nr3_ram_end:   UInt16 = 0xff3f
  }

  public enum Lcd {
    public static let control:          UInt16 = 0xff40
    public static let status:           UInt16 = 0xff41
    public static let scrollY:          UInt16 = 0xff42
    public static let scrollX:          UInt16 = 0xff43
    public static let line:             UInt16 = 0xff44
    public static let lineCompare:      UInt16 = 0xff45
    public static let dma:              UInt16 = 0xff46
    public static let backgroundColors: UInt16 = 0xff47
    public static let objectColors0:    UInt16 = 0xff48
    public static let objectColors1:    UInt16 = 0xff49
    public static let windowY:          UInt16 = 0xff4a
    public static let windowX:          UInt16 = 0xff4b
  }
}

// swiftlint:disable function_body_length cyclomatic_complexity
extension MemoryMap {

  /// Short information about memory region which this address belongs to.
  public static func describe(address: UInt16) -> String {
    switch address {
    case rom0:            return "rom0"
    case rom1:            return "rom1"
    case videoRam:        return "videoRam"
    case externalRam:     return "externalRam"
    case internalRam:     return "internalRam"
    case internalRamEcho: return "internalRamEcho"
    case oam:             return "oam"
    case notUsable:       return "notUsable"
    case io:              return describeIO(address: address)
    case highRam:         return "highRam"
    case interruptEnable: return "interruptEnable"
    default: return "unknown"
    }
  }

  private static func describeIO(address: UInt16) -> String {
    switch address {
    case IO.joypad: return "IO.joypad"
    case IO.sb:     return "IO.sb"
    case IO.sc:     return "IO.sc"
    case IO.unmapBootrom:  return "IO.unmapBootrom"
    case IO.interruptFlag: return "IO.interruptFlag"
    case Timer.div:  return "Timer.div"
    case Timer.tima: return "Timer.tima"
    case Timer.tma:  return "Timer.tma"
    case Timer.tac:  return "Timer.tac"
    case Audio.nr10:          return "Audio.nr10"
    case Audio.nr11:          return "Audio.nr11"
    case Audio.nr12:          return "Audio.nr12"
    case Audio.nr13:          return "Audio.nr13"
    case Audio.nr14:          return "Audio.nr14"
    case Audio.nr21:          return "Audio.nr21"
    case Audio.nr22:          return "Audio.nr22"
    case Audio.nr23:          return "Audio.nr23"
    case Audio.nr24:          return "Audio.nr24"
    case Audio.nr30:          return "Audio.nr30"
    case Audio.nr31:          return "Audio.nr31"
    case Audio.nr32:          return "Audio.nr32"
    case Audio.nr33:          return "Audio.nr33"
    case Audio.nr34:          return "Audio.nr34"
    case Audio.nr41:          return "Audio.nr41"
    case Audio.nr42:          return "Audio.nr42"
    case Audio.nr43:          return "Audio.nr43"
    case Audio.nr44:          return "Audio.nr44"
    case Audio.nr50:          return "Audio.nr50"
    case Audio.nr51:          return "Audio.nr51"
    case Audio.nr52:          return "Audio.nr52"
    case Audio.nr3_ram_start: return "Audio.nr3_ram_start"
    case Audio.nr3_ram_end:   return "Audio.nr3_ram_end"
    case Lcd.control: return "Lcd.control"
    case Lcd.status:  return "Lcd.status"
    case Lcd.scrollY: return "Lcd.scrollY"
    case Lcd.scrollX: return "Lcd.scrollX"
    case Lcd.line:        return "Lcd.line"
    case Lcd.lineCompare: return "Lcd.lineCompare"
    case Lcd.dma:         return "Lcd.dma"
    case Lcd.backgroundColors: return "Lcd.backgroundColors"
    case Lcd.objectColors0:    return "Lcd.objectColors0"
    case Lcd.objectColors1:    return "Lcd.objectColors1"
    case Lcd.windowY: return "Lcd.windowY"
    case Lcd.windowX: return "Lcd.windowX"
    default: return "unknown IO"
    }
  }
}
