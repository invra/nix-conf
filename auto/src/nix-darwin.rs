use {
    colored::Colorize,
    std::{
        collections::BTreeMap,
        process::{
            ExitStatus,
            Command,
        },
        fs::{
          File,
          OpenOptions,  
        },
        io::{
            Read,
            Write,
        },
        path::{
            Path,
            PathBuf,
        },
    },
    clap::Parser,
    os_info::{
        get as get_os_info,
        Version,
        Type,
    },
    plist::{
        Value,
        Dictionary,
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

    #[arg(long)]
    patch_plist: bool,
}

fn run_patch_plist() {
    let args: Vec<String> = std::env::args().collect();

let mut cmd = Command::new("sudo");
cmd.arg(&args[0]); // path to current binary
cmd.arg("--patch-plist");

// Forward all args except binary name and flags already added
for arg in &args[1..] {
    if arg != "--patch-plist" {
        cmd.arg(arg);
    }
}

let status = cmd.status()
    .expect("Failed to elevate permissions for patching plist");
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
    print.then(|| iprintln(format!("{}", &cmd).as_str()));
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
   
    if !nix_path.exists() {
        iprintln("Nix is not installed. Installing Nix...");
        run_command("curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh", false);

        if args.patch_plist {
            iprintln("Patching nix-daemon plist to disable fork safety...");
            run_patch_plist();
            iprintln("Patched and now restarting daemon...");
        }

        match get_os_info().version() {
            &Version::Semantic(major, _, _) if major >= 26 => {
                
                run_command("sudo launchctl unload /Library/LaunchDaemons/org.nixos.nix-daemon.plist", true);
                run_command("sudo launchctl bootstrap system /Library/LaunchDaemons/org.nixos.nix-daemon.plist", true);
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
