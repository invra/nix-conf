#[cfg(target_os = "macos")]
fn main() {
    use colored::Colorize;
    println!("Hello, world!");
}


#[cfg(not(target_os = "macos"))]
#[derive(Debug, Clone, Copy)]
pub enum Error {
    IncompatibleSystem,
}

#[cfg(not(target_os = "macos"))]
fn main() -> Result<(), Error> {
    Err(Error::IncompatibleSystem)
}
