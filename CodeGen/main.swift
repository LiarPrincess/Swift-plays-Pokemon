import Foundation

let currentFile = URL(fileURLWithPath: #file)
let sourcesDir = currentFile.deletingLastPathComponent().deletingLastPathComponent()
let emulatorDir = sourcesDir.appendingPathComponent("SwiftBoy").appendingPathComponent("Emulator")

let opcodes = try openOpcodesFile()
defer { fclose(stdout) }

var file = emulatorDir.appendingPathComponent("Opcodes.swift")
freopen(file.path, "w", stdout)
printOpcodes(opcodes)

file = emulatorDir.appendingPathComponent("PrefixOpcodes.swift")
freopen(file.path, "w", stdout)
printPrefixOpcodes(opcodes)

file = emulatorDir.appendingPathComponent("Cpu+Execute.swift")
freopen(file.path, "w", stdout)
printExecute(opcodes)

file = emulatorDir.appendingPathComponent("Cpu+ExecutePrefix.swift")
freopen(file.path, "w", stdout)
printExecutePrefix(opcodes)
