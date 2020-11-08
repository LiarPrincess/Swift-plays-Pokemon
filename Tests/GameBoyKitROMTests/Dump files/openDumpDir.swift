// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

func openDumpDir(directory: URL) -> [DumpFile] {
  let index = directory.appendingPathComponent("index.txt")

  guard let reader = StreamReader(url: index) else {
    fatalError("Unable to open dump dir index: '\(index.path)'. " +
               "Please remember to extract 'Dump.zip'.")
  }

  return reader
    .filter { !$0.isEmpty }
    .map { filename in
      let url = directory.appendingPathComponent(filename)
      return DumpFile(filename: filename, url: url)
    }
}
