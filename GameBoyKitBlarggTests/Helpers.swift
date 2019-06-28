// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import GameBoyKit

internal enum Helpers {
  internal static func openRom(url: URL) -> Cartridge {
    do {
      let data = try Data(contentsOf: url)
      return try CartridgeFactory.fromData(data)
    } catch let error as CartridgeInitError {
      print("Error when opening ROM: \(error.description)")
      exit(1)
    } catch {
      print("Error when opening ROM: \(error.localizedDescription)")
      exit(1)
    }
  }
}
