import Commander
import package_outdated_core

// NOTE: check TODO.md in root folder for TODOs

let pathOption = Option("path",
                        default: ".",
                        flag: "p",
                        description: "Path to the folder contains Swift Package manifest file (Package.swift).")

let pathCommand = command(pathOption) { path in
    try execute(path)
}

let group = Group {
    $0.addCommand("run", "Check project's Package dependencies' local version with remote latest version.", pathCommand)
}

group.run()
