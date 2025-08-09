use {
    std::{env, io, thread::sleep, time::Duration},
    systemstat::{CPULoad, Platform, System},
};

#[cfg(target_os = "macos")]
fn run_sketchybar(event_name: &str, user: f32, sys: f32, total: f32) -> io::Result<()> {
    std::proccess::Command::new("sketchybar")
        .arg("--trigger")
        .arg(event_name)
        .arg(format!("user_load={user:0>.0}"))
        .arg(format!("sys_load={sys:0>.0}"))
        .arg(format!("total_load={total:0>.0}"))
        .status()
        .map(std::mem::drop)
        .inspect_err(|e| eprintln!("Failed to run sketchybar: {}", e))
}

#[cfg(not(target_os = "macos"))]
fn run_sketchybar(event_name: &str, user: f32, sys: f32, total: f32) -> io::Result<()> {
    println!("Event: {event_name}, User: {user:0>.0}%, System: {sys:0>.0}%, Total: {total:0>.0}%");
    Ok(())
}
fn main() -> Result<(), &'static str> {
    let args: Vec<String> = env::args().collect();
    let sys = System::new();

    let (event_name, freq) = if args.len() == 3 {
        (
            args[1].as_str(),
            args[2].parse::<f64>().map_err(|_| "Invalid frequency")?,
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
        _ = sys
            .cpu_load_aggregate()
            .inspect(|_| sleep(Duration::from_secs_f64(freq)))
            .and_then(|x| x.done())
            .map(|x| dbg!(x))
            .inspect_err(|e| eprintln!("Couldn't get cpu stats, {e}"))
            .and_then(|CPULoad { user, system, .. }| {
                run_sketchybar(
                    event_name,
                    user * 100.0,
                    system * 100.0,
                    (user + system) * 100.0,
                )
            })
    }
}
