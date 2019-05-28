public extension UInt8 {
  var dec: String {
    let s = String(self, radix: 10, uppercase: false)
    let padding = String(repeating: " ", count: 3 - s.count)
    return "\(padding)\(s)"
  }

  var hex: String  {
    let s = String(self, radix: 16, uppercase: false)
    let padding = String(repeating: "0", count: 2 - s.count)
    return "0x\(padding)\(s)"
  }

  var bin: String  {
    let s = String(self, radix: 2, uppercase: false)
    let padding = String(repeating: "0", count: 8 - s.count)
    return "0x\(padding)\(s)"
  }
}

public extension UInt16 {
  var dec: String {
    let s = String(self, radix: 10, uppercase: false)
    let padding = String(repeating: " ", count: 5 - s.count)
    return "\(padding)\(s)"
  }

  var hex: String  {
    let s = String(self, radix: 16, uppercase: false)
    let padding = String(repeating: "0", count: 4 - s.count)
    return "0x\(padding)\(s)"
  }

  var bin: String  {
    let s = String(self, radix: 2, uppercase: false)
    let padding = String(repeating: "0", count: 16 - s.count)
    return "0x\(padding)\(s)"
  }
}
