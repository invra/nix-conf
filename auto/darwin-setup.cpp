#include <iostream>
#include <string>

const std::string RED = "\033[1;31m";
const std::string GREEN = "\033[1;32m";
const std::string RESET = "\033[0m";

#ifdef __APPLE__
#include <cstdlib>
#include <unistd.h>


bool is_command_available(const std::string &cmd) {
    std::string check = "command -v " + cmd + " >/dev/null 2>&1";
    return std::system(check.c_str()) == 0;
}

void run_command(const std::string &cmd, bool print = true) {
    if (print) {
        std::cout << GREEN << "[INFO] " << RESET << "I am running: " << cmd << "." << std::endl;
    }
    std::system(cmd.c_str());
}

void run_after_install_command(const std::string &cmd) {
    std::string full = "zsh -c \"source /etc/zshrc && " + cmd + "\"";
    run_command(full);
}

int main(int argc, char *argv[]) {
    std::string flake;
    for (int i = 1; i < argc - 1; ++i) {
        if (std::string(argv[i]) == "-f") {
            flake = argv[i + 1];
        }
    }

    if (flake.empty()) {
        std::cerr << RED << "Error: " << RESET << "You must specify a flake with the -f flag.\n";
        std::cerr << GREEN << "Usage: " << RESET << argv[0] << " -f <flake>\n";
        return 1;
    }

    const char *nix_path = "/nix/var/nix/profiles/default/bin/nix";
    std::string version;

    FILE *fp = popen("sw_vers -productVersion", "r");
    if (fp != nullptr) {
        char buffer[64];
        if (fgets(buffer, sizeof(buffer), fp)) {
            version = buffer;
        }
        pclose(fp);
    }

    if (access(nix_path, F_OK) == -1) {
        std::cout << GREEN << "[INFO] " << RESET << "Nix is not installed. Installing Nix...\n";
        system("bash <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)");
    
        if (version.find("26.0") != std::string::npos) {
            std::cout << GREEN << "[INFO] " << RESET << "Patching nix-daemon plist to disable fork safety...\n";
            run_command("sudo plutil -insert EnvironmentVariables -dictionary /Library/LaunchDaemons/org.nixos.nix-daemon.plist &>/dev/null", false);
            run_command("sudo plutil -insert EnvironmentVariables.OBJC_DISABLE_INITIALIZE_FORK_SAFETY -string YES /Library/LaunchDaemons/org.nixos.nix-daemon.plist &>/dev/null", false);
            run_command("sudo launchctl unload /Library/LaunchDaemons/org.nixos.nix-daemon.plist");
            run_command("sudo launchctl bootstrap system /Library/LaunchDaemons/org.nixos.nix-daemon.plist");
        }
    } else {
        std::cout << GREEN << "[INFO] " << RESET << "Nix is already installed. I will skip installation.\n";
    }

    if (!is_command_available("home-manager")) {
        std::cout << GREEN << "[INFO] " << RESET << "Applying nix-darwin config...\n";
        run_after_install_command("sudo nix run nix-darwin --extra-experimental-features 'nix-command flakes' -- switch --flake '.#" + flake + "'");
    } else {
        std::cout << GREEN << "[INFO] " << RESET << "The nix-darwin installation has already happened, if it hasn't... Please uninstall or dereference home-manager." << std::endl;
    }

    if (!is_command_available("hx")) {
        std::cout << GREEN << "[INFO] " << RESET << "Home Manager config not applied. Applying now...\n";
        run_command("mkdir -p \"$HOME/Library/Application Support/discord\"");
        run_after_install_command("home-manager switch --flake '.#" + flake + "' -b backup");
    } else {
        std::cout << GREEN << "[INFO] " << RESET << "The home-manager config seems to be already applied. Please use nh to rebuild.\n";
    }

    std::cout << GREEN << "[INFO] " << RESET << "Please run \"source /etc/zshrc\" to have access to Nix." << std::endl;

    return 0;
}
#else
int main() {
    std::cerr << RED << "[ERROR] " << RESET << "This tool only works on macOS, and should only be run on it." << std::endl;
    return 1;
}
#endif
