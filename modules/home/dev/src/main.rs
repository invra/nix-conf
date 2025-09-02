use std::{
    io,
    process::{Command, Stdio},
};

fn main() -> io::Result<()> {
    std::process::exit(
        Command::new("nix")
            .args([
                "develop",
                "--command",
                std::env::var("SHELL")
                    .unwrap_or("/bin/bash".into())
                    .as_str(),
            ])
            .stdin(Stdio::inherit())
            .stdout(Stdio::inherit())
            .stderr(Stdio::inherit())
            .spawn()?
            .wait()?
            .code()
            .ok_or(io::ErrorKind::Interrupted)?,
    );
}
