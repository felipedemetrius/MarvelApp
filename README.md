# MarvelApp

![](https://app.travis-ci.com/felipedemetrius/MarvelApp.svg?token=6DqTMxdUwufFsJqvY4hb&branch=main)

## Description

The project is a list of Marvel characters. The project uses CoreData as a cache to store the characters and images locally. 

## Getting Started

1. Download or Clone the project
1. Use Xcode version 16.x
1. Open the terminal and navigate to the directory of project ```cd MarvelAppiOS```
1. Open the workspace ```open MarvelAppiOS.xcworkspace```

## Running modules

The project was divided into 2 modules. The first is MarvelLoader, which is the entire data provider layer. Run the module first to build the framework. The second is the MarveliOSUiKit, which is the module for specific views for iOS. Run this module to build the framework. After this, run the target MarvelAppiOS to build the app.

Running the tests of MarveliOSUiKit on iPhone 15 (iOS 17.5). Because the snapshot tests was generated in this simulator.

## Requirements

- iOS 15.0+ 
- Xcode 16+
- Swift 5.1+

## Future implementations

1. Infinite scroll getting new characters
1. Search/filter characters by name
1. Detail screen for each character
