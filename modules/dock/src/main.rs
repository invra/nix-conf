use os_info::{Version, get as get_info};

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
