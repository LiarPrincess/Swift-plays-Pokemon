import Foundation

let currentFile = URL(fileURLWithPath: #file)
let sourcesDir = currentFile.deletingLastPathComponent().deletingLastPathComponent()
let frameworkDir = sourcesDir.appendingPathComponent("SwiftBoyKit")

let opcodes = try openOpcodesFile()
defer { fclose(stdout) }

var file = frameworkDir.appendingPathComponent("UnprefixedOpcodes.swift")
freopen(file.path, "w", stdout)
printOpcodes(opcodes)

file = frameworkDir.appendingPathComponent("CBPrefixedOpcodes.swift")
freopen(file.path, "w", stdout)
printPrefixOpcodes(opcodes)

file = frameworkDir.appendingPathComponent("Cpu+ExecuteUnprefixed.swift")
freopen(file.path, "w", stdout)
printExecuteExtension(opcodes)

file = frameworkDir.appendingPathComponent("Cpu+ExecutePrefixed.swift")
freopen(file.path, "w", stdout)
printExecutePrefixExtension(opcodes)

//file = frameworkDir.appendingPathComponent("Cpu+Instructions.swift")
//let instructionsFileContent = try! String(contentsOf: file, encoding: .utf8)
//freopen(file.path, "w", stdout)
//modifyInstructions(opcodes, instructionsFileContent)
