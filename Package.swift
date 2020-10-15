// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "JGProgressHUD",
    products: [
        .library(name: "JGProgressHUD", targets: ["JGProgressHUD"])
    ],
    targets: [
        .target(
            name: "JGProgressHUD",
            path: "JGProgressHUD/JGProgressHUD"
        )
    ]
)
