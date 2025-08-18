use std::process::{Command, Stdio};

fn main() -> anyhow::Result<()> {
    let shell = std::env::var("SHELL").unwrap_or("/bin/bash".to_string());

    let shell = shell.clone();

    let mut child = Command::new("nix")
        .args(["develop", "--command", &shell])
        .stdin(Stdio::inherit())
        .stdout(Stdio::inherit())
        .stderr(Stdio::inherit())
        .spawn()?;

    let status = child.wait()?;
    std::process::exit(status.code().unwrap_or(1));
}
