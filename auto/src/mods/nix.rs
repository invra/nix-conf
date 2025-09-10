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

            if let Some(middle) = file_name
                .strip_prefix("system-")
                .and_then(|s| s.strip_suffix("-link"))
            {
                if middle.chars().all(|c| c.is_ascii_digit()) {
                    return true;
                }
            }
        }
    }
    false
}

pub(crate) fn home_applied() -> bool {
    let home = match env::var("HOME") {
        Ok(h) => h,
        Err(_) => return false,
    };
    
    let hm_state = Path::new(&home)
        .join(".local")
        .join("state")
        .join("nix")
        .join("profiles")
        .join("home-manager");
    
    hm_state.exists()
}
