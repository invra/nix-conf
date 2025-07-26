use {
    colored::Colorize,
    tracing::info,
    tracing_subscriber::{
        EnvFilter,
        fmt::{self, format},
        prelude::__tracing_subscriber_SubscriberExt,
        util::SubscriberInitExt,
    },
    std::{
        process::{
            ExitStatus,
            Command,
        },
        path::Path,
    },
};

fn is_command_available(cmd: &str) -> bool {
    Command::new("command")
        .arg("-v")
        .arg(cmd)
        .arg(">/dev/null 2>&1")
        .output().unwrap().status.success()
}

fn run_command(cmd: &str, print: bool) -> std::process::Output {
    print.then(|| info!("I a running: {cmd}"));
    Command::new("zsh")
        .arg("-c")
        .arg(cmd)
        .output()
        .expect(format!("{cmd} Could not be ran!").as_str())
}

fn run_after_install_command(cmd: &str) {
    let full = format!("zsh -c \"source /etc/zshrc && {cmd} \"");
    run_command(&full, true);
}

#[cfg(target_os = "macos")]
fn main() {
    tracing_subscriber::registry()
    .with(
        fmt::layer()
        .with_target(false)
        .with_level(true)
        .without_time()
        .with_ansi(true)
    )
    .with(EnvFilter::new("info"))
    .init();

    let nix_path = Path::new("/nix/var/nix/profiles/default/bin/nix");
    if !Path::exists(nix_path) {
        info!("Nix is not installed. Installing Nix...");
        run_command("curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh", false);
    } else {
        info!("Nix is already installed. I will skip installation.");
    }
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
