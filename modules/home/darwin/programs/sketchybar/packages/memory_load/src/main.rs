use std::{env, io, thread::sleep, time::Duration};
use sysinfo::System;

#[cfg(target_os = "macos")]
fn run_sketchybar(event_name: &str, total: f32) -> io::Result<()> {
    std::process::Command::new("sketchybar")
        .arg("--trigger")
        .arg(event_name)
        .arg(format!("total_load={total:0>.0}"))
        .status()
        .map(std::mem::drop)
        .inspect_err(|e| eprintln!("Failed to run sketchybar: {}", e))
}

#[cfg(not(target_os = "macos"))]
fn run_sketchybar(event_name: &str, total: f32) -> io::Result<()> {
    println!("Event: {event_name}, Memory Used: {total:0>.0}%");
    Ok(())
}

fn main() -> Result<(), &'static str> {
    let args: Vec<String> = env::args().collect();

    let (event_name, freq) = if args.len() == 3 {
        (
            args[1].as_str(),
            args[2].parse::<u64>().map_err(|_| "Invalid frequency")?,
        )
    } else {
        println!("Usage:");
        println!(
            "  {} <event-name> <freq-seconds>       # run mode (send to sketchybar)",
            args[0]
        );
        return Ok(());
    };

    let mut sys = System::new();

    loop {
        sys.refresh_memory();

        let total_memory = sys.total_memory() as f32;
        let used_memory = sys.used_memory() as f32;

        let used_percent = (used_memory / total_memory) * 100.0;

        let _ = run_sketchybar(event_name, used_percent);

        sleep(Duration::from_secs(freq));
    }
}
