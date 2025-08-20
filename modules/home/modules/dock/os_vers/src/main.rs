use os_info::{Type, Version, get as get_info};
use std::process::exit;

#[cfg(target_os = "macos")]
fn main() {
    match get_info().version() {
        Version::Semantic(major, _, _) => {
            print!("{}", major);
        }
        other => {
            print!("{:?}", other);
        }
    }
}
