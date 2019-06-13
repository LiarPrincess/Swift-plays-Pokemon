// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

public class Memory {

  public static let dmaAddress: UInt16 = 0xff46

  /** 0000-3FFF     */ public let rom0: Rom0Memory
  /** 4000-7FFF     */ public let rom1: Rom1Memory

  /** 8000-9FFF     */ public let videoRam: VideoRam
  /** A000-BFFF     */ public let externalRam: ExternalRam
  /** C000-DFFF     */ public let workRam: WorkRam
  /** E000-FDFF     */ public let echo: EchoMemory
  /** FE00-FE9F     */ public let oam: Oam

  /** FF00-FF7F     */ public let ioPorts: IOPorts
  /** FF00          */ public let joypad: JoypadMemory
  /** FF01-FF02     */ public let serialPort: SerialPortMemory
  /** FF40-FF4B     */ public let lcd: LcdMemory

  /** FF04          */ public let divTimer: DivTimer
  /** FF05-FF07     */ public let appTimer: AppTimer

  /** FF0F-and-FFFF */ public let interrupts: Interrupts
  /** FF80-FFFE     */ public let highRam: HighRam

  private lazy var allRegions: [MemoryRegion] = [
    self.rom0, self.rom1,
    self.videoRam, self.externalRam, self.workRam, self.echo, self.oam,
    self.joypad, self.serialPort, self.lcd,
    self.divTimer, self.appTimer,
    self.interrupts, self.highRam,
    self.ioPorts
  ]

  internal init() {
    // If we pass region as init param to another region then it should be stored as 'unowned',
    // not for ARC, but for semantics (memory should be the owner of all regions).
    self.interrupts = Interrupts()
    self.rom0 = Rom0Memory()
    self.rom1 = Rom1Memory()
    self.videoRam = VideoRam()
    self.externalRam = ExternalRam()
    self.workRam = WorkRam()
    self.echo = EchoMemory(workRam: self.workRam)
    self.oam = Oam()
    self.ioPorts = IOPorts()
    self.joypad = JoypadMemory()
    self.serialPort = SerialPortMemory()
    self.lcd = LcdMemory()
    self.divTimer = DivTimer()
    self.appTimer = AppTimer(interrupts: self.interrupts)
    self.highRam = HighRam()
  }

  // MARK: - Read

  public func read(_ address: UInt16) -> UInt8 {
    return self.read(address, debug: true)
  }

  internal func read(_ address: UInt16, debug: Bool) -> UInt8 {
    guard let region = self.getRegion(forGlobalAddress: address) else {
      fatalError("Attempting to read unsupported memory address: \(address.hex).")
    }

    let value = region.read(globalAddress: address)

    if debug {
      Debug.memoryDidRead(self, address: address, value: value)
    }

    return value
  }

  // MARK: - Write

  public func write(_ address: UInt16, value: UInt8) {
    self.write(address, value: value, debug: true)
  }

  internal func write(_ address: UInt16, value: UInt8, debug: Bool) {
    guard address != Memory.dmaAddress else {
      self.dma(writeValue: value)
      return
    }

    guard let region = self.getRegion(forGlobalAddress: address) else {
      fatalError("Attempting to write to unsupported memory address: \(address.hex).")
    }

    region.write(globalAddress: address, value: value)

    if debug {
      Debug.memoryDidWrite(self, address: address, value: value)
    }
  }

  private func getRegion(forGlobalAddress address: UInt16) -> MemoryRegion? {
    return self.allRegions.first { $0.contains(globalAddress: address) }
  }

  // MARK: - DMA

  // TODO: DMA should have separate class (as in Castor C#)
  private func dma(writeValue: UInt8) {
    let sourceAddress = UInt16(writeValue) << 8

    for i in 0..<Oam.size {
      let value = self.read(sourceAddress + i)
      self.write(Oam.start + i, value: value)
    }
  }

  // MARK: - Timers

  internal func updateTimers(cycles: UInt8) {
    self.divTimer.tick(cycles: cycles)
    self.appTimer.tick(cycles: cycles)
  }
}
