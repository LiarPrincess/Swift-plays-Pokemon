// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

private let zeroFlagPosition:      UInt16 = 7
private let subtractFlagPosition:  UInt16 = 6
private let halfCarryFlagPosition: UInt16 = 5
private let carryFlagPosition:     UInt16 = 4

public enum FlagRegister {
  case zeroFlag
  case subtractFlag
  case halfCarryFlag
  case carryFlag
}

public enum SingleRegister {
  case a
  case b
  case c
  case d
  case e
  case h
  case l
}

public enum CombinedRegister {
  case af
  case bc
  case de
  case hl
}

public class Registers {

  /// Accumulator: A
  /// An 8-bit register for storing data and the results of arithmetic and logical operations.
  public var a: UInt8 = 0 { didSet { Debug.registersDidSet(.a) } }

  /// Auxiliary register: B
  public var b: UInt8 = 0 { didSet { Debug.registersDidSet(.b) } }

  /// Auxiliary register: C
  public var c: UInt8 = 0 { didSet { Debug.registersDidSet(.c) } }

  /// Auxiliary register: D
  public var d: UInt8 = 0 { didSet { Debug.registersDidSet(.d) } }

  /// Auxiliary register: E
  public var e: UInt8 = 0 { didSet { Debug.registersDidSet(.e) } }

  /// Auxiliary register: H
  public var h: UInt8 = 0 { didSet { Debug.registersDidSet(.h) } }

  /// Auxiliary register: L
  public var l: UInt8 = 0 { didSet { Debug.registersDidSet(.l) } }

  /// Z: Set to 1 when the result of an operation is 0; otherwise reset.
  public var zeroFlag: Bool = false { didSet { Debug.registersDidSet(.zeroFlag) } }

  /// N: Set to 1 following execution of the substruction instruction, regardless of the result.
  public var subtractFlag: Bool = false { didSet { Debug.registersDidSet(.subtractFlag) } }

  /// H: Set to 1 when an operation results in carrying from or borrowing to bit 3.
  public var halfCarryFlag: Bool = false { didSet { Debug.registersDidSet(.halfCarryFlag) } }

  /// CY: Set to 1 when an operation results in carrying from or borrowing to bit 7.
  public var carryFlag: Bool = false { didSet { Debug.registersDidSet(.carryFlag) } }

  // MARK: - Combined registers

  public var bc: UInt16 {
    get { return (UInt16(self.b) << 8) | UInt16(self.c) }
    set {
      self.b = UInt8((newValue & 0xff00) >> 8)
      self.c = UInt8(newValue & 0xff)
      Debug.registersDidSet(.bc)
    }
  }

  public var de: UInt16 {
    get { return (UInt16(self.d) << 8) | UInt16(self.e) }
    set {
      self.d = UInt8((newValue & 0xff00) >> 8)
      self.e = UInt8(newValue & 0xff)
      Debug.registersDidSet(.de)
    }
  }

  public var hl: UInt16 {
    get { return (UInt16(self.h) << 8) | UInt16(self.l) }
    set {
      self.h = UInt8((newValue & 0xff00) >> 8)
      self.l = UInt8(newValue & 0xff)
      Debug.registersDidSet(.hl)
    }
  }

  // MARK: - Addressing

  public func get(_ f: FlagRegister) -> Bool {
    switch f {
    case .zeroFlag:      return self.zeroFlag
    case .subtractFlag:  return self.subtractFlag
    case .halfCarryFlag: return self.halfCarryFlag
    case .carryFlag:     return self.carryFlag
    }
  }

  public func get(_ r: SingleRegister) -> UInt8 {
    switch r {
    case .a: return self.a
    case .b: return self.b
    case .c: return self.c
    case .d: return self.d
    case .e: return self.e
    case .h: return self.h
    case .l: return self.l
    }
  }

  public func get(_ r: CombinedRegister) -> UInt16 {
    switch r {
    case .af:
      var result: UInt16 = 0
      result += self.zeroFlag      ? (1 << zeroFlagPosition)      : 0
      result += self.subtractFlag  ? (1 << subtractFlagPosition)  : 0
      result += self.halfCarryFlag ? (1 << halfCarryFlagPosition) : 0
      result += self.carryFlag     ? (1 << carryFlagPosition)     : 0
      return result
    case .bc: return self.bc
    case .de: return self.de
    case .hl: return self.hl
    }
  }

  public func set(_ r: SingleRegister, to value: UInt8) {
    switch r {
    case .a: self.a = value
    case .b: self.b = value
    case .c: self.c = value
    case .d: self.d = value
    case .e: self.e = value
    case .h: self.h = value
    case .l: self.l = value
    }
  }

  public func set(_ r: CombinedRegister, to value: UInt16) {
    switch r {
    case .af:
      self.a = UInt8((value & 0xff00) >> 8)

      let f = UInt16(value & 0xff)
      self.zeroFlag      = (f & zeroFlagPosition)      == zeroFlagPosition
      self.subtractFlag  = (f & subtractFlagPosition)  == subtractFlagPosition
      self.halfCarryFlag = (f & halfCarryFlagPosition) == halfCarryFlagPosition
      self.carryFlag     = (f & carryFlagPosition)     == carryFlagPosition

    case .bc: self.bc = value
    case .de: self.de = value
    case .hl: self.hl = value
    }
  }
}
