use {
    clap::Parser, colored::Colorize, os_info::{
        get as get_os_info,
        Version,
    }, plist::{
        Dictionary, Value
    }, std::{
        collections::BTreeMap, fs::{
            File,
            OpenOptions,
        }, io::{
            Read,
            Write,
        }, ops::Not, path::{
            Path,
            PathBuf,
        }, process::{
            Command,
            ExitStatus,
        }
    }
};

#[derive(Debug, Clone, Copy)]
pub enum Error {
    IncompatibleSystem,
    NoFlakeProvided,
}

#[derive(Parser, Debug)]
#[command(name = "Nix Darwin Installer", about = "A Nix installer which also bootstraps the configs.", long_about = None)]
struct Args {
    #[arg(short, long)]
    flake: Option<String>,

    #[arg(long)]
    patch_plist: bool,
}

fn iprintln(msg: &str) {
    println!("{} {msg}", "[INFO]".yellow());
}

fn run_patch_plist() -> Result<(), String> {

    iprintln("Patching nix-daemon plist to disable fork safety...");
    let args: Vec<String> = std::env::args().collect();
    let mut status = Command::new("sudo").args([&args[0], "--patch-plist"]).status().map_err(|x| x.to_string())?;

    status.success().then_some(()).ok_or(String::from("Failed to patch plist as root"))?;
    iprintln("Patch successful, restarting daemon...");
    run_command("sudo launchctl unload /Library/LaunchDaemons/org.nixos.nix-daemon.plist", true);
    run_command("sudo launchctl bootstrap system /Library/LaunchDaemons/org.nixos.nix-daemon.plist", true); 

    Ok(())
}

fn patch_plist() -> Result<(), Box<dyn std::error::Error>> {
    let plist_path = PathBuf::from("/Library/LaunchDaemons/org.nixos.nix-daemon.plist");
    let mut file = File::open(&plist_path)?;
    let mut buf = Vec::new();
    file.read_to_end(&mut buf)?;

    let mut root: Value = plist::Value::from_reader_xml(&*buf)?;

    let dict = root.as_dictionary_mut().expect("Expected top-level plist to be a <dict>");
    let env_vars = if let Some(Value::Dictionary(env)) = dict.get_mut("EnvironmentVariables") {
        env
    } else {
        dict.insert(
            "EnvironmentVariables".into(),
            Value::Dictionary(Dictionary::new()),
        );
        match dict.get_mut("EnvironmentVariables").unwrap() {
            Value::Dictionary(env) => env,
            _ => panic!("Failed to insert or access EnvironmentVariables"),
        }
    };

    env_vars.insert(
        "OBJC_DISABLE_INITIALIZE_FORK_SAFETY".to_string(),
        Value::String("YES".to_string()),
    );
    let output_path = PathBuf::from("/Library/LaunchDaemons/org.nixos.nix-daemon.plist");
    if let Some(parent) = output_path.parent() {
        std::fs::create_dir_all(parent)?;
    }

    let mut f = OpenOptions::new()
        .write(true)
        .truncate(true)
        .create(true)
        .open(&output_path)?;
    root.to_writer_xml(&mut f)?;

    Ok(())
}

fn is_command_available(cmd: &str) -> bool {
    Command::new("command")
        .arg("-v")
        .arg(cmd)
        .output()
        .map(|output| output.status.success())
        .unwrap_or(false)
}

fn run_command(cmd: &str, print: bool) -> std::process::ExitStatus {
    if print {
        iprintln(cmd);
    }
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
fn main()  -> Result<(), String>{
    let args = Args::parse();

    if args.patch_plist {
        match get_os_info().version() {
            &Version::Semantic(major, _, _) if major >= 26 => {
                if std::env::var("USER") == Ok("root".into()) {
                    return patch_plist().map_err(|e| e.to_string());
                } else {
                    return Err("Patch plist needs to be run as root".into());
                }
            }
            _ => iprintln("Patching is only required for macOS Tahoe and later, skipping."),
        }
        return Ok(());
    }

    let flake = args.flake.ok_or(Error::NoFlakeProvided).expect("Flake argument is required for normal operation");
    let nix_path = Path::new("/nix/var/nix/profiles/default/bin/nix");
    if !nix_path.exists() {
        iprintln("Nix is not installed. Installing Nix...");
        run_command("curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh", false);
        run_patch_plist();
    } else {
        iprintln("Nix is already installed. I will skip installation.");
    }

    if !is_command_available("home-manager") {
        iprintln("Applying nix-darwin config...");
        run_after_install_command(&format!(
            "sudo nix run nix-darwin --extra-experimental-features 'nix-command flakes' -- switch --flake '.#{}'",
            flake
        ));
    } else {
        iprintln("The nix-darwin installation has already happened, if it hasn't... Please uninstall or dereference home-manager.");
    }

    if !is_command_available("hx") {
        iprintln("Home Manager config not applied. Applying now...");
        run_after_install_command(&format!("home-manager switch --flake '.#{}' -b backup", flake));
        println!("{} Please run \"source /etc/zshrc\" to have access to Nix.", "[FINISHED]".green());
    } else {
        iprintln("The home-manager config seems to be already applied. Please use nh to rebuild.");
    }
    Ok(())
}

#[cfg(not(target_os = "macos"))]
fn main() -> Result<(), Error> {
    Err(Error::IncompatibleSystem)
}