import Cocoa
import SwiftBoyKit

private func getPath(_ filename: String) -> URL {
  let documentDirs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
  guard let dir = documentDirs.first else {
    fatalError("Unable to find document path.")
  }
  return dir.appendingPathComponent(filename)
}

internal func saveState(cpu: Cpu, to filename: String) {
  let url = getPath(filename)

  if FileManager.default.fileExists(atPath: url.path) {
    print("Error when saving: file already exists.")
    return
  }

  do {
    let encoder = JSONEncoder()
    let data = try encoder.encode(cpu)
    try data.write(to: url, options: .atomicWrite)

    print("Succesfuly saved state to: \(url.path)")
  } catch let error {
    print("Error when saving: \(error.localizedDescription)")
  }
}

internal func loadState(from filename: String) -> Cpu {
  let url = getPath(filename)

  do {
    let decoder = JSONDecoder()
    let data = try Data(contentsOf: url)
    return try decoder.decode(Cpu.self, from: data)
  } catch let error {
    fatalError("Error when loading: \(error.localizedDescription).")
  }
}
