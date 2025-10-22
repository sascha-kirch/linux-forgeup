#!/usr/bin/env bash
# services.sh
# Purpose: systemd service enabling.
# Public: enable_services

enable_services() {
    local services=("$@")

    for service in "${services[@]}"; do
        if ! systemctl is-enabled "$service" &> /dev/null; then
            log_info "Enabling $service..."
            sudo systemctl enable "$service"
        else
            log_warning "$service is already enabled"
        fi
    done
}
