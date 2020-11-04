// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

func listStates(dir: URL) -> [URL] {
  let index = dir.appendingPathComponent("index.txt")

  guard let reader = StreamReader(url: index) else {
    print("Unable to index file for: \(dir)")
    exit(1)
  }

  return reader
    .filter { !$0.isEmpty }
    .map { dir.appendingPathComponent($0) }
}
