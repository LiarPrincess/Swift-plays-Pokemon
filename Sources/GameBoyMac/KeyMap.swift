// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

struct KeyMap {

  let up: Key
  let down: Key
  let left: Key
  let right: Key

  let a: Key
  let b: Key
  let start: Key
  let select: Key

  struct Key {

    let value: UInt16

    private init(value: UInt16) {
      self.value = value
    }

    static let num0 = Key(value: 29)
    static let num1 = Key(value: 18)
    static let num2 = Key(value: 19)
    static let num3 = Key(value: 20)
    static let num4 = Key(value: 21)
    static let num5 = Key(value: 23)
    static let num6 = Key(value: 22)
    static let num7 = Key(value: 26)
    static let num8 = Key(value: 28)
    static let num9 = Key(value: 25)

    static let a = Key(value: 0)
    static let b = Key(value: 11)
    static let c = Key(value: 8)
    static let d = Key(value: 2)
    static let e = Key(value: 14)
    static let f = Key(value: 3)
    static let g = Key(value: 5)
    static let h = Key(value: 4)
    static let i = Key(value: 34)
    static let j = Key(value: 38)
    static let k = Key(value: 40)
    static let l = Key(value: 37)
    static let m = Key(value: 46)
    static let n = Key(value: 45)
    static let o = Key(value: 31)
    static let p = Key(value: 35)
    static let q = Key(value: 12)
    static let r = Key(value: 15)
    static let s = Key(value: 1)
    static let t = Key(value: 17)
    static let u = Key(value: 32)
    static let v = Key(value: 9)
    static let w = Key(value: 13)
    static let x = Key(value: 7)
    static let y = Key(value: 16)
    static let z = Key(value: 6)

    static let up = Key(value: 126)
    static let down = Key(value: 125)
    static let left = Key(value: 123)
    static let right = Key(value: 124)

    static let space = Key(value: 12)
    static let apostrophe = Key(value: 39)
    static let backapostrophe = Key(value: 50)
    static let backslash = Key(value: 44)
    static let capslock = Key(value: 57)
    static let comma = Key(value: 43)
    static let command = Key(value: 55)
    static let control = Key(value: 59)
    static let delete = Key(value: 51)
    static let equals = Key(value: 24)
    static let escape = Key(value: 53)
    static let frontslash = Key(value: 42)
    static let leftbracket = Key(value: 33)
    static let minus = Key(value: 27)
    static let option = Key(value: 58)
    static let period = Key(value: 47)
    static let `return` = Key(value: 36)
    static let rightbracket = Key(value: 30)
    static let semicolon = Key(value: 41)
    static let shift = Key(value: 56)
    static let tab = Key(value: 48)
  }
}
