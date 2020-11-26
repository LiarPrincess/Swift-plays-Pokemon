// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import GameBoyKit

struct Arguments {

  static let bootromArgument = "--bootrom"
  static let romArgument = "--rom" // or just last one

  private(set) var bootromPath: String?
  private(set) var romPath: String?

  init(arguments: [String]) {
    var index = 0

    while index < arguments.count {
      let value = arguments[index].trimmingCharacters(in: .whitespaces)
      switch value {

      case Arguments.bootromArgument:
        guard index + 1 < arguments.count else {
          index += 1
          break
        }

        self.bootromPath = arguments[index + 1]
        index += 2

      case Arguments.romArgument:
        guard index + 1 < arguments.count else {
          index += 1
          break
        }

        self.romPath = arguments[index + 1]
        index += 2

      default:
        index += 1
      }
    }

    // If we don't have rom then assume it is in the last argument.
    // '> 1' because 1st argument is the program name.
    if self.romPath == nil && arguments.count > 1 {
      self.romPath = arguments.last
    }
  }
}
