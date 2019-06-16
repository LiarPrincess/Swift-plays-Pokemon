// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

public class Memory {

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

  /** FF04          */ internal let divTimer: DivTimer
  /** FF05-FF07     */ internal let appTimer: AppTimer

  /** FF0F-and-FFFF */ internal let interrupts: Interrupts
  /** FF80-FFFE     */ internal let highRam: HighRam

  private lazy var allRegions: [MemoryRegion] = [
    self.rom0, self.rom1,
    self.videoRam, self.externalRam, self.internalRam, self.internalRamEcho,
    self.oam, self.notUsable,
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
    self.internalRam = InternalRam()
    self.internalRamEcho = InternalRamEcho(internalRam: self.internalRam)
    self.oam = Oam()
    self.notUsable = NotUsableMemory()
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
    return self.read(address, callDebug: true)
  }

  internal func read(_ address: UInt16, callDebug: Bool) -> UInt8 {
    guard let region = self.getRegion(forGlobalAddress: address) else {
      fatalError("Attempting to read unsupported memory address: \(address.hex).")
    }

    let value = region.read(globalAddress: address)

    if callDebug {
      Debug.memoryDidRead(from: address, region: region, value: value)
    }

    return value
  }

  // MARK: - Write

  public func write(_ address: UInt16, value: UInt8) {
    self.write(address, value: value, callDebug: true)
  }

  internal func write(_ address: UInt16, value: UInt8, callDebug: Bool) {
    guard address != Memory.dmaAddress else {
      self.dma(writeValue: value)
      return
    }

    guard let region = self.getRegion(forGlobalAddress: address) else {
      fatalError("Attempting to write to unsupported memory address: \(address.hex).")
    }

    region.write(globalAddress: address, value: value)

    if callDebug {
      Debug.memoryDidWrite(to: address, region: region, value: value)
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
