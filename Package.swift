// swift-tools-version:5.0

import PackageDescription

let package = Package(
  name: "GameBoyKit",
  platforms: [
    .macOS(.v10_11)
  ],
  products: [
    .executable(name: "GameBoyMac", targets: ["GameBoyMac"]),
    .executable(name: "GameBoyKitBlarggTests", targets: ["GameBoyKitBlarggTests"]),
    .executable(name: "Code generation", targets: ["Code generation"]),
    .library(name: "GameBoyKit", targets: ["GameBoyKit"])
  ],
  targets: [
    .target(
      name: "GameBoyMac",
      dependencies: ["GameBoyKit"],
      path: "GameBoyMac"
    ),
    .target(
      name: "GameBoyKit",
      dependencies: [],
      path: "GameBoyKit"
    ),
    .target(
      name: "GameBoyKitBlarggTests",
      dependencies: ["GameBoyKit"],
      path: "GameBoyKitBlarggTests"
    ),
    .target(
      name: "Code generation",
      dependencies: [],
      path: "Code generation"
    ),
    .testTarget(
      name: "GameBoyKitTests",
      dependencies: ["GameBoyKit"],
      path: "GameBoyKitTests"
    )
  ]
)
