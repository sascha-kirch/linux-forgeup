#!/usr/bin/env bash
# logging.sh
# Purpose: Colored logging & ASCII branding.
# Public: print_logo, log_info, log_warning, log_error, log_config
# Depends: None

_bold=$(tput bold)
_normal=$(tput sgr0)
# 256 colors: https://unix.stackexchange.com/a/768209
_red=$(tput setaf 1)
_orange=$(tput setaf 3)
_blue=$(tput setaf 4)
_purple=$(tput setaf 5)

# Clear screen and print the logo
print_logo() {
    clear
    echo "
${_blue}
   ▄████████  ▄██████▄     ▄████████    ▄██████▄     ▄████████      ███    █▄     ▄███████▄
  ███    ███ ███    ███   ███    ███   ███    ███   ███    ███      ███    ███   ███    ███
  ███    █▀  ███    ███   ███    ███   ███    █▀    ███    █▀       ███    ███   ███    ███
 ▄███▄▄▄     ███    ███  ▄███▄▄▄▄██▀  ▄███         ▄███▄▄▄          ███    ███   ███    ███
▀▀███▀▀▀     ███    ███ ▀▀███▀▀▀▀▀   ▀▀███ ████▄  ▀▀███▀▀▀          ███    ███ ▀█████████▀
  ███        ███    ███ ▀███████████   ███    ███   ███    █▄       ███    ███   ███
  ███        ███    ███   ███    ███   ███    ███   ███    ███      ███    ███   ███
  ███         ▀██████▀    ███    ███   ████████▀    ██████████      ████████▀   ▄████▀
                          ███    ███
${_purple}
Linux System Setup Tool
by: Sascha Kirch
version: ${FORGEUP_VERSION}
${_normal}
"
}

_log() {
    local log_level=$1
    local message=$2
    local timestamp=$(date +"%H:%M:%S")
    # local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    local color

    case $log_level in
        INFO)
            color=$_blue
            ;;
        WARNING)
            color=$_orange
            ;;
        ERROR)
            color=$_red
            ;;
        CONFIG)
            color=$_purple
            ;;
        *)
            color=$_normal
            ;;
    esac

    echo "${color}${_bold}$timestamp [$log_level][FORGE-UP]:${_normal} $message"

}

log_info() {
    _log INFO "$1"
}

log_warning() {
    _log WARNING "$1"
}

log_error() {
    _log ERROR "$1"
}

log_config() {
    _log CONFIG "$1"
}
