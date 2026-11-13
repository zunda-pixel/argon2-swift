// swift-tools-version: 6.4
import PackageDescription

let package = Package(
  name: "argon2-swift",
  products: [.library(name: "Argon2", targets: ["Argon2"])],
  targets: [
    .target(
      name: "CArgon2",
      exclude: ["vendor/LICENSE"],
      cSettings: [.headerSearchPath("vendor/include")]),
    .target(
      name: "Argon2",
      dependencies: ["CArgon2"],
      swiftSettings: [.strictMemorySafety(), .defaultIsolation(nil), .treatAllWarnings(as: .error)]),
    .testTarget(name: "Argon2Tests", dependencies: ["Argon2"]),
  ]
)
