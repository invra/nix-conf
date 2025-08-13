use os_info::{Version, get as get_os_info};

pub(crate) fn get_os_semantic() -> [u64; 2] {
    match *get_os_info().version() {
        Version::Semantic(major, minor, _) => [major, minor],
        _ => {
            println!("Unknown non-semantic versioning");
            [0, 0]
        }
    }
}

pub(crate) fn get_os_pretty() -> String {
    let sem_version = get_os_semantic();

    let name = match sem_version[0] {
        10 => match sem_version[1] {
            0 => "Cheetah",
            1 => "Puma",
            2 => "Jaguar",
            3 => "Panther",
            4 => "Tiger",
            5 => "Leopard",
            6 => "Snow Leopard",
            7 => "Lion",
            8 => "Mountain Lion",
            9 => "Mavericks",
            10 => "Yosemite",
            11 => "El Capitan",
            12 => "Sierra",
            13 => "High Sierra",
            14 => "Mojave",
            15 => "Catalina",
            _ => "Unknown",
        },
        11 => "Big Sur",
        12 => "Monterey",
        13 => "Ventura",
        14 => "Sonoma",
        15 => "Sequoia",
        26 => "Tahoe",
        _ => "Unknown",
    };

    format!("macOS {name}")
}
