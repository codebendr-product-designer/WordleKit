// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WordleKit",
    products: [
        .library(name: "WordleKit", targets: ["WordleKit"]),
        .library(name: "ScoreClient", targets: ["ScoreClient"]),
        .library(name: "ScoreClientLive", targets: ["ScoreClientLive"])
    ],
    dependencies: [ ],
    targets: [
        .target(name: "WordleKit"),
        .target(name: "ScoreClient", dependencies: ["WordleKit"]),
        .target(name: "ScoreClientLive", dependencies: ["WordleKit", "ScoreClient"]),
        .testTarget(
            name: "WordleKitTests",
            dependencies: ["WordleKit"]),
    ]
)
