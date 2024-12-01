// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "MCEmojiPicker",
    defaultLocalization: "en",
    platforms: [.iOS("16.0")],
    products: [.library(name: "MCEmojiPicker", targets: ["MCEmojiPicker"])],
    dependencies: [],
    targets: [.target(
        name: "MCEmojiPicker",
        dependencies: [],
        path: "Sources/MCEmojiPicker"
    )],
    swiftLanguageVersions: [.v4_2]
)
