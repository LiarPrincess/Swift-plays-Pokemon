import Foundation

let currentFile = URL(fileURLWithPath: #file)
let sourcesDir = currentFile.deletingLastPathComponent().deletingLastPathComponent()
let frameworkDir = sourcesDir.appendingPathComponent("SwiftBoyKit")

let opcodesDir = frameworkDir.appendingPathComponent("Opcodes")
let cpuDir = frameworkDir.appendingPathComponent("Cpu")

let opcodes = try openOpcodesFile()
defer { fclose(stdout) }

var file = opcodesDir.appendingPathComponent("UnprefixedOpcodes.swift")
freopen(file.path, "w", stdout)
printOpcodes(opcodes)

file = opcodesDir.appendingPathComponent("CBPrefixedOpcodes.swift")
freopen(file.path, "w", stdout)
printPrefixOpcodes(opcodes)

file = cpuDir.appendingPathComponent("Cpu+ExecuteUnprefixed.swift")
freopen(file.path, "w", stdout)
printExecute(opcodes)

file = cpuDir.appendingPathComponent("Cpu+ExecutePrefixed.swift")
freopen(file.path, "w", stdout)
printExecutePrefix(opcodes)
