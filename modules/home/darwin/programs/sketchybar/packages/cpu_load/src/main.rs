use libc::{c_int, integer_t};
use std::env;
use std::process::Command;
use std::process::exit;
use std::thread::sleep;
use std::time::Duration;

#[repr(C)]
struct HostCpuLoadInfo {
    user: u32,
    system: u32,
    idle: u32,
    nice: u32,
}

const HOST_CPU_LOAD_INFO: c_int = 3;
const HOST_CPU_LOAD_INFO_COUNT: usize =
    std::mem::size_of::<HostCpuLoadInfo>() / std::mem::size_of::<c_int>();

unsafe extern "C" {
    fn mach_host_self() -> u32;
    fn host_statistics(
        host_priv: u32,
        flavor: c_int,
        host_info_out: *mut integer_t,
        host_info_outCnt: *mut u32,
    ) -> c_int;
}

#[derive(Debug, Clone)]
struct CpuSample {
    user: u32,
    system: u32,
    idle: u32,
    nice: u32,
}

fn cpu_sample() -> Option<CpuSample> {
    unsafe {
        let host = mach_host_self();
        let mut info = HostCpuLoadInfo {
            user: 0,
            system: 0,
            idle: 0,
            nice: 0,
        };
        let mut count = HOST_CPU_LOAD_INFO_COUNT as u32;

        let result = host_statistics(
            host,
            HOST_CPU_LOAD_INFO,
            &mut info as *mut _ as *mut integer_t,
            &mut count,
        );

        if result != 0 {
            return None;
        }

        Some(CpuSample {
            user: info.user,
            system: info.system,
            idle: info.idle,
            nice: info.nice,
        })
    }
}

fn cpu_load(prev: &CpuSample, current: &CpuSample) -> (u32, u32, u32) {
    let user_diff = current.user - prev.user;
    let sys_diff = current.system - prev.system;
    let idle_diff = current.idle - prev.idle;
    let nice_diff = current.nice - prev.nice;

    let total = user_diff + sys_diff + idle_diff + nice_diff;
    if total == 0 {
        return (0, 0, 0);
    }

    let user_load = (user_diff + nice_diff) as f64 / total as f64 * 100.0;
    let sys_load = sys_diff as f64 / total as f64 * 100.0;
    let total_load = user_load + sys_load;

    (user_load as u32, sys_load as u32, total_load as u32)
}

fn run_sketchybar(event_name: &str, user: u32, sys: u32, total: u32) {
    let status = Command::new("sketchybar")
        .arg("--trigger")
        .arg(event_name)
        .arg(format!("user_load={}", user))
        .arg(format!("sys_load={}", sys))
        .arg(format!("total_load={}", total))
        .status();

    if let Err(e) = status {
        eprintln!("Failed to run sketchybar: {}", e);
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();

    let (test_mode, event_name, freq) = if args.len() == 4 && args[1] == "-t" {
        let freq_val = args[3].parse::<f64>().unwrap_or_else(|_| {
            eprintln!("Invalid frequency");
            exit(1);
        });
        (true, args[2].clone(), freq_val)
    } else if args.len() == 3 {
        let freq_val = args[2].parse::<f64>().unwrap_or_else(|_| {
            eprintln!("Invalid frequency");
            exit(1);
        });
        (false, args[1].clone(), freq_val)
    } else {
        eprintln!("Usage:");
        eprintln!(
            "  {} -t <event-name> <freq-seconds>    # test mode (print only)",
            args[0]
        );
        eprintln!(
            "  {} <event-name> <freq-seconds>       # run mode (send to sketchybar)",
            args[0]
        );
        exit(1);
    };

    let mut prev = cpu_sample().expect("Failed to get CPU stats");

    loop {
        sleep(Duration::from_secs_f64(freq));
        let curr = cpu_sample().expect("Failed to get CPU stats");
        let (user, sys, total) = cpu_load(&prev, &curr);
        prev = curr;

        if test_mode {
            println!("User: {:>3}%  Sys: {:>3}%  Total: {:>3}%", user, sys, total);
        } else {
            run_sketchybar(&event_name, user, sys, total);
        }
    }
}
