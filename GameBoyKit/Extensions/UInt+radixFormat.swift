// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

extension UInt8 {
  public var dec: String {
    let s = String(self, radix: 10, uppercase: false)
    let padding = String(repeating: " ", count: 3 - s.count)
    return "\(padding)\(s)"
  }

  public var hex: String  {
    let s = String(self, radix: 16, uppercase: false)
    let padding = String(repeating: "0", count: 2 - s.count)
    return "0x\(padding)\(s)"
  }

  public var bin: String  {
    let s = String(self, radix: 2, uppercase: false)
    let padding = String(repeating: "0", count: 8 - s.count)
    return "0b\(padding)\(s)"
  }
}

extension UInt16 {
  public var dec: String {
    let s = String(self, radix: 10, uppercase: false)
    let padding = String(repeating: " ", count: 5 - s.count)
    return "\(padding)\(s)"
  }

  public var hex: String  {
    let s = String(self, radix: 16, uppercase: false)
    let padding = String(repeating: "0", count: 4 - s.count)
    return "0x\(padding)\(s)"
  }

  public var bin: String  {
    let s = String(self, radix: 2, uppercase: false)
    let padding = String(repeating: "0", count: 16 - s.count)
    return "0b\(padding)\(s)"
  }
}
