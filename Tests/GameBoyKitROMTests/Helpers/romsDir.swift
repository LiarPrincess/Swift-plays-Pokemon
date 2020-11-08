// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

private let bundle = Bundle.main
private let fileManager = FileManager.default

private let executableURL: URL = {
  if let url = bundle.executableURL {
    return url
  }

  if let path = bundle.executablePath {
    return URL(fileURLWithPath: path)
  }

  fatalError("Failed to obtain executable path.")
}()

/// `ROMs` directory in repository root.
let romsDir: URL = {
  var dir = executableURL
  dir.deleteLastPathComponent()

  for _ in 0..<dir.pathComponents.count {
    let romDir = dir.appendingPathComponent("ROMs")
    let exists = fileManager.fileExists(atPath: romDir.path)

    if exists {
      return romDir
    }

    dir.deleteLastPathComponent()
  }

  fatalError("Failed to obtain ROM dir")
}()
