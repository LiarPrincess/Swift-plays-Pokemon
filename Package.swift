// swift-tools-version:5.0

import PackageDescription

let package = Package(
  name: "Swift plays pokemon",
  platforms: [
    .macOS(.v10_11)
  ],
  products: [
    .executable(name: "Code generation", targets: ["Code generation"]),
    .library(name: "GameBoyKit", targets: ["GameBoyKit"])
  ],
  targets: [
    // We can't add 'GameBoyMac' because SPM does not support 'Metal'

    // Framework with GameBoy emulator
    .target(
      name: "GameBoyKit",
      dependencies: []
    ),
    // Unit tests
    .testTarget(
      name: "GameBoyKitTests",
      dependencies: ["GameBoyKit"]
    ),
    // Tests that execute specific ROMs, for example:
    // http://gbdev.gg8.se/files/roms/blargg-gb-tests/
    .target(
      name: "GameBoyKitROMTests",
      dependencies: [],
      path: "Tests/GameBoyKitROMTests"
    ),

    // Tiny tool to work with 'opcodes.json'
    // from https://github.com/lmmendes/game-boy-opcodes
    .target(
      name: "Code generation",
      dependencies: []
    )
  ]
)
