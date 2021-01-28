// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MappIntelligence",
    platforms: [
        .iOS(.v10),
        .tvOS(.v11),
        .watchOS(.v4)
    ],
    products: [
        .library(
            name: "MappIntelligenceSDK",
            targets: ["MappIntelligenceSDK"]),
        .library(
            name: "MappIntelligenceiOS",
            targets: ["MappIntelligenceiOS"]),
        .library(
            name: "MappIntelligenceWatchOS",
            targets: ["MappIntelligenceWatchOS"]),
        .library(
            name: "MappIntelligenceTvOS",
            targets: ["MappIntelligenceTvOS"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "MappIntelligenceSDK",
            path: "MappIntelligence",
            cSettings: [
                .headerSearchPath("**"),
            ],
            linkerSettings: [
                .linkedFramework("UIKit", .when(platforms: [.iOS, .tvOS])),
                .linkedFramework("WatchKit", .when(platforms:[.watchOS]))
            ]
        ),
        .target(
            name: "MappIntelligenceiOS",
            dependencies:["MappIntelligenceSDK"],
            path: "MappIntelligenceiOS",
            publicHeadersPath:"",
            cSettings: [
                .headerSearchPath("**"),
            ],
            linkerSettings: [
                .linkedFramework("UIKit")
            ]
        ),
        .target(
            name: "MappIntelligenceWatchOS",
            dependencies:["MappIntelligenceSDK"],
            path: "MappIntelligenceWatchOS",
            publicHeadersPath:"",
            linkerSettings: [
                .linkedFramework("WatchKit", .when(platforms:[.watchOS]))
            ]
        ),
        .target(
            name: "MappIntelligenceTvOS",
            dependencies:["MappIntelligenceSDK"],
            path: "MappIntelligencetvOS",
            publicHeadersPath:"",
            linkerSettings: [
                .linkedFramework("UIKit")
            ]
        )
    ]
)
