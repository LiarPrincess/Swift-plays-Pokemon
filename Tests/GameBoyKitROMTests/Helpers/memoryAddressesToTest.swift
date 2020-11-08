// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import GameBoyKit

// swiftlint:disable:next closure_body_length
let memoryAddressesToTest: [UInt16] = {
  var result = Set<UInt16>()

  //  MemoryMap.rom0 // no need to check rom
  //  MemoryMap.rom1 // no need to check rom

//  MemoryMap.videoRam.forEach { result.insert($0) } // sometimes you want this
  MemoryMap.externalRam.forEach { result.insert($0) }
  MemoryMap.internalRam.forEach { result.insert($0) }
//  MemoryMap.internalRamEcho // this is the same as ram
//  MemoryMap.oam.forEach { result.insert($0) } // we do dma in 1 single tick
  MemoryMap.notUsable.forEach { result.insert($0) }

//  result.insert(MemoryMap.IO.joypad) // ignore io
//  result.insert(MemoryMap.IO.sb) // not interested
//  result.insert(MemoryMap.IO.sc) // not interested

  result.insert(MemoryMap.IO.unmapBootrom)

//  result.insert(MemoryMap.Timer.div) // bingb starts with 0xac
  result.insert(MemoryMap.Timer.tima)
  result.insert(MemoryMap.Timer.tma)
//  result.insert(MemoryMap.Timer.tac)

  // Audio is not implemented
//  result.insert(MemoryMap.Audio.nr10)
//  result.insert(MemoryMap.Audio.nr11)
//  result.insert(MemoryMap.Audio.nr12)
//  result.insert(MemoryMap.Audio.nr13)
//  result.insert(MemoryMap.Audio.nr14)
//  result.insert(MemoryMap.Audio.nr21)
//  result.insert(MemoryMap.Audio.nr22)
//  result.insert(MemoryMap.Audio.nr23)
//  result.insert(MemoryMap.Audio.nr24)
//  result.insert(MemoryMap.Audio.nr30)
//  result.insert(MemoryMap.Audio.nr31)
//  result.insert(MemoryMap.Audio.nr32)
//  result.insert(MemoryMap.Audio.nr33)
//  result.insert(MemoryMap.Audio.nr34)
//  result.insert(MemoryMap.Audio.nr41)
//  result.insert(MemoryMap.Audio.nr42)
//  result.insert(MemoryMap.Audio.nr43)
//  result.insert(MemoryMap.Audio.nr44)
//  result.insert(MemoryMap.Audio.nr50)
//  result.insert(MemoryMap.Audio.nr51)
//  result.insert(MemoryMap.Audio.nr52)
//  result.insert(MemoryMap.Audio.nr3_ram_start)
//  result.insert(MemoryMap.Audio.nr3_ram_end)

  result.insert(MemoryMap.Lcd.control)
//  result.insert(MemoryMap.Lcd.status) // no idea here
  result.insert(MemoryMap.Lcd.scrollY)
  result.insert(MemoryMap.Lcd.scrollX)
  result.insert(MemoryMap.Lcd.line)
  result.insert(MemoryMap.Lcd.lineCompare)
  result.insert(MemoryMap.Lcd.dma)
  result.insert(MemoryMap.Lcd.backgroundPalette)
  result.insert(MemoryMap.Lcd.spritePalette0)
  result.insert(MemoryMap.Lcd.spritePalette1)
  result.insert(MemoryMap.Lcd.windowY)
  result.insert(MemoryMap.Lcd.windowX)

  MemoryMap.highRam.forEach { result.insert($0) }
  result.insert(MemoryMap.interruptEnable)

  return [UInt16](result).sorted()
}()
