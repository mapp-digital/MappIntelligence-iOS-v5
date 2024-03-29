// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MappIntelligence",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(
            name: "MappIntelligenceSDK",
            targets: ["MappIntelligenceSDK"]),
        .library(
            name: "MappIntelligenceiOS",
            targets: ["MappIntelligenceiOS"])
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
                .linkedFramework("UIKit", .when(platforms: [.iOS]))
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
        )
    ]
)
