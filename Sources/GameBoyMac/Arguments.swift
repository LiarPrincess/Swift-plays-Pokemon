// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import GameBoyKit

struct Arguments {

  static let bootromArgument = "--bootrom"
  static let romArgument = "--rom" // or just last one

  let bootrom: Bootrom?
  let rom: Cartridge

  init(arguments: [String]) {
    let stringArguments = parse(arguments: arguments)
    self.bootrom = openBootrom(path: stringArguments.bootromPath)
    self.rom = openRom(path: stringArguments.romPath)
  }
}

private struct StringArguments {
  fileprivate var bootromPath: String?
  fileprivate var romPath: String?
}

private func parse(arguments: [String]) -> StringArguments {
  var result = StringArguments()
  var index = 0

  while index < arguments.count {
    let value = arguments[index].trimmingCharacters(in: .whitespaces)
    switch value {

    case Arguments.bootromArgument:
      guard index + 1 < arguments.count else {
        index += 1
        break
      }

      result.bootromPath = arguments[index + 1]
      index += 2

    case Arguments.romArgument:
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

  // If we don't have rom then assume it is in the last argument.
  // '> 1' because 1st argument is the program name.
  if result.romPath == nil && arguments.count > 1 {
    result.romPath = arguments.last
  }

  return result
}

private func openBootrom(path: String?) -> Bootrom? {
  guard let path = path else {
    print("Boot-ROM not provided. Using default one.")
    return nil
  }

  do {
    print("Boot-ROM:", path)

    let url = URL(fileURLWithPath: path, isDirectory: false)
    let data = try Data(contentsOf: url)
    return try BootromFactory.create(data: data)
  } catch let error as BootromError {
    print("Error when opening Boot-ROM: \(error.description)")
    exit(1)
  } catch {
    print("Error when opening Boot-ROM: \(error.localizedDescription)")
    exit(1)
  }
}

private func openRom(path: String?) -> Cartridge {
  guard let path = path else {
    let arg = Arguments.romArgument
    print("ROM not provided. Use '\(arg)' argument to specify ROM file.")
    exit(1)
  }

  do {
    print("ROM:", path)

    let url = URL(fileURLWithPath: path, isDirectory: false)
    let data = try Data(contentsOf: url)
    let result = try CartridgeFactory.create(data: data)

    print("Found:", result.header.title)
    print("ROM type:", result.header.type)
    return result
  } catch let error as CartridgeError {
    print("Error when opening ROM: \(error.description)")
    exit(1)
  } catch {
    print("Error when opening ROM: \(error.localizedDescription)")
    exit(1)
  }
}
