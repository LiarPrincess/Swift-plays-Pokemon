import Cocoa
import SwiftBoyKit

private func getPath(_ filename: String) -> URL {
  let documentDirs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
  let dir = documentDirs.first!
  return dir.appendingPathComponent(filename)
}

func saveState(cpu: Cpu, to filename: String) {
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

func loadEmptyCpu() -> Cpu {
  let memory = Memory()
  let cpu = Cpu(memory: memory)
  memory.fakeEmptyCartridge()
  return cpu
}

func loadState(from filename: String) -> Cpu? {
  let url = getPath(filename)

  do {
    let decoder = JSONDecoder()
    let data = try Data(contentsOf: url)
    return try decoder.decode(Cpu.self, from: data)
  } catch let error {
    print("Error when loading: \(error.localizedDescription)")
    return nil
  }
}
