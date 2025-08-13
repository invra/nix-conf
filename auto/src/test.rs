use {
    colored::Colorize,
    os_info::{Version, get as get_os_info},
};

fn main() {
    println!(
        "{} Running some stuff to get your system output to test if everything dectects correctly.",
        "[INFO]".yellow()
    );

    match get_os_info().version() {
        &Version::Semantic(major, _, _) => {
            println!("{} macOS Version: {major}", "[SYSTEM]".green())
        }
        _ => println!("cow"),
    }

    println!("{} macOS Name: {:?}", "[SYSTEM]".green(), whoami::distro());
}
