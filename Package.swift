// swift-tools-version:4.2

import PackageDescription

let package = Package(
  name: "RPiI2C",
  dependencies: [
    .package(url: "https://github.com/uraimo/SwiftyGPIO.git", from: "1.0.0"),
    .package(url: "https://github.com/pvieito/PythonKit.git", .branch("master")),
    .package(url: "https://github.com/onevcat/Rainbow", from: "3.0.0")
  ],
  targets: [
    .target(
      name: "RPiI2C",
      dependencies: ["SwiftyGPIO", "PythonKit", "Rainbow"]),
    ]
)
