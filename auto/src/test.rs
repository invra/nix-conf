mod mods;

use {
    colored::Colorize,
    mods::os::{get_os_pretty, get_os_semantic},
};

fn main() {
    println!(
        "{} Running some stuff to get your system output to test if everything dectects correctly.",
        "[INFO]".yellow()
    );

    println!(
        "{} macOS Sema: {:?}.{:?}",
        "[SYSTEM]".green(),
        get_os_semantic()[0],
        get_os_semantic()[1]
    );
    println!("{} macOS Name: {}", "[SYSTEM]".green(), get_os_pretty());
}
