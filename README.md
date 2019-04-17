# vintage

[![Swift 5.0](https://img.shields.io/badge/swift-5.0-orange.svg)](#)
[![Swift Package Manager](https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat)](https://swift.org/package-manager)
[![@vinhnx](https://img.shields.io/badge/contact-%40vinhnx-blue.svg)](https://twitter.com/vinhnx)

**vintage** is a small command-line utility to check project's Swift Package Manager dependencies' local version with remote latest version. 

![screenshot](screenshots/run_demo.png)

## Goals

Like Cocoapods's `pod outdated` or Carthage's `carthage outdated`, but for Swift Package Manager.

Currently, it will just output local dependency version and compare with latest git remote version. 

In the future, I will try to support local dependency path and attempt to mimic the like of Cocoapods and Carthage.

This meant for personal educational purpose as I'm learning to write Swift scripting, but feel free to use in your project if you see fit. PRs is very welcome 😄 !

## Installation

#### On Mac

Using **Make** (recommended):

```bash
$ git clone https://github.com/vinhnx/vintage.git
$ cd vintage
$ make
```

Using the **Swift Package Manager**:

```bash
$ git clone https://github.com/vinhnx/vintage.git
$ cd vintage
$ swift build -c release -Xswiftc -static-stdlib
$ cp -f .build/release/vintage /usr/local/bin/vintage
 ```
 
Using **[Mint](https://github.com/yonaskolb/mint)**:

```bash
$ mint install vinhnx/vintage
```

Using **[Marathon](https://github.com/JohnSundell/Marathon)**:

```bash
$ marathon install vinhnx/vintage
```

#### On Linux

```bash
$ git clone https://github.com/vinhnx/vintage.git
$ cd vintage
$ swift build -c release
$ cp -f .build/release/vintage /usr/local/bin/vintage
```

If you encounter a permissions failure while installing, you may need to prepend sudo to the commands. To update `vintage`, simply repeat any of the above two series of commands, except cloning the repo.

## Usage

Without any specifications (have to be executed in the directory where [Swift Package Manager manifest file (Package.swift)](https://github.com/apple/swift-package-manager/blob/master/Documentation/Usage.md) is located):

```bash
$ vintage run
```

Specifies path of Swift Package Manager directory to update:

```bash
$ vintage run -p Dependencies
```

Help page:

```bash
$ vintage --help

Usage:

    $ vintage

Commands:

    + run - Check project's Package dependencies' local version with remote latest version.
```

Run with option:

```bash
$ vintage run --help

Usage:

    $ vintage run

Options:
    --path [default: .] - Path to the folder contains Swift Package manifest file (Package.swift).
```

## Dependencies

+ [Sweep](https://github.com/JohnSundell/Sweep)
+ [Files](https://github.com/JohnSundell/Files)
+ [Releases](https://github.com/JohnSundell/Releases)
+ [Commander](https://github.com/kylef/Commander)
+ [Chalk](https://github.com/mxcl/Chalk)

## Reference

+ [Swift Package Manager usage document](https://github.com/apple/swift-package-manager/blob/master/Documentation/Usage.md#create-a-package)
+ [git ls-remote](https://git-scm.com/docs/git-ls-remote.html)
+ [carthage outdated](https://github.com/Carthage/Carthage/blob/master/Source/carthage/Outdated.swift)
+ I was heavily inspired by these awesome talks:
  + [Swift Scripting by Ayaka Nonaka](https://academy.realm.io/posts/swift-scripting/)
  + [John Sundell: Swift scripting in practice](https://www.youtube.com/watch?v=PFdh5G3BJqM)

## Help, feedback or suggestions?

Feel free to contact me on [Twitter](https://twitter.com/vinhnx) for discussions, news & announcements about Sugar & other projects. :rocket:
