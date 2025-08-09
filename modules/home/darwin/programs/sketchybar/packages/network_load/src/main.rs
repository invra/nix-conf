use {
    std::{env, io, thread::sleep, time::Duration},
    systemstat::{ByteSize, NetworkStats, Platform, System},
};

#[cfg(not(target_os = "macos"))]
fn run_sketchybar(event_name: &str, upload: String, dload: String) -> io::Result<()> {
    println!("Event: {event_name}, upload: {upload}, dload: {dload}");
    Ok(())
}

#[cfg(target_os = "macos")]
fn run_sketchybar(event_name: &str, upload: String, dload: String) -> io::Result<()> {
    std::process::Command::new("sketchybar")
        .arg("--trigger")
        .arg(event_name)
        .arg(format!("upload={upload}"))
        .arg(format!("download={dload}"))
        .status()
        .map(std::mem::drop)
        .inspect_err(|e| eprintln!("Failed to run sketchybar: {}", e))
}

fn main() -> Result<(), &'static str> {
    let args: Vec<String> = env::args().collect();
    let sys = System::new();

    let (iname, event_name, freq) = if args.len() == 4 {
        (
            args[1].as_str(),
            args[2].as_str(),
            args[3].parse::<f64>().map_err(|_| "Invalid frequency")?,
        )
    } else {
        println!("Usage:");
        println!(
            "  {} <interface-name> <event-name> <freq-seconds>       # run mode (send to sketchybar)",
            args[0]
        );
        return Ok(());
    };

    let NetworkStats {
        rx_bytes: mut prev_rx_bytes,
        tx_bytes: mut prev_tx_bytes,
        ..
    } = sys.network_stats(iname).unwrap();
    loop {
        sleep(Duration::from_secs_f64(freq));
        _ = sys
            .network_stats(iname)
            .map(|x| dbg!(x))
            .inspect_err(|e| eprintln!("Couldn't get cpu stats, {e}"))
            .and_then(
                |NetworkStats {
                     rx_bytes, tx_bytes, ..
                 }| {
                    let (rx, tx) = (
                        rx_bytes.as_u64() - prev_rx_bytes.as_u64(),
                        tx_bytes.as_u64() - prev_tx_bytes.as_u64(),
                    );
                    prev_rx_bytes = rx_bytes;
                    prev_tx_bytes = tx_bytes;
                    run_sketchybar(
                        event_name,
                        ByteSize::b(rx).to_string(),
                        ByteSize::b(tx).to_string(),
                    )
                },
            )
    }
}
