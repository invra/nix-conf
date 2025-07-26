use {
    colored::Colorize,
    std::{
        process::{
            ExitStatus,
            Command,
        },
        path::Path,
    },
    clap::Parser,
    os_info::{
        get as get_os_info,
        Version,
        Type,
    },
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

fn iprintln(msg: &str)  {
    println!("{} {msg}", "[INFO]".yellow());
}

fn is_command_available(cmd: &str) -> bool {
    Command::new("command")
        .arg("-v")
        .arg(cmd)
        .output().unwrap().status.success()
}

fn run_command(cmd: &str, print: bool) -> std::process::ExitStatus {
    print.then(|| iprintln("I am running: {cmd}"));
    Command::new("zsh")
        .arg("-c")
        .arg(cmd)
        .status()
        .expect(&format!("{cmd} could not be run!"))
}

fn run_after_install_command(cmd: &str) {
    let full = format!("zsh -c \"source /etc/zshrc && {cmd}\"");
    run_command(&full, true);
}

#[cfg(target_os = "macos")]
fn main() {
    let args = Args::parse();
    let flake = args.flake;
    let nix_path = Path::new("/nix/var/nix/profiles/default/bin/nix");

    if !Path::exists(nix_path) {
        iprintln("Nix is not installed. Installing Nix...");
        run_command("curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh", false);

        match get_os_info().version() {
            &Version::Semantic(major, _, _) if major >= 26 => {
                println!("Patching nix-daemon plist to disable fork safety...");
                run_command("sudo plutil -insert EnvironmentVariables -dictionary /Library/LaunchDaemons/org.nixos.nix-daemon.plist &>/dev/null", false);
                run_command("sudo plutil -insert EnvironmentVariables.OBJC_DISABLE_INITIALIZE_FORK_SAFETY -string YES /Library/LaunchDaemons/org.nixos.nix-daemon.plist &>/dev/null", false);
                run_command("sudo launchctl unload /Library/LaunchDaemons/org.nixos.nix-daemon.plist", false);
                run_command("sudo launchctl bootstrap system /Library/LaunchDaemons/org.nixos.nix-daemon.plist", false);
            }
            _ => ()
        }
    } else {
        iprintln("Nix is already installed. I will skip installation.");
    }

    if !is_command_available("home-manager") {
        iprintln("Applying nix-darwin config...");
        run_after_install_command(format!("sudo nix run nix-darwin --extra-experimental-features 'nix-command flakes' -- switch --flake '.#{flake}'").as_str());
    } else {
        iprintln("The nix-darwin installation has already happened, if it hasn't... Please uninstall or dereference home-manager.");
    }

    if !is_command_available("hx") {
        iprintln("Home Manager config not applied. Applying now...");
        run_after_install_command(format!("home-manager switch --flake '.#{flake}' -b backup").as_str());
        
        println!("{} Please run \"source /etc/zshrc\" to have access to Nix.", "[FINISHED]".green());
    } else {
        iprintln("The home-manager config seems to be already applied. Please use nh to rebuild.");
    }
}



#[cfg(not(target_os = "macos"))]
fn main() -> Result<(), Error> {
    Err(Error::IncompatibleSystem)
}
