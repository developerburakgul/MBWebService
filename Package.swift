// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MBWebService",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "MBWebService",
            targets: ["MBWebService"]),
    ],
    targets: [
        .target(
            name: "MBWebService"),
    ]
)
