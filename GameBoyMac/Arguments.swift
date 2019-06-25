// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftlint:disable strict_fileprivate

// TODO: https://www.enekoalonso.com/articles/parsing-command-line-arguments-with-swift-package-manager-argument-parser

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

//  let rom: Cartridge = {
//    switch rawArguments.romPath {
//    case .none:
//      fatalError("Unable to locate rom file.")
//    case let .some(path):
//      return Cartridge(data: open(path))
//    }
//  }()
  let cartCount = MemoryMap.rom0.count + MemoryMap.rom1.count

  return Arguments(
    bootrom: openBootrom(path: rawArguments.bootromPath),
    rom: Cartridge(data: Data(count: cartCount))
  )
}

private func openBootrom(path: String?) -> Bootrom {
  guard let path = path else {
    print("Boot-ROM not found. Using default one.")
    return Bootrom.skip
  }

  do {
    let url = URL(fileURLWithPath: path, isDirectory: false)
    let data = try Data(contentsOf: url)
    return try BootromFactory.fromData(data)
  } catch let error as BootromCreationError {
    print("Error when opening Boot-ROM: \(error.description)")
    exit(1)
  } catch {
    print("Error when opening Boot-ROM: \(error.localizedDescription)")
    exit(1)
  }
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
      index += 1
    }
  }

  return result
}
