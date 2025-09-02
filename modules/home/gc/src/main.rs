use {
    clap::Parser,
    git2::{Cred, FetchOptions, RemoteCallbacks, Repository},
    rpassword::prompt_password,
    std::{
        fs,
        path::{Path, PathBuf},
    },
};

#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
struct Args {
    source: String,
    target: Option<PathBuf>,

    #[arg(short, long)]
    cd: bool,

    #[arg(short = 'i', long)]
    identity_file: Option<PathBuf>,
}

fn candidate_identities() -> Vec<PathBuf> {
    let mut ids = vec![];
    let Ok(home) = std::env::var("HOME") else {
        return ids;
    };
    let ssh_dir = Path::new(&home).join(".ssh");
    let Ok(entries) = fs::read_dir(&ssh_dir) else {
        return ids;
    };

    for path in entries.flatten().map(|x| x.path()) {
        if !path.is_file() {
            continue;
        }

        let Some(name) = path.file_name().and_then(|n| n.to_str()) else {
            continue;
        };

        if name.ends_with(".pub") || name == "config" || name.starts_with("known_hosts") {
            continue;
        }

        ids.push(path);
    }
    ids
}

fn main() -> Result<(), String> {
    let args = Args::parse();

    let parts: Vec<&str> = args.source.split(':').collect();
    if parts.len() < 2 {
        return Err("Not enough arguments".into());
    }

    let is_ssh = parts[0] == "ssh";
    let (provider, repo) = if is_ssh {
        (
            parts.get(1).unwrap().to_owned(),
            parts.get(2).unwrap_or(&""),
        )
    } else {
        (
            parts.get(0).unwrap().to_owned(),
            parts.get(1).unwrap_or(&""),
        )
    };

    let url = if is_ssh {
        match provider.to_lowercase().as_str() {
            "github" | "gh" => format!("git@github.com:{repo}"),
            "gitlab" | "gl" => format!("git@gitlab.com:{repo}"),
            "codeberg" | "cb" => format!("git@codeberg.org:{repo}"),
            _ => Err(format!("Unsupported SSH provider: {provider}"))?,
        }
    } else {
        match provider.to_lowercase().as_str() {
            "github" | "gh" => format!("https://github.com/{repo}"),
            "gitlab" | "gl" => format!("https://gitlab.com/{repo}"),
            "codeberg" | "cb" => format!("https://codeberg.org:{repo}"),
            _ => Err(format!("Unsupported provider: {provider}"))?,
        }
    };

    let target_dir = args
        .target
        .unwrap_or_else(|| PathBuf::from(repo.split('/').last().unwrap_or("repo")));

    println!("Cloning from {} into {}", url, target_dir.display());

    if is_ssh {
        let identities = args
            .identity_file
            .map(|x| vec![x])
            .unwrap_or_else(candidate_identities);

        let mut callbacks = RemoteCallbacks::new();
        callbacks.credentials(move |_, username_from_url, _allowed_types| {
            let username = username_from_url.unwrap_or("git");

            for id in identities.iter() {
                println!("Trying SSH key: {}", id.display());
                let passphrase =
                    prompt_password(&format!("Enter passphrase for key {}: ", id.display()))
                        .unwrap_or_default();

                if let Ok(cred) = Cred::ssh_key(username, None, id, Some(&passphrase)) {
                    return Ok(cred);
                }
            }

            println!(
                "No valid identity found, falling back to ssh-agent for {}",
                username
            );
            Cred::ssh_key_from_agent(username)
        });

        let mut fetch_opts = FetchOptions::new();
        fetch_opts.remote_callbacks(callbacks);

        let mut builder = git2::build::RepoBuilder::new();
        builder.fetch_options(fetch_opts);

        builder
            .clone(&url, &target_dir)
            .map_err(|_| format!("Failed to clone {url} into {}", target_dir.display()))?;
    } else {
        Repository::clone(&url, &target_dir)
            .map_err(|_| format!("Failed to clone {url} into {}", target_dir.display()))?;
    }

    if args.cd {
        println!("Run `cd {}`", target_dir.display());
    }

    Ok(())
}
