// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

internal class BusState {

  internal var ram      = Data(memoryRange: MemoryMap.internalRam)
  internal var ioMemory = Data(memoryRange: MemoryMap.io)
  internal var highRam  = Data(memoryRange: MemoryMap.highRam)

  internal var audio          = [UInt16:UInt8]()
  internal var unmappedMemory = [UInt16:UInt8]()
  internal var unmapBootrom: UInt8 = 0
}
