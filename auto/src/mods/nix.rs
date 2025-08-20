use std::path::Path;

pub(crate) fn nix_installed() -> bool {
    let nix_path = Path::new("/nix/var/nix/profiles/default/bin/nix");
    nix_path.exists()
}
