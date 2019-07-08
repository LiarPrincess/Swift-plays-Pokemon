// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import GameBoyKit

private let bootromArgument = "--bootrom"
private let romArgument = "--rom" // or just last one

internal struct Arguments {
  internal let bootrom:   Bootrom
  internal let cartridge: Cartridge
}

private struct RawArguments {
  fileprivate var bootromPath: String? = nil
  fileprivate var romPath:     String? = nil
}

internal func parseArguments() -> Arguments {
  let rawArguments = parseRawArguments()
  return Arguments(
    bootrom: openBootrom(path: rawArguments.bootromPath),
    cartridge: openRom(path: rawArguments.romPath)
  )
}

private func openBootrom(path: String?) -> Bootrom {
  guard let path = path else {
    print("Boot-ROM not provided. Using default one.")
    return .skip
  }

  do {
    print("Boot-ROM: \(path)")

    let url = URL(fileURLWithPath: path, isDirectory: false)
    let data = try Data(contentsOf: url)
    return try BootromFactory.fromData(data)
  } catch let error as BootromFactoryError {
    print("Error when opening Boot-ROM: \(error.description)")
    exit(1)
  } catch {
    print("Error when opening Boot-ROM: \(error.localizedDescription)")
    exit(1)
  }
}

private func openRom(path: String?) -> Cartridge {
  guard let path = path else {
    print("ROM not provided. Use '\(romArgument)' to specify ROM file.")
    exit(1)
  }

  do {
    print("ROM: \(path)")

    let url = URL(fileURLWithPath: path, isDirectory: false)
    let data = try Data(contentsOf: url)
    return try CartridgeFactory.fromData(data)
  } catch let error as CartridgeFactoryError {
    print("Error when opening ROM: \(error.description)")
    exit(1)
  } catch {
    print("Error when opening ROM: \(error.localizedDescription)")
    exit(1)
  }
}

private func parseRawArguments() -> RawArguments {
  let arguments = CommandLine.arguments

  var result = RawArguments()

  var index = 0
  while index < arguments.count {
    switch arguments[index] {

    case bootromArgument:
      guard index + 1 < arguments.count else {
        index += 1
        break
      }

      result.bootromPath = arguments[index + 1]
      index += 2

    case romArgument:
      guard index + 1 < arguments.count else {
        index += 1
        break
      }

      result.romPath = arguments[index + 1]
      index += 2

    default:
      index += 1
    }
  }

  // if we don't have rom then assume it is in the last argument
  if result.romPath == nil && arguments.count > 1 {
    result.romPath = arguments.last
  }

  return result
}
