import PackageDescription;

let package = Package(
  name: "publishd",
  dependencies: [
    .Package(url: "https://github.com/czechboy0/Socks.git", majorVersion: 0, minor: 12),
    .Package(url: "https://github.com/kareman/SwiftShell", "3.0.0-beta"),
  ]
);
