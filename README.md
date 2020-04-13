# Webtrekk Tracking Library

[![Build Status](https://travis-ci.com/Webtrekk/Webtrekk-iOS-v5.svg?branch=master)](https://travis-ci.com/github/Webtrekk/Webtrekk-iOS-v5)

[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/Webtrekk.svg?style=flat-square)](https://cocoapods.org/pods/Webtrekk) ![Carthage](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat) ![Platform support](https://img.shields.io/badge/platform-ios%20%7C%20tvos%20%7C%20watchos-lightgrey.svg?style=flat-square)

The Webtrekk SDK allows you to track user activities, screen flow and media usage for an App. All data is send to the Webtrekk tracking system for further analysis.

# Requirements

| Plattform | Version            |
|-----------|-------------------:|
| `iOS`     |             `8.0+` |
| `watchOs` |             `2.0+` |


# Installation

[CocoaPods](htttps://www.cocoapods.org) (*Podfile*):

`pod 'Webtrekk'`

[Carthage](https://github.com/Carthage/Carthage) (*Cartfile*):

`github "Webtrekk/webtrekk-ios-sdk"`

# OCLint

We use Oclint from [OCLint](http://oclint.org). 
Details about the specific settings for this project can be found in the `.oclint.yml` file.

# Travis CI

We use [Travis CI](https://travis-ci.org/) to check the code for inconsistencies and running the linter & tests. 
Details about the specific settings for this project can be found in the `.travis.yml` file.

# SSL

As of iOS 9 Apple is more strictly enforcing the usage of SSL for network connections. Webtrekk highly recommends and offers the usage of a valid serverUrl with SSL support. In case there is a need to circumvent this. The App will need an exception entry within the `Info.plist`. Apple's regulations about this are well documented within the [iOS Developer Library](https://developer.apple.com/library/ios/documentation/General/Reference/InfoPlistKeyReference/Articles/CocoaKeys.html#//apple_ref/doc/uid/TP40009251-SW33)

# Example App with functionality

For an example app of the functionality in this SDK see: https://github.com/Webtrekk/Webtrekk-iOS-v5/tree/master/MappIntelligenceDemoApp

# License

See the [LICENSE](LICENSE.md) file for license rights and limitations (MIT).
