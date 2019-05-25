private let zeroFlagPosition:      UInt8 = 7
private let subtractFlagPosition:  UInt8 = 6
private let halfCarryFlagPosition: UInt8 = 5
private let carryFlagPosition:     UInt8 = 4

struct Registers {

  var a: UInt8
  var b: UInt8
  var c: UInt8
  var d: UInt8
  var e: UInt8
  var f: UInt8
  var h: UInt8
  var l: UInt8

  init() {
    self.a = 0
    self.b = 0
    self.c = 0
    self.d = 0
    self.e = 0
    self.f = 0
    self.h = 0
    self.l = 0
  }

  // MARK: - Combined registers

  var af: UInt16 {
    get { return self.get16(self.a, self.f) }
    set { set16(&self.a, &self.f, to: newValue) }
  }

  var bc: UInt16 {
    get { return self.get16(self.b, self.c) }
    set { set16(&self.b, &self.c, to: newValue) }
  }

  var de: UInt16 {
    get { return self.get16(self.d, self.e) }
    set { set16(&self.d, &self.e, to: newValue) }
  }

  var hl: UInt16 {
    get { return self.get16(self.h, self.l) }
    set { set16(&self.h, &self.l, to: newValue) }
  }

  private func get16(_ high: UInt8, _ low: UInt8) -> UInt16 {
    return (UInt16(high) << 8) | UInt16(low)
  }

  private func set16(_ high: inout UInt8, _ low: inout UInt8, to value: UInt16) {
    high = UInt8((value & 0xff00) >> 8)
    low = UInt8(value & 0xff)
  }

  // MARK: - Flags

  var zeroFlag: Bool {
    get { return self.getFlag(at: zeroFlagPosition) }
    set { self.setFlag(at: zeroFlagPosition, to: newValue) }
  }

  var subtractFlag: Bool {
    get { return self.getFlag(at: subtractFlagPosition) }
    set { self.setFlag(at: subtractFlagPosition, to: newValue) }
  }

  var halfCarryFlag: Bool {
    get { return self.getFlag(at: halfCarryFlagPosition) }
    set { self.setFlag(at: halfCarryFlagPosition, to: newValue) }
  }

  var carryFlag: Bool {
    get { return self.getFlag(at: carryFlagPosition) }
    set { self.setFlag(at: carryFlagPosition, to: newValue) }
  }

  private func getFlag(at position: UInt8) -> Bool {
    let mask = UInt8(1) << position
    return self.f & mask != 0
  }

  private mutating func setFlag(at position: UInt8, to value: Bool) {
    let mask = UInt8(1) << position
    if value { self.f |= mask }
    else { self.f &= (~mask) }
  }
}
