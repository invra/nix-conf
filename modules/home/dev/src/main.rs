use {
    std::{
        env,
        ffi::{OsStr, OsString},
        io,
        path::{Path, PathBuf},
        process::{Command, Stdio},
        str::FromStr,
    },
    sysinfo::{Process, ProcessExt, System, SystemExt},
};

#[inline]
#[cfg(target_os = "macos")]
fn get_shell_mac() -> Option<Box<str>> {
    use std::process::Command;
    String::from_utf8(
        Command::new("dscl")
            .args([
                ".",
                "-read",
                env::home_dir()?.as_os_str().to_str()?,
                "'Usershell'",
            ])
            .output()
            .ok()?
            .stdout,
    )
    .ok()?
    .rsplit_once("/")
    .map(|(_, shell)| shell)
    .map(Into::into)
}

#[inline]
fn get_shell_via_sys() -> Option<Box<str>> {
    std::fs::read_to_string("/etc/passwd")
        .ok()?
        .lines()
        .map(|x| x.split(':'))
        .filter_map(|mut x| Some((x.next()?, x.next_back()?)))
        .find(|(uname, _)| uname == &whoami::username())
        .map(|(_, path)| path)
        .map(PathBuf::from)
        .as_ref()
        .map(PathBuf::as_path)
        .and_then(Path::file_name)
        .map(OsStr::to_owned)
        .map(OsString::into_string)
        .and_then(Result::ok)
        .map(Into::into)
}

#[inline]
fn get_shell_via_env() -> Option<Box<str>> {
    env::var("SHELL")
        .ok()
        .map(PathBuf::from)
        .as_ref()
        .map(PathBuf::as_path)
        .and_then(Path::file_name)
        .and_then(OsStr::to_str)
        .map(Into::into)
}

fn get_shell_via_proc() -> Option<Box<str>> {
    let mut sys = System::new_all();
    sys.refresh_processes();

    let current_pid = sysinfo::Pid::from(std::process::id() as usize);
    let process = sys.process(current_pid);
    let parent_pid = process.and_then(Process::parent);
    let parent_proc = parent_pid.and_then(|pid| sys.process(pid));

    parent_proc
        .map(ProcessExt::name)
        .map(Into::into)
        .and_then(|x: Box<str>| {
            Some(x).filter(|x| !x.contains("cargo")).or_else(|| {
                parent_proc
                    .and_then(Process::parent)
                    .and_then(|pid| sys.process(pid))
                    .and_then(Process::parent)
                    .and_then(|pid| sys.process(pid))
                    .map(ProcessExt::name)
                    .map(Into::into)
            })
        })
}

#[cfg(not(target_os = "macos"))]
#[inline]
pub(crate) fn get_shell() -> Box<str> {
    get_shell_via_sys()
        .or_else(get_shell_via_env)
        .or_else(get_shell_via_proc)
        .unwrap_or_default()
}

#[cfg(target_os = "macos")]
#[inline]
pub(crate) fn get_shell() -> Shell {
    get_shell_mac()
}

fn main() -> io::Result<()> {
    std::process::exit(
        Command::new("nix")
            .args(["develop", "--command", &get_shell().into_string()])
            .stdin(Stdio::inherit())
            .stdout(Stdio::inherit())
            .stderr(Stdio::inherit())
            .spawn()?
            .wait()?
            .code()
            .ok_or(io::ErrorKind::Interrupted)?,
    );
}
