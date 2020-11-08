// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

private let zeroFlagMask:      UInt8 = 1 << 7
private let subtractFlagMask:  UInt8 = 1 << 6
private let halfCarryFlagMask: UInt8 = 1 << 5
private let carryFlagMask:     UInt8 = 1 << 4

public struct CpuRegisters {

  // MARK: - Single registers

  /// Accumulator. An 8-bit register for storing data
  /// and the results of arithmetic and logical operations.
  public internal(set) var a: UInt8 = 0

  /// Auxiliary register: B
  public internal(set) var b: UInt8 = 0

  /// Auxiliary register: C
  public internal(set) var c: UInt8 = 0

  /// Auxiliary register: D
  public internal(set) var d: UInt8 = 0

  /// Auxiliary register: E
  public internal(set) var e: UInt8 = 0

  /// Auxiliary register: H
  public internal(set) var h: UInt8 = 0

  /// Auxiliary register: L
  public internal(set) var l: UInt8 = 0

  // MARK: - Flag register

  /// Flag register: F (lower 4 bits are always zero)
  public internal(set) var f: UInt8 {
    get {
      var result: UInt8 = 0
      result |= self.zeroFlag      ? zeroFlagMask      : 0
      result |= self.subtractFlag  ? subtractFlagMask  : 0
      result |= self.halfCarryFlag ? halfCarryFlagMask : 0
      result |= self.carryFlag     ? carryFlagMask     : 0
      return result
    }
    set {
      self.zeroFlag      = isSet(newValue, mask: zeroFlagMask)
      self.subtractFlag  = isSet(newValue, mask: subtractFlagMask)
      self.halfCarryFlag = isSet(newValue, mask: halfCarryFlagMask)
      self.carryFlag     = isSet(newValue, mask: carryFlagMask)
    }
  }

  /// Z: Set to 1 when the result of an operation is 0; otherwise reset.
  public internal(set) var zeroFlag: Bool = false

  /// N: Set to 1 following execution of the
  /// substruction instruction, regardless of the result.
  public internal(set) var subtractFlag: Bool = false

  /// H: Set to 1 when an operation results
  /// in carrying from or borrowing to bit 3.
  public internal(set) var halfCarryFlag: Bool = false

  /// CY: Set to 1 when an operation results
  /// in carrying from or borrowing to bit 7.
  public internal(set) var carryFlag: Bool = false

  // MARK: - Combined registers

  /// Merge of A and F registers.
  public internal(set) var af: UInt16 {
    get { return combine(high: self.a, low: self.f) }
    set { (self.a, self.f) = split(combined: newValue) }
  }

  /// Merge of B and C registers.
  public internal(set) var bc: UInt16 {
    get { return combine(high: self.b, low: self.c) }
    set { (self.b, self.c) = split(combined: newValue) }
  }

  /// Merge of D and E registers.
  public internal(set) var de: UInt16 {
    get { return combine(high: self.d, low: self.e) }
    set { (self.d, self.e) = split(combined: newValue) }
  }

  /// Merge of H and L registers.
  public internal(set) var hl: UInt16 {
    get { return combine(high: self.h, low: self.l) }
    set { (self.h, self.l) = split(combined: newValue) }
  }

  // MARK: - Addressing

  /// Names of all of the flag registers
  public enum Flag {
    case zeroFlag
    case subtractFlag
    case halfCarryFlag
    case carryFlag
  }

  /// Names of all of the single registers
  public enum Single {
    case a
    case b
    case c
    case d
    case e
    case f
    case h
    case l
  }

  /// Names of all of the combined registers
  public enum Combined {
    case af
    case bc
    case de
    case hl
  }

  public func get(_ f: Flag) -> Bool {
    switch f {
    case .zeroFlag:      return self.zeroFlag
    case .subtractFlag:  return self.subtractFlag
    case .halfCarryFlag: return self.halfCarryFlag
    case .carryFlag:     return self.carryFlag
    }
  }

  public func get(_ r: Single) -> UInt8 {
    switch r {
    case .a: return self.a
    case .b: return self.b
    case .c: return self.c
    case .d: return self.d
    case .e: return self.e
    case .f: return self.f
    case .h: return self.h
    case .l: return self.l
    }
  }

  public func get(_ rr: Combined) -> UInt16 {
    switch rr {
    case .af: return self.af
    case .bc: return self.bc
    case .de: return self.de
    case .hl: return self.hl
    }
  }

  internal mutating func set(_ f: Flag, to value: Bool) {
    switch f {
    case .zeroFlag:      self.zeroFlag      = value
    case .subtractFlag:  self.subtractFlag  = value
    case .halfCarryFlag: self.halfCarryFlag = value
    case .carryFlag:     self.carryFlag     = value
    }
  }

  internal mutating func set(_ r: Single, to value: UInt8) {
    switch r {
    case .a: self.a = value
    case .b: self.b = value
    case .c: self.c = value
    case .d: self.d = value
    case .e: self.e = value
    case .f: self.f = value
    case .h: self.h = value
    case .l: self.l = value
    }
  }

  internal mutating func set(_ rr: Combined, to value: UInt16) {
    switch rr {
    case .af: self.af = value
    case .bc: self.bc = value
    case .de: self.de = value
    case .hl: self.hl = value
    }
  }
}

private func combine(high: UInt8, low: UInt8) -> UInt16 {
  return (UInt16(high) << 8) | UInt16(low)
}

private func split(combined: UInt16) -> (high: UInt8, low: UInt8) {
  let high = UInt8((combined & 0xff00) >> 8)
  let low  = UInt8(combined & 0xff)
  return (high, low)
}

private func isSet(_ value: UInt8, mask: UInt8) -> Bool {
  return (value & mask) == mask
}
