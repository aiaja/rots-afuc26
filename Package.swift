// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "RotsAfuc26",
    platforms: [
        .iOS(.v18),
        .macOS(.v14)
    ],
    products: [
        .executable(
            name: "RotsAfuc26App",
            targets: ["RotsAfuc26App"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/splinetool/spline-ios", from: "0.6.0")
    ],
    targets: [
        .executableTarget(
            name: "RotsAfuc26App",
            dependencies: [
                .product(name: "SplineRuntime", package: "spline-ios")
            ],
            path: "RotsAfuc26",
            resources: [
                .process("Resources")
            ]
        )
    ]
)
