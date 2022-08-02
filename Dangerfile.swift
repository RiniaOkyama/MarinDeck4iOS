import Danger

// fileImport: DangerExtensions/Shell.swift
let danger = Danger()

if let swiftLintVersion = shell("swiftlint", "version") {
    danger.message("SwiftLint: \(swiftLintVersion)")
}
if let dangerJSVersion = shell("danger-js", "--version") {
    danger.message("danger-js: \(dangerJSVersion)")
}
if let dangerSwiftVersion = shell("danger-swift", "--version") {
    danger.message("danger-swift: \(dangerSwiftVersion)")
}
if let swiftVersion = shell("swift", "--version") {
    danger.message(swiftVersion)
}
danger.message("Validation passed! 🎉")
