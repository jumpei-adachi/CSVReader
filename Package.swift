// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "CSVReader",
  products: [
    .library(
      name: "CSVReader",
      targets: ["CSVReader"]
    ),
  ],
  targets: [
    .target(
      name: "CSVReader"
    ),
    .testTarget(
      name: "CSVReaderTests",
      dependencies: ["CSVReader"]
    ),
  ]
)
