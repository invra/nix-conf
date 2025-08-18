use anyhow::{Context, Result};
use clap::Parser;
use git2::{Cred, FetchOptions, RemoteCallbacks, Repository};
use rpassword::prompt_password;
use std::fs;
use std::path::{Path, PathBuf};

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
    let mut ids = Vec::new();
    if let Ok(home) = std::env::var("HOME") {
        let ssh_dir = Path::new(&home).join(".ssh");
        if let Ok(entries) = fs::read_dir(&ssh_dir) {
            for entry in entries.flatten() {
                let path = entry.path();
                if !path.is_file() {
                    continue;
                }

                if let Some(name) = path.file_name().and_then(|n| n.to_str()) {
                    if name.ends_with(".pub") || name == "config" || name.starts_with("known_hosts")
                    {
                        continue;
                    }

                    ids.push(path);
                }
            }
        }
    }
    ids
}

fn main() -> Result<()> {
    let args = Args::parse();

    let parts: Vec<&str> = args.source.split(':').collect();
    if parts.len() < 2 {
        anyhow::bail!(
            "Invalid repo format: {}. Use github:user/repo or ssh:gitlab:user/repo",
            args.source
        );
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
            "github" => format!("git@github.com:{repo}"),
            "gitlab" => format!("git@gitlab.com:{repo}"),
            "codeberg" => format!("git@codeberg.org:{repo}"),
            _ => anyhow::bail!("Unsupported SSH provider: {provider}"),
        }
    } else {
        match provider.to_lowercase().as_str() {
            "github" => format!("https://github.com/{repo}"),
            "gitlab" => format!("https://gitlab.com/{repo}"),
            "codeberg" => format!("https://codeberg.org:{repo}"),
            _ => anyhow::bail!("Unsupported provider: {provider}"),
        }
    };

    let target_dir = args
        .target
        .unwrap_or_else(|| PathBuf::from(repo.split('/').last().unwrap_or("repo")));

    println!("Cloning from {} into {}", url, target_dir.display());

    if is_ssh {
        let identities = if let Some(file) = args.identity_file {
            vec![file]
        } else {
            candidate_identities()
        };

        let mut callbacks = RemoteCallbacks::new();
        callbacks.credentials(move |_url, username_from_url, _allowed_types| {
            let username = username_from_url.unwrap_or("git");

            for id in &identities {
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
            .with_context(|| format!("Failed to clone {url} into {}", target_dir.display()))?;
    } else {
        Repository::clone(&url, &target_dir)
            .with_context(|| format!("Failed to clone {url} into {}", target_dir.display()))?;
    }

    if args.cd {
        println!("Would cd into {}", target_dir.display());
    }

    Ok(())
}
