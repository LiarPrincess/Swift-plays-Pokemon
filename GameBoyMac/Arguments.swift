// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftlint:disable strict_fileprivate
// swiftlint:disable force_unwrapping

import Foundation
import GameBoyKit

internal struct Arguments {
  internal let bootrom: Bootrom
  internal let rom:     Cartridge
}

private struct RawArguments {
  fileprivate var bootromPath: String? = nil
  fileprivate var romPath:     String? = nil
}

internal func parseArguments() -> Arguments {
  let rawArguments = parseRawArguments()

  let bootrom: Bootrom = {
    switch rawArguments.bootromPath {
    case .none:
      print("Boot-ROM not found. Using default one.")
      return .skip
    case let .some(path):
      return Bootrom(data: open(path))
    }
  }()

  let rom: Cartridge = {
    switch rawArguments.romPath {
    case .none:
      fatalError("Unable to locate rom file.")
    case let .some(path):
      return Cartridge(data: open(path))
    }
  }()

  return Arguments(
    bootrom: bootrom,
    rom: rom
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

      result.bootromPath = arguments[index + 1]
      index += 2

    case "--rom":
      guard index + 1 < arguments.count else {
        index += 1
        break
      }

      result.romPath = arguments[index + 1]
      index += 2

    default:
      print("Unknown argument '\(arguments[index])'")
      index += 1
    }
  }

  return result
}

private func open(_ path: String) -> Data {
  do {
    let url = URL(fileURLWithPath: path, isDirectory: false)
    return try Data(contentsOf: url)
  } catch {
    fatalError(error.localizedDescription)
  }
}
