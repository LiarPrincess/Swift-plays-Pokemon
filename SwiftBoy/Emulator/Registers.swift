enum SingleRegister {
  case a
  case b
  case c
  case d
  case e
  case h
  case l
}

enum CombinedRegister {
  case af
  case bc
  case de
  case hl
}

struct Registers {

  /// Accumulator: A
  /// An 8-bit register for storing data and the results of arithmetic and logical operations.
  var a: UInt8 = 0

  /// Auxiliary register: B
  var b: UInt8 = 0

  /// Auxiliary register: C
  var c: UInt8 = 0

  /// Auxiliary register: D
  var d: UInt8 = 0

  /// Auxiliary register: E
  var e: UInt8 = 0

  /// Auxiliary register: H
  var h: UInt8 = 0

  /// Auxiliary register: L
  var l: UInt8 = 0

  /// Z: Set to 1 when the result of an operation is 0; otherwise reset.
  var zeroFlag: Bool = false

  /// N: Set to 1 following execution of the substruction instruction, regardless of the result.
  var subtractFlag: Bool = false

  /// H: Set to 1 when an operation results in carrying from or borrowing to bit 3.
  var halfCarryFlag: Bool = false

  /// CY: Set to 1 when an operation results in carrying from or borrowing to bit 7.
  var carryFlag: Bool = false

  // MARK: - Combined registers

  var bc: UInt16 {
    get { return self.get16(self.b, self.c) }
    set { self.set16(&self.b, &self.c, to: newValue) }
  }

  var de: UInt16 {
    get { return self.get16(self.d, self.e) }
    set { self.set16(&self.d, &self.e, to: newValue) }
  }

  var hl: UInt16 {
    get { return self.get16(self.h, self.l) }
    set { self.set16(&self.h, &self.l, to: newValue) }
  }

  private func get16(_ high: UInt8, _ low: UInt8) -> UInt16 {
    return (UInt16(high) << 8) | UInt16(low)
  }

  private func set16(_ high: inout UInt8, _ low: inout UInt8, to value: UInt16) {
    high = UInt8((value & 0xff00) >> 8)
    low = UInt8(value & 0xff)
  }

  // MARK: - Addressing

  func get(_ r: SingleRegister) -> UInt8 {
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

  func get(_ r: CombinedRegister) -> UInt16 {
    switch r {
    case .af: return 0 // TODO: Get AF
    case .bc: return self.bc
    case .de: return self.de
    case .hl: return self.hl
    }
  }

  mutating func set(_ r: SingleRegister, to value: UInt8) {
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

  mutating func set(_ r: CombinedRegister, to value: UInt16) {
    switch r {
    case .af: break // TODO: Set AF
    case .bc: self.bc = value
    case .de: self.de = value
    case .hl: self.hl = value
    }
  }
}
