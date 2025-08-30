use std::{env, io, thread::sleep, time::Duration};

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

    loop {
        #[cfg(target_os = "macos")]
        let used_percent = {
            let output = std::process::Command::new("memory_pressure")
                .output()
                .map_err(|_| "Failed to run memory_pressure")?;
            let s = String::from_utf8_lossy(&output.stdout);
            let line = s
                .lines()
                .find(|l| l.contains("System-wide memory free percentage:"));
            if let Some(line) = line {
                if let Some(start) = line.find(':') {
                    if let Some(end) = line.find('%') {
                        let free_str = &line[start + 1..end].trim();
                        let free_percent: f32 = free_str.parse().map_err(|_| "Parse error")?;
                        100.0 - free_percent
                    } else {
                        0.0
                    }
                } else {
                    0.0
                }
            } else {
                0.0
            }
        };

        let _ = run_sketchybar(event_name, used_percent);

        sleep(Duration::from_secs(freq));
    }
}
