// swift-tools-version:5.0

import PackageDescription

let package = Package(
  name: "GameboyKit",
  products: [
    .executable(name: "GameboyMac", targets: ["GameboyMac"]),
    .executable(name: "Code generation", targets: ["Code generation"]),
    .library(name: "GameboyKit", targets: ["GameboyKit"])
  ],
  targets: [
    .target(
      name: "GameboyMac",
      dependencies: ["GameboyKit"],
      path: "GameboyMac"
    ),
    .target(
      name: "GameboyKit",
      dependencies: [],
      path: "GameboyKit"
    ),
    .target(
      name: "Code generation",
      dependencies: [],
      path: "Code generation"
    )
    // .testTarget(
    //   name: "GameboyKitTests",
    //   dependencies: ["GameboyKit"],
    //   path: "GameboyKitTests"
    // )
  ]
)
