# MappIntelligence Tracking Library

[![Build Status](https://travis-ci.com/mapp-digital/MappIntelligence-iOS-v5.svg?branch=master)](https://travis-ci.com/github/mapp-digital/MappIntelligence-iOS-v5)

[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/MappIntelligence.svg?style=flat)](https://cocoapods.org/pods/MappIntelligence) ![SPM](https://img.shields.io/badge/SPM-compatible-4BC51D.svg?style=flat) ![Platform support](https://img.shields.io/badge/platform-ios-lightgrey.svg?style=flat)

The MappIntelligence SDK allows you to track user activities, screen flow and media usage for an App. All data is send to the MappIntelligence tracking system for further analysis.

# Requirements

| Plattform | Version            |
|-----------|-------------------:|
| `iOS`     |            `12.0+` |


# Installation

[CocoaPods](https://www.cocoapods.org) (*Podfile*):

`pod 'MappIntelligence'`

[Swift Package Manager](https://swift.org/package-manager/)(*Swift Package Manager*):

The *Swift Package Manager* is a tool for automating the distribution of Swift code and is integrated into the swift compiler. It is in early development, but Alamofire does support its use on supported platforms.


Once you have your Swift package set up, adding MappIntelligence as a dependency is as easy as adding it to the dependencies value of your Package.swift.

dependencies: [
    .package(url: "https://github.com/mapp-digital/MappIntelligence-iOS-v5.git", .upToNextMajor(from: "5.0.7"))
]

# OCLint

We use Oclint from [OCLint](http://oclint.org). 
Details about the specific settings for this project can be found in the `.oclint.yml` file.

# Travis CI

We use [Travis CI](https://travis-ci.org/) to check the code for inconsistencies and running the linter & tests. 
Details about the specific settings for this project can be found in the `.travis.yml` file.

# Migrating from Webtrekk SDK V4

The Mapp Intelligence SDK v5 offers the possibility to migrate from Mapp Intelligence v4 without losing user data, meaning you will not lose historic data when updating to the new version. The option is disabled by default and needs to be manually enabled in the global configuration. Please use the function below to update from version 4 to version 5 without data loss:

```swift
MappIntelligence.shared()?.shouldMigrate = true
```

# SSL

As of iOS 9 Apple is more strictly enforcing the usage of SSL for network connections. MappIntelligence highly recommends and offers the usage of a valid serverUrl with SSL support. In case there is a need to circumvent this. The App will need an exception entry within the `Info.plist`. Apple's regulations about this are well documented within the [iOS Developer Library](https://developer.apple.com/library/ios/documentation/General/Reference/InfoPlistKeyReference/Articles/CocoaKeys.html#//apple_ref/doc/uid/TP40009251-SW33)

# Example App with functionality

For an example app of the functionality in this SDK see: https://github.com/mapp-digital/MappIntelligence-iOS-v5/tree/master/MappIntelligenceDemoApp

# License

See the [LICENSE](https://github.com/mapp-digital/MappIntelligence-iOS-v5/blob/master/LICENSE.md) file for license rights and limitations (MIT).
