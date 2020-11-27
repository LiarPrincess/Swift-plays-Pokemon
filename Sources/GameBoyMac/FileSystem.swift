// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import GameBoyKit

/// Helpers for file system access.
enum FileSystem {

  // MARK: - Bootrom

  static func readBootrom(path: String) -> Bootrom {
    do {
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

  // MARK: - Rom

  static func readRom(romPath: String, withSavedRam: Bool) -> Cartridge {
    do {
      let url = URL(fileURLWithPath: romPath, isDirectory: false)
      let rom = try Data(contentsOf: url)
      let ram = withSavedRam ? Self.readSavedExternalRam(romPath: romPath) : nil
      return try CartridgeFactory.create(rom: rom, ram: ram)
    } catch let error as CartridgeError {
      print("Error when opening ROM: \(error.description)")
      exit(1)
    } catch {
      print("Error when opening ROM: \(error.localizedDescription)")
      exit(1)
    }
  }

  // MARK: - Extranal ram

  private static func readSavedExternalRam(romPath: String) -> ExternalRamState? {
    do {
      let path = Self.getSavedExternalRamPath(romPath: romPath)
      let url = URL(fileURLWithPath: path, isDirectory: false)

      print("Looking for saved state: \(path)")
      let data = try Data(contentsOf: url)
      print("Saved state found")

      return ExternalRamState(data: data)
    } catch {
      let nsError = error as NSError
      if nsError.domain == NSCocoaErrorDomain && nsError.code == NSFileReadNoSuchFileError {
        print("No saved state found")
        return nil
      }

      print("Error when opening saved state: \(error.localizedDescription)")
      exit(1)
    }
  }

  static func saveExternalRam(gameBoy: GameBoy, romPath: String) {
    do {
      let path = Self.getSavedExternalRamPath(romPath: romPath)
      let url = URL(fileURLWithPath: path, isDirectory: false)
      let state = ExternalRamState(gameBoy: gameBoy)

      print("Saving state: \(path)")
      try state.data.write(to: url, options: .atomic)
      print("Save finished")
    } catch {
      print("Error when saving state: \(error.localizedDescription)")
      // No exit here, let user continue their game.
    }
  }

  private static func getSavedExternalRamPath(romPath: String) -> String {
    return romPath + ".sav"
  }
}
