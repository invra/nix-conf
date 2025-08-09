use {
    std::{env, io, thread::sleep, time::Duration},
    sysinfo::System,
};

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
    println!("Event: {event_name}, Total CPU: {total:0>.0}%");
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
        sys.refresh_cpu_usage();
        let total_cpu = sys.global_cpu_usage();

        let _ = run_sketchybar(event_name, total_cpu);

        sleep(Duration::from_secs(freq));
    }
}
