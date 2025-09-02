use netdev::get_interfaces;
use std::{env, io, thread::sleep, time::Duration};

#[cfg(target_os = "macos")]
fn run_sketchybar(event_name: &str, upload: String, dload: String) -> io::Result<()> {
    match std::process::Command::new("sketchybar")
        .arg("--trigger")
        .arg(event_name)
        .arg(format!("upload={upload}"))
        .arg(format!("download={dload}"))
        .status()
    {
        Ok(_) => Ok(()),
        Err(e) => {
            eprintln!("Failed to run sketchybar: {}", e);
            Err(e)
        }
    }
}

#[cfg(not(target_os = "macos"))]
fn run_sketchybar(event_name: &str, upload: String, dload: String) -> io::Result<()> {
    println!("Event: {event_name}, upload: {upload}, download: {dload}");
    Ok(())
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args: Vec<String> = env::args().collect();
    let (iname, event_name, freq) = if args.len() == 4 {
        (args[1].as_str(), args[2].as_str(), args[3].parse::<f64>()?)
    } else {
        println!(
            "Usage: {} <interface-name> <event-name> <freq-seconds>",
            args[0]
        );
        return Ok(());
    };

    let mut prev_rx;
    let mut prev_tx;

    if let Some(mut iface) = get_interfaces().into_iter().find(|i| i.name == iname) {
        iface.update_stats()?;
        if let Some(stats) = iface.stats {
            prev_rx = stats.rx_bytes;
            prev_tx = stats.tx_bytes;
        } else {
            return Err("No stats available".into());
        }
    } else {
        return Err("Interface not found".into());
    }

    loop {
        sleep(Duration::from_secs_f64(freq));

        if let Some(mut iface) = get_interfaces().into_iter().find(|i| i.name == iname) {
            iface.update_stats()?;
            if let Some(stats) = iface.stats {
                let rx = stats.rx_bytes - prev_rx;
                let tx = stats.tx_bytes - prev_tx;
                prev_rx = stats.rx_bytes;
                prev_tx = stats.tx_bytes;

                run_sketchybar(
                    event_name,
                    format_bps((tx as f64 / freq) as u64),
                    format_bps((rx as f64 / freq) as u64),
                )?;
            }
        }
    }
}

fn format_bps(bytes_per_second: u64) -> String {
    let mut bits_per_second = bytes_per_second as f64 * 8.0;
    const UNITS: [&str; 5] = ["Bps", "Kbps", "Mbps", "Gbps", "Tbps"];
    let mut unit = 0;
    while bits_per_second >= 1000.0 && unit < UNITS.len() - 1 {
        bits_per_second /= 1000.0;
        unit += 1;
    }
    format!("{:0>3.0} {}", bits_per_second, UNITS[unit])
}
