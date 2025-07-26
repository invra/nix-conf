use {
    colored::Colorize,
    // tracing::info,
    // tracing_subscriber::{
    //     EnvFilter,
    //     fmt::{self, format},
    //     prelude::__tracing_subscriber_SubscriberExt,
    //     util::SubscriberInitExt,
    // },
    std::{
        process::{
            ExitStatus,
            Command,
        },
        path::Path,
    },
    clap::Parser,
};


#[derive(Debug, Clone, Copy)]
pub enum Error {
    IncompatibleSystem,
    NoFlakeProvided,
}

#[derive(Parser, Debug)]
#[command(name = "Nix Darwin Installer", about = "A Nix installer which also boostraps the configs.", long_about = None)]
struct Args {
    #[arg(short, long)]
    flake: String,
}

fn is_command_available(cmd: &str) -> bool {
    Command::new("command")
        .arg("-v")
        .arg(cmd)
        .arg(">/dev/null 2>&1")
        .output().unwrap().status.success()
}

fn run_command(cmd: &str, print: bool) -> std::process::Output {
    print.then(|| println!("I a running: {cmd}"));
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
    let args = Args::parse();
    let flake = args.flake;

    // tracing_subscriber::registry()
    // .with(
    //     fmt::layer()
    //     .with_target(false)
    //     .with_level(true)
    //     .without_time()
    //     .with_ansi(true)
    // )
    // .with(EnvFilter::new("info"))
    // .init();

    let nix_path = Path::new("/nix/var/nix/profiles/default/bin/nix");
    if !Path::exists(nix_path) {
        println!("Nix is not installed. Installing Nix...");
        run_command("curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh", false);

        // TODO: PLIST MANAGEMENT
    } else {
        println!("Nix is already installed. I will skip installation.");
    }

    if !is_command_available("home-manager") {
        println!("Applying nix-darwin config...");
        run_after_install_command(format!("sudo nix run nix-darwin --extra-experimental-features 'nix-command flakes' -- switch --flake '.#{flake}'").as_str());
    } else {
        println!("The nix-darwin installation has already happened, if it hasn't... Please uninstall or dereference home-manager.");
    }

    if !is_command_available("hx") {
        println!("Home Manager config not applied. Applying now...");
        run_after_install_command(format!("home-manager switch --flake '.#{flake}' -b backup").as_str());
        
        println!("{} Please run \"source /etc/zshrc\" to have access to Nix.", "[FINISHED]".green());
    } else {
        println!("The home-manager config seems to be already applied. Please use nh to rebuild.");
    }
}



#[cfg(not(target_os = "macos"))]
fn main() -> Result<(), Error> {
    Err(Error::IncompatibleSystem)
}
