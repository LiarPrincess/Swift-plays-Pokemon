// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

public enum MemoryMap {

  public static let rom0:            ClosedRange<UInt16> = 0x0000...0x3fff
  public static let rom1:            ClosedRange<UInt16> = 0x4000...0x7fff
  public static let videoRam:        ClosedRange<UInt16> = 0x8000...0x9fff
  public static let externalRam:     ClosedRange<UInt16> = 0xa000...0xbfff
  public static let internalRam:     ClosedRange<UInt16> = 0xc000...0xdfff
  public static let internalRamEcho: ClosedRange<UInt16> = 0xe000...0xfdff
  public static let oam:             ClosedRange<UInt16> = 0xfe00...0xfe9f
  public static let notUsable:       ClosedRange<UInt16> = 0xfea0...0xfeff
  public static let io:              ClosedRange<UInt16> = 0xff00...0xff4b
  public static let unmapBootrom:    UInt16 = 0xff50
  public static let highRam:         ClosedRange<UInt16> = 0xff80...0xfffe
  public static let interruptEnable: UInt16 = 0xffff

  public enum IO {

    public static let joypad: UInt16 = 0xff00
    public static let sb:     UInt16 = 0xff01
    public static let sc:     UInt16 = 0xff02

    public static let div:  UInt16 = 0xff04
    public static let tima: UInt16 = 0xff05
    public static let tma:  UInt16 = 0xff06
    public static let tac:  UInt16 = 0xff07

    public static let interruptFlag: UInt16 = 0xff0f

    //    public static let nr10:          UInt16 = 0x10
    //    public static let nr11:          UInt16 = 0x11
    //    public static let nr12:          UInt16 = 0x12
    //    public static let nr13:          UInt16 = 0x13
    //    public static let nr14:          UInt16 = 0x14
    //    public static let nr21:          UInt16 = 0x16
    //    public static let nr22:          UInt16 = 0x17
    //    public static let nr23:          UInt16 = 0x18
    //    public static let nr24:          UInt16 = 0x19
    //    public static let nr30:          UInt16 = 0x1a
    //    public static let nr31:          UInt16 = 0x1b
    //    public static let nr32:          UInt16 = 0x1c
    //    public static let nr33:          UInt16 = 0x1d
    //    public static let nr34:          UInt16 = 0x1e
    //    public static let nr41:          UInt16 = 0x20
    //    public static let nr42:          UInt16 = 0x21
    //    public static let nr43:          UInt16 = 0x22
    //    public static let nr44:          UInt16 = 0x23
    //    public static let nr50:          UInt16 = 0x24
    //    public static let nr51:          UInt16 = 0x25
    //    public static let nr52:          UInt16 = 0x26
    //    public static let nr3_ram_start: UInt16 = 0x30
    //    public static let nr3_ram_end:   UInt16 = 0x3f

    public static let lcdControl:           UInt16 = 0xff40
    public static let lcdStatus:            UInt16 = 0xff41
    public static let lcdScrollY:           UInt16 = 0xff42
    public static let lcdScrollX:           UInt16 = 0xff43
    public static let lcdLine:              UInt16 = 0xff44
    public static let lcdLineCompare:       UInt16 = 0xff45
    public static let dma:                  UInt16 = 0xff46
    public static let lcdBackgroundPalette: UInt16 = 0xff47
    public static let lcdObjectPalette0:    UInt16 = 0xff48
    public static let lcdObjectPalette1:    UInt16 = 0xff49
    public static let lcdWindowY:           UInt16 = 0xff4a
    public static let lcdWindowX:           UInt16 = 0xff4b
  }
}
