// swift-tools-version:5.0

import PackageDescription

let package = Package(
  name: "GameBoyKit",
  platforms: [
    .macOS(.v10_11)
  ],
  products: [
    .executable(name: "Code generation", targets: ["Code generation"]),
    .library(name: "GameBoyKit", targets: ["GameBoyKit"])
  ],
  targets: [
    .target(
      name: "GameBoyKit",
      dependencies: [],
      path: "GameBoyKit"
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
