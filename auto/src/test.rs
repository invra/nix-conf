mod mods;

use {
    colored::Colorize,
    mods::{
        nix::nix_installed,
        os::{get_os_pretty, get_os_semantic},
    },
    std::{env, fs, path::Path},
};

fn nix_darwin_applied() -> bool {
    let profiles_dir = "/nix/var/nix/profiles";

    if let Ok(entries) = fs::read_dir(profiles_dir) {
        for entry in entries.flatten() {
            let file_name = entry.file_name();
            let file_name = file_name.to_string_lossy();

            if file_name.starts_with("system-") && file_name.ends_with("-link") {
                if file_name["system-".len()..file_name.len() - "-link".len()]
                    .chars()
                    .all(|c| c.is_ascii_digit())
                {
                    return true;
                }
            }
        }
    }

    false
}

fn home_applied() -> bool {
    let home = env::var("HOME").unwrap();
    let target = Path::new(&home)
        .join(".nix-profile")
        .join("etc")
        .join("man_db.conf");

    target.exists()
}

fn main() {
    println!(
        "{} Running some stuff to get your system output to test if everything detects correctly.",
        "[INFO]".yellow()
    );

    println!(
        "{} macOS Sema: {:?}.{:?}",
        "[SYSTEM]".green(),
        get_os_semantic()[0],
        get_os_semantic()[1]
    );
    println!("{} macOS Name: {}", "[SYSTEM]".green(), get_os_pretty());
    println!(
        "{} Nix is Installed: {}",
        "[SYSTEM]".green(),
        nix_installed()
    );
    println!(
        "{} Nix-darwin is appiled: {}",
        "[SYSTEM]".green(),
        nix_darwin_applied()
    );
    println!(
        "{} Home-manager is appiled: {}",
        "[SYSTEM]".green(),
        home_applied()
    );
}
