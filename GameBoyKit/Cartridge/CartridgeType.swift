// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public enum CartridgeType: CustomStringConvertible {
  /** 0x00h */ case romOnly

  /** 0x01h */ case mbc1
  /** 0x02h */ case mbc1Ram
  /** 0x03h */ case mbc1RamBattery

  /** 0x05h */ case mbc2
  /** 0x06h */ case mbc2Battery

  /** 0x08h */ case romRam
  /** 0x09h */ case romRamBattery

  /** 0x0bh */ case mmm01
  /** 0x0ch */ case mmm01Ram
  /** 0x0dh */ case mmm01RamBattery

  /** 0x0fh */ case mbc3TimerBattery
  /** 0x10h */ case mbc3TimerRamBattery
  /** 0x11h */ case mbc3
  /** 0x12h */ case mbc3Ram
  /** 0x13h */ case mbc3RamBattery

  /** 0x15h */ case mbc4
  /** 0x16h */ case mbc4Ram
  /** 0x17h */ case mbc4RamBattery

  /** 0x19h */ case mbc5
  /** 0x1ah */ case mbc5Ram
  /** 0x1bh */ case mbc5RamBattery
  /** 0x1ch */ case mbc5Rumble
  /** 0x1dh */ case mbc5RumbleRam
  /** 0x1eh */ case mbc5RumbleRamBattery

  /** 0xfch */ case pocketCamera
  /** 0xfdh */ case bandaiTama5
  /** 0xfeh */ case huc3
  /** 0xffh */ case huc1RamBattery

  public var description: String {
    switch self {
    case .romOnly: return "ROM only"
    case .mbc1:           return "MBC1"
    case .mbc1Ram:        return "MBC1 +ram"
    case .mbc1RamBattery: return "MBC1 +ram +battery"
    case .mbc2:        return "MBC2"
    case .mbc2Battery: return "MBC2 +battery"
    case .romRam:        return "ROM +ram"
    case .romRamBattery: return "ROM +ram +battery"
    case .mmm01:           return "MMM01"
    case .mmm01Ram:        return "MMM01 +ram"
    case .mmm01RamBattery: return "MMM01 +ram +battery"
    case .mbc3TimerBattery:    return "MBC3 +timer +battery"
    case .mbc3TimerRamBattery: return "MBC3 +timer +ram +battery"
    case .mbc3:           return "MBC3"
    case .mbc3Ram:        return "MBC3 +ram"
    case .mbc3RamBattery: return "MBC3 +ram +battery"
    case .mbc4:           return "MBC4"
    case .mbc4Ram:        return "MBC4 +ram"
    case .mbc4RamBattery: return "MBC4 +ram +battery"
    case .mbc5:                 return "MBC5"
    case .mbc5Ram:              return "MBC5 +ram"
    case .mbc5RamBattery:       return "MBC5 +ram +battery"
    case .mbc5Rumble:           return "MBC5 +rumble"
    case .mbc5RumbleRam:        return "MBC5 +rumble +ram"
    case .mbc5RumbleRamBattery: return "MBC5 +rumble +ram +battery"
    case .pocketCamera: return "POCket camera"
    case .bandaiTama5: return "BANdai tama5"
    case .huc3: return "HUC3"
    case .huc1RamBattery: return "HUC1 +ram +battery"
    }
  }
}
