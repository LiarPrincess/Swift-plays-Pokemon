// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

private let lcdWidth = Lcd.Constants.width

/// We need to remember tile color that was used to draw background/window.
/// This information is later used when drawing sprites.
internal struct TileColorInLine {

  // We could use bit array, but this is faster:
  private let data = MemoryBuffer(count: lcdWidth)

  internal func set(x: Int, color: UInt8) {
    self.data[x] = color
  }

  internal func setAll(color: UInt8) {
    for x in 0..<lcdWidth {
      self.data[x] = color
    }
  }

  internal func isColorZero(x: Int) -> Bool {
    let value = self.data[x]
    return value == 0
  }

  internal func deallocate() {
    self.data.deallocate()
  }
}

// MARK: - Old implementation - bit array

/*
/// Array with single bit for every pixel in line.
internal struct LcdLineBitArray {

  private typealias Element = UInt64
  private static let elementCount = 3

  private var elements: (Element, Element, Element)

  internal var isEmpty: Bool {
    return self.elements == (Element.zero, Element.zero, Element.zero)
  }

  internal init(initialValue: Bool) {
    let totalWidth = Self.elementCount * Element.bitWidth
    assert(totalWidth >= lcdWidth)

    let singleElement = initialValue ? Element.max : Element.zero
    self.elements = (singleElement, singleElement, singleElement)
  }

  internal subscript(index: Int) -> Bool {
    get {
      let tupleIndex = index / Element.bitWidth
      let bit = index % Element.bitWidth

      switch tupleIndex {
      case 0:
        return isSet(self.elements.0, bit: bit)
      case 1:
        return isSet(self.elements.1, bit: bit)
      case 2:
        return isSet(self.elements.2, bit: bit)
      default:
        fatalError("Bit array index out of range")
      }
    }
    set(newValue) {
      let tupleIndex = index / Element.bitWidth
      let bit = index % Element.bitWidth

      switch tupleIndex {
      case 0:
        self.elements.0 = self.set(self.elements.0, bit: bit, value: newValue)
      case 1:
        self.elements.1 = self.set(self.elements.1, bit: bit, value: newValue)
      case 2:
        self.elements.2 = self.set(self.elements.2, bit: bit, value: newValue)
      default:
        fatalError("Bit array index out of range")
      }
    }
  }

  private func isSet(_ element: Element, bit: Int) -> Bool {
    return (element >> bit) & 1 == 1
  }

  private func set(_ element: Element, bit: Int, value: Bool) -> Element {
    let mask = Element(1) << bit
    return value ? (element | mask) : (element & (~mask))
  }

  #if DEBUG

  internal func debug() -> String {
    let dividerEvery = 8
    let dividerCount = lcdWidth / dividerEvery

    var result = ""

    for dividerIndex in 0..<dividerCount {
      let bit = dividerIndex * dividerEvery
      let bitString = String(describing: bit)

      let paddingCount = dividerEvery - bitString.count
      let padding = String(repeating: " ", count: paddingCount)

      result += "|\(bit)\(padding)"
    }

    result += "|\n|"

    for index in 0..<lcdWidth {
      let value = self[index]
      result += value ? "1" : "0"

      let hasDivider = (index + 1).isMultiple(of: dividerEvery)
      if hasDivider {
        result += "|"
      }
    }

    return result
  }

  #endif
}
*/
