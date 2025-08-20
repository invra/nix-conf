use std::{env, fs, path::Path};

pub(crate) fn nix_installed() -> bool {
    let nix_path = Path::new("/nix/var/nix/profiles/default/bin/nix");
    nix_path.exists()
}

pub(crate) fn nix_darwin_applied() -> bool {
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

pub(crate) fn home_applied() -> bool {
    let home = env::var("HOME").unwrap();
    let target = Path::new(&home)
        .join(".nix-profile")
        .join("etc")
        .join("man_db.conf");

    target.exists()
}
