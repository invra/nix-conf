import Foundation

let fileManager = FileManager.default
let scriptDir = URL(fileURLWithPath: fileManager.currentDirectoryPath)
let bootstrapDir = scriptDir.appendingPathComponent(".bootstrap")
let rustupInitPath = bootstrapDir.appendingPathComponent("rustup-init")
let rustupHome = bootstrapDir.appendingPathComponent("rustup")
let cargoHome = bootstrapDir.appendingPathComponent("cargo")

enum BootstrapError: Error {
    case unsupportedArch(String)
    case downloadFailed
}

func detectArch() throws -> URL {
    let arch = ProcessInfo.processInfo.machineArchitecture
    switch arch {
    case "x86_64":
        return URL(string: "https://static.rust-lang.org/rustup/dist/x86_64-apple-darwin/rustup-init")!
    case "arm64":
        return URL(string: "https://static.rust-lang.org/rustup/dist/aarch64-apple-darwin/rustup-init")!
    default:
        throw BootstrapError.unsupportedArch(arch)
    }
}

func downloadRustupInit(from url: URL, to destination: URL) throws {
    print("Downloading rustup-init from \(url.absoluteString)...")
    let data = try Data(contentsOf: url)
    try data.write(to: destination, options: .atomic)
    try makeExecutable(at: destination)
}

func makeExecutable(at path: URL) throws {
    let permissions = try fileManager.attributesOfItem(atPath: path.path)
    if let perms = permissions[.posixPermissions] as? NSNumber {
        let newPerms = perms.intValue | 0o111
        try fileManager.setAttributes([.posixPermissions: newPerms], ofItemAtPath: path.path)
    }
}

func runRustupInit(at path: URL) throws {
    print("Running rustup-init...")

    let task = Process()
    task.executableURL = path
    task.arguments = ["-y", "--no-modify-path", "--profile", "minimal"]

    var env = ProcessInfo.processInfo.environment
    env["RUSTUP_HOME"] = rustupHome.path
    env["CARGO_HOME"] = cargoHome.path
    env["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    task.environment = env

    try task.run()
    task.waitUntilExit()

    if task.terminationStatus != 0 {
        fputs("rustup-init failed.\n", stderr)
        exit(Int32(task.terminationStatus))
    }

    print("Do not follow above tasks. This is meant to be a disposable environment.")
}

do {
    try fileManager.createDirectory(at: bootstrapDir, withIntermediateDirectories: true)
    let rustupURL = try detectArch()

    if !fileManager.fileExists(atPath: rustupInitPath.path) {
        try downloadRustupInit(from: rustupURL, to: rustupInitPath)
    } else {
        print("rustup-init already exists, skipping download.")
    }

    try runRustupInit(at: rustupInitPath)
} catch BootstrapError.unsupportedArch(let arch) {
    fputs("Unsupported architecture: \(arch)\n", stderr)
    exit(1)
} catch {
    fputs("Error: \(error.localizedDescription)\n", stderr)
    exit(1)
}

extension ProcessInfo {
    var machineArchitecture: String {
        var sysinfo = utsname()
        uname(&sysinfo)
        return withUnsafePointer(to: &sysinfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                String(validatingUTF8: $0) ?? "unknown"
            }
        }
    }
}
