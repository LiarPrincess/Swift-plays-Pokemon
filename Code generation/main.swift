// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

let currentFile = URL(fileURLWithPath: #file)
let sourcesDir = currentFile.deletingLastPathComponent().deletingLastPathComponent()
let cpuDir = sourcesDir.appendingPathComponent("GameBoyKit").appendingPathComponent("Cpu")

let opcodes = try openOpcodesFile()
defer { fclose(stdout) }

var file = cpuDir.appendingPathComponent("UnprefixedOpcodes.swift")
freopen(file.path, "w", stdout)
printOpcodes(opcodes)

file = cpuDir.appendingPathComponent("CBPrefixedOpcodes.swift")
freopen(file.path, "w", stdout)
printPrefixOpcodes(opcodes)

file = cpuDir.appendingPathComponent("Cpu+ExecuteUnprefixed.swift")
freopen(file.path, "w", stdout)
printExecuteExtension(opcodes)

file = cpuDir.appendingPathComponent("Cpu+ExecutePrefixed.swift")
freopen(file.path, "w", stdout)
printExecutePrefixExtension(opcodes)

//file = frameworkDir.appendingPathComponent("Cpu+Instructions.swift")
//let instructionsFileContent = try! String(contentsOf: file, encoding: .utf8)
//freopen(file.path, "w", stdout)
//modifyInstructions(opcodes, instructionsFileContent)
