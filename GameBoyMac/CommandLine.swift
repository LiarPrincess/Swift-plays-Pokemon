// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

internal struct Arguments {
  internal let bootrom: Data
}

private struct RawArguments {
  fileprivate var bootrom: String? = nil
}

internal func parseArguments() -> Arguments {
  let rawArguments = parseRawArguments()

  guard let bootromPath = rawArguments.bootrom else {
    fatalError("Boot-ROM not found. Please copy the Boot-ROM to '%s'.")
  }

  return Arguments(
    bootrom: openRom(bootromPath)
  )
}

private func parseRawArguments() -> RawArguments {
  let arguments = CommandLine.arguments

  var result = RawArguments()

  var index = 0
  while index < arguments.count {
    switch arguments[index] {
    case "--bootrom":
      guard index + 1 < arguments.count else {
        index += 1
        break
      }

      result.bootrom = arguments[index + 1]
      index += 2

    default:
      index += 1
    }
  }

  return result
}

private func openRom(_ path: String) -> Data {
  do {
    let url = URL(fileURLWithPath: path, isDirectory: false)
    return try Data(contentsOf: url)
  } catch {
    fatalError(error.localizedDescription)
  }
}
