use colored::Colorize;
use clap::Parser;

#[cfg(target_os = "macos")]
fn main() {
    println!("Hello, world!");
}


#[cfg(not(target_os = "macos"))]
fn main() -> Result<(), ()> {
    eprintln!("{} {}", "[ERROR]".red(), "This tool only works on macOS, and should only be run on it.");
    Err(())
}