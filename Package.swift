// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "CreatureContraptions",
    platforms: [
        .iOS(.v12),
    ],
    products: [
        .library(name: "CreatureContraptions", targets: ["CreatureContraptions"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "5.0.0"),
        .package(url: "https://github.com/SnapKit/SnapKit", from: "5.0.0")
    ],
    targets: [
        .target(name: "CreatureContraptions", dependencies: ["RxSwift", "RxCocoa", "SnapKit"]),
    ]
)
