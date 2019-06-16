// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

public class Bus {

  public static let dmaAddress: UInt16 = 0xff46

  /** 0000-3FFF     */ internal let rom0: Rom0Memory
  /** 4000-7FFF     */ internal let rom1: Rom1Memory

  /** 8000-9FFF     */ internal let videoRam: VideoRam
  /** A000-BFFF     */ internal let externalRam: ExternalRam
  /** C000-DFFF     */ internal let internalRam: InternalRam
  /** E000-FDFF     */ internal let internalRamEcho: InternalRamEcho
  /** FE00-FE9F     */ internal let oam: Oam
  /** FEA0-FEFF     */ internal let notUsable: NotUsableMemory

  /** FF00-FF7F     */ internal let ioPorts: IOPorts
  /** FF00          */ internal let joypad: JoypadMemory
  /** FF01-FF02     */ internal let serialPort: SerialPortMemory
  /** FF40-FF4B     */ internal let lcd: LcdMemory

  private let timer: Timer
  private let interruptEnable: InterruptEnable

  /** FF80-FFFE     */ internal let highRam: HighRam

  internal init(timer: Timer) {
    // If we pass region as init param to another region then it should be stored as 'unowned',
    // not for ARC, but for semantics (memory should be the owner of all regions).
    self.interruptEnable = InterruptEnable()
    self.rom0 = Rom0Memory()
    self.rom1 = Rom1Memory()
    self.videoRam = VideoRam()
    self.externalRam = ExternalRam()
    self.internalRam = InternalRam()
    self.internalRamEcho = InternalRamEcho(internalRam: self.internalRam)
    self.oam = Oam()
    self.notUsable = NotUsableMemory()
    self.ioPorts = IOPorts()
    self.joypad = JoypadMemory()
    self.serialPort = SerialPortMemory()
    self.lcd = LcdMemory()
    self.timer = timer
    self.highRam = HighRam()
  }

  // MARK: - Read

  public func read(_ address: UInt16) -> UInt8 {
    return self.read(address, callDebug: true)
  }

  internal func read(_ address: UInt16, callDebug: Bool) -> UInt8 {
    return 0
//    guard let region = self.getRegion(forGlobalAddress: address) else {
//      fatalError("Attempting to read unsupported memory address: \(address.hex).")
//    }
//
//    let value = region.read(globalAddress: address)
//
//    if callDebug {
//      Debug.memoryDidRead(from: address, region: region, value: value)
//    }
//
//    return value
  }

  // MARK: - Write

  public func write(_ address: UInt16, value: UInt8) {
    self.write(address, value: value, callDebug: true)
  }

  internal func write(_ address: UInt16, value: UInt8, callDebug: Bool) {
//    guard address != Bus.dmaAddress else {
//      self.dma(writeValue: value)
//      return
//    }
//
//    guard let region = self.getRegion(forGlobalAddress: address) else {
//      fatalError("Attempting to write to unsupported memory address: \(address.hex).")
//    }
//
//    region.write(globalAddress: address, value: value)
//
//    if callDebug {
//      Debug.memoryDidWrite(to: address, region: region, value: value)
//    }
  }

  // MARK: - DMA

  private func dma(writeValue: UInt8) {
    let sourceAddress = UInt16(writeValue) << 8

    // move it to Oam class?
    for i in 0..<Oam.size {
      let value = self.read(sourceAddress + i)
      self.write(Oam.start + i, value: value)
    }
  }

  // MARK: - Interrupts

  func isInterruptRequested(type: InterruptType) -> Bool {
    switch type {
    case .vBlank:  return self.interruptEnable.vBlank  && false
    case .lcdStat: return self.interruptEnable.lcdStat && false
    case .timer:   return self.interruptEnable.timer   && self.timer.hasInterrupt
    case .serial:  return self.interruptEnable.serial  && false
    case .joypad:  return self.interruptEnable.joypad  && false
    }
  }

  func clearInterrupt(type: InterruptType) {
    switch type {
    case .vBlank: break
    case .lcdStat: break
    case .timer: self.timer.clearInterrupt()
    case .serial: break
    case .joypad: break
    }
  }
}
