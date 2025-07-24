use os_info::{get as get_info, Type, Version};
use std::process::exit;

#[cfg(target_os="macos")]
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