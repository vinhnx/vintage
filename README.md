# package_outdated

[![Swift 5.0](https://img.shields.io/badge/swift-5.0-orange.svg)](#)
[![Swift Package Manager](https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat)](https://swift.org/package-manager)
[![@vinhnx](https://img.shields.io/badge/contact-%40vinhnx-blue.svg)](https://twitter.com/vinhnx)

A small CLI tool to check project's Swift Package Manager dependencies' local version with remote latest version. 

Like Cocoapods's `pod outdated` or Carthage's `carthage outdated`, but for Swift Package Manager.

Currently, it will just output local dependency version and compare with latest git remote version. 

In the future, I will try to support local dependency path and attempt to mimic the like of Cocoapods and Carthage.

This meant for personal educational purpose as I'm learning to write Swift scripting, but feel free to use in your project if you see fit. Pull PR is very welcome 😄 !

## Installation

Using **Make** (recommended):

```bash
$ git clone https://github.com/vinhnx/package_outdated.git
$ cd package_outdate
$ make
```

Using the **Swift Package Manager**:

```bash
$ git clone https://github.com/vinhnx/package_outdated.git
$ cd package_outdate
$ swift build -c release -Xswiftc -static-stdlib
$ cp -f .build/release/package_outdate /usr/local/bin/package_outdate
```

Using **[Mint](https://github.com/yonaskolb/mint)**:

```
$ mint install vinhnx/package_outdated
```

## Usage

Without any specifications (have to be executed in the directory where [Swift Package Manager manifest file (Package.swift)](https://github.com/apple/swift-package-manager/blob/master/Documentation/Usage.md) is located).

```bash
package_outdated run
```

Specifies path of Swift Package Manager directory to update.

```bash
package_outdated run -p Dependencies
```

Help page

```bash
package_outdated --help
Usage:

    $ package_outdated

Commands:

    + run - Check project's Package dependencies' local version with remote latest version.
```

```bash
package_outdated run --help

Usage:

    $ package_outdated run

Options:
    --path [default: .] - Path to the folder contains Swift Package manifest file (Package.swift).
```

## Dependencies

+ [Sweep](https://github.com/JohnSundell/Sweep)
+ [Files](https://github.com/JohnSundell/Files)
+ [Releases](https://github.com/JohnSundell/Releases)
+ [Commander](https://github.com/kylef/Commander)
+ [Rainbow](https://github.com/onevcat/Rainbow)

## Reference

+ [Swift Package Manager usage document](https://github.com/apple/swift-package-manager/blob/master/Documentation/Usage.md#create-a-package)
+ [git ls-remote](https://git-scm.com/docs/git-ls-remote.html)
+ [carthage outdated](https://github.com/Carthage/Carthage/blob/master/Source/carthage/Outdated.swift)
+ I was heavily inspired by this awesome talk [John Sundell: Swift scripting in practice](https://www.youtube.com/watch?v=PFdh5G3BJqM) :rocket:

## Help, feedback or suggestions?

Feel free to contact me on [Twitter](https://twitter.com/vinhnx) for discussions, news & announcements about Sugar & other projects.
