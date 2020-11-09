// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

let currentFile = URL(fileURLWithPath: #file)
let sourcesDir = currentFile.deletingLastPathComponent().deletingLastPathComponent()
let cpuDir = sourcesDir.appendingPathComponent("GameBoyKit").appendingPathComponent("Cpu")
let debugDir = sourcesDir.appendingPathComponent("GameBoyKit").appendingPathComponent("Debug")

let opcodes = try readOpcodes()
defer { fclose(stdout) }

// MARK: - Execute

var file = cpuDir.appendingPathComponent("Cpu+ExecuteUnprefixed.swift")
freopen(file.path, "w", stdout)
printExecuteSwitch(opcodes)

file = cpuDir.appendingPathComponent("Cpu+ExecutePrefixed.swift")
freopen(file.path, "w", stdout)
printExecutePrefixSwitch(opcodes)

// MARK: - Symbols

file = debugDir.appendingPathComponent("UnprefixedOpcode.swift")
freopen(file.path, "w", stdout)
printOpcodeEnum(opcodes)

file = debugDir.appendingPathComponent("CBPrefixedOpcode.swift")
freopen(file.path, "w", stdout)
printPrefixOpcodeEnum(opcodes)

// MARK: - Modify cpu instructions

// file = frameworkDir.appendingPathComponent("Cpu+Instructions.swift")
// let instructionsFileContent = try! String(contentsOf: file, encoding: .utf8)
// freopen(file.path, "w", stdout)
// modifyInstructions(opcodes, instructionsFileContent)
