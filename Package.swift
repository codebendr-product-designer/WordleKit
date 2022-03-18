// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WordleKit",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "WordleKit", targets: ["WordleKit"]),
        .library(name: "ScoreClient", targets: ["ScoreClient"]),
        .library(name: "ScoreClientLive", targets: ["ScoreClientLive"]),
        .library(name: "Helpers", targets: ["Helpers"]),
        .library(name: "ScoreFeature", targets: ["ScoreFeature"]),
        .library(name: "Animations", targets: ["Animations"])
    ],
    dependencies: [ ],
    targets: [
        .target(name: "WordleKit"),
        .target(name: "ScoreClient", dependencies: ["WordleKit"]),
        .target(name: "ScoreClientLive", dependencies: ["WordleKit", "ScoreClient"]),
        .target(name: "Helpers"),
        .target(name: "Animations", dependencies: ["WordleKit"]),
        .target(name: "ScoreFeature", dependencies: [
            "ScoreClient",
            "Helpers",
            "Animations",
            "WordleKit"
        ]),
        .testTarget(
            name: "ClientTests",
            dependencies: ["WordleKit", "ScoreClient", "ScoreFeature"]),
    ]
)
