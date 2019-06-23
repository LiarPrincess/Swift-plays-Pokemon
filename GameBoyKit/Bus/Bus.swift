// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// TODO: Rename to memory (+ whole dir and mode some to IO dir)
public class Bus {

  internal let lcd: Lcd
  internal let timer: Timer
  internal let joypad: Joypad
  internal let cartridge: Cartridge
  internal let serialPort: SerialPort
  internal let interruptEnable: InterruptEnable

  /// C000-CFFF 4KB Work RAM Bank 0 (WRAM)
  /// D000-DFFF 4KB Work RAM Bank 1 (WRAM) (switchable bank 1-7 in CGB Mode)
  internal lazy var ram = {
    return Data(memoryRange: MemoryMap.internalRam)
  }()

  /// FF80-FFFE High RAM (HRAM)
  internal lazy var highRam = {
    return Data(memoryRange: MemoryMap.highRam)
  }()

  /// Catch 'em all for any invalid read/write
  internal var unmappedMemory = [UInt16:UInt8]()

  /// TODO: Catch 'em all for audio read/write
  internal var audio = [UInt16:UInt8]()

  internal init(cartridge: Cartridge, joypad: Joypad, lcd: Lcd, timer: Timer) {
    self.lcd = lcd
    self.timer = timer
    self.joypad = joypad
    self.cartridge = cartridge
    self.serialPort = SerialPort()
    self.interruptEnable = InterruptEnable()
  }

  // MARK: - Helpers

  internal func convertEchoToRamAddress(_ address: UInt16) -> UInt16 {
    return address - 0x2000
  }
}
