mod mods;

use {
    colored::Colorize,
    mods::{
        nix::{home_applied, nix_darwin_applied, nix_installed},
        os::{get_os_pretty, get_os_semantic},
    },
};

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
