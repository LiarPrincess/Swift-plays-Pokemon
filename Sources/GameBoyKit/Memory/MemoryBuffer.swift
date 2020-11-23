// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

/// Data stored in memory
public struct MemoryBuffer {

  internal typealias BufferPointer = UnsafeMutableBufferPointer<UInt8>

  internal let ptr: BufferPointer

  public var isEmpty: Bool {
    return self.ptr.isEmpty
  }

  public var count: Int {
    return self.ptr.count
  }

  internal init(count: Int) {
    self.ptr = BufferPointer.allocate(capacity: count)
    self.ptr.assign(repeating: 0)
  }

  internal init(region: ClosedRange<UInt16>) {
    self.init(count: region.count)
  }

  public internal(set) subscript(address: Int) -> UInt8 {
    get { return self.ptr[address] }
    nonmutating set { self.ptr[address] = newValue }
  }

  public internal(set) subscript(address: UInt16) -> UInt8 {
    get { return self.ptr[Int(address)] }
    nonmutating set { self.ptr[Int(address)] = newValue }
  }

  internal func deallocate() {
    self.ptr.deallocate()
  }
}
