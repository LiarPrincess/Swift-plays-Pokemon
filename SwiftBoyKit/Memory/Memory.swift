// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

public class Memory {

  /* 0000-3FFF */ public let rom0: Rom0Memory
  /* 4000-7FFF */ public let rom1: Rom1Memory

  /* 8000-9FFF */ public let videoRam: VideoRam
  /* A000-BFFF */ public let externalRam: ExternalRam
  /* C000-DFFF */ public let workRam: WorkRam
  /* E000-FDFF */ public let echoMemory: EchoMemory
  /* FE00-FE9F */ public let oam: Oam

  /* FF00-FF7F */ public let ioPorts: IOPorts
  /* FF00      */ public let joypadMemory: JoypadMemory
  /* FF01-FF02 */ public let serialPortMemory: SerialPortMemory
  /* FF04-FF07 */ public let timer: TimerMemory

  /* FF0F-and-FFFF */ public let interruptMemory: InterruptMemory
  /* FF80-FFFE */     public let highRam: HighRam

  private lazy var allRegions: [MemoryRegion] = [
    self.rom0, self.rom1,
    self.videoRam, self.externalRam, self.workRam, self.echoMemory, self.oam,
    self.joypadMemory, self.serialPortMemory, self.timer,
    self.ioPorts, // this must be last (for now)
    self.interruptMemory, self.highRam
  ]

  internal init() {
    self.rom0 = Rom0Memory()
    self.rom1 = Rom1Memory()
    self.videoRam = VideoRam()
    self.externalRam = ExternalRam()
    self.workRam = WorkRam()
    self.echoMemory = EchoMemory(workRam: self.workRam)
    self.oam = Oam()
    self.ioPorts = IOPorts()
    self.joypadMemory = JoypadMemory()
    self.serialPortMemory = SerialPortMemory()
    self.timer = TimerMemory()
    self.interruptMemory = InterruptMemory()
    self.highRam = HighRam()
  }

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

  public func write(_ address: UInt16, value: UInt8) {
    self.write(address, value: value, debug: true)
  }

  internal func write(_ address: UInt16, value: UInt8, debug: Bool) {
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
}
