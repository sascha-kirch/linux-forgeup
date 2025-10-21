#!/usr/bin/env bash
# gh_install.sh
# Purpose: generic GitHub release installers.
# Public: install_gh_binary, install_gh_package

install_gh_binary() {
    local repo_name=${1} # e.g. starship/starship
    local version=${2} # e.g. v0.23.5
    local filename=${3} # e.g. starship-x86_64-unknown-linux-musl.tar.gz
    local reinstall=${4:-false} # Default is false
    local binary_name=${5:-$(basename "${repo_name}")} # if the binary name is not provided, use the repo name

    local install_dir="$HOME/.local/bin"
    local binary_path="$install_dir/$binary_name"

    if [ -f "$binary_path" ]; then
        log_warning "'$binary_name' is already installed at '$binary_path'."
        if [ "${reinstall}" = true ]; then
            log_warning "Reinstalling..."
            log_warning "Removing existing binary at '$binary_path'"
            rm -f "$binary_path"
        else
            log_warning "Skipping installation."
            return
        fi
    fi

    log_info "Installing version '$version' of repo '$repo_name' ..."
    mkdir -p "$install_dir"

    local download_url="https://github.com/$repo_name/releases/download/${version}/${filename}.tar.gz"

    log_info "Downloading from '$download_url'"
    curl -sSL "$download_url" | tar -xz -C "$install_dir"

    if [ $? -ne 0 ]; then
        log_error "Failed to download or extract '$repo_name' with link '$download_url'. Aborting installation."
        return
    fi

    # TODO: add error handling
    chmod +x "$binary_path"
    log_info "Installed version '$version' of repo '$repo_name' to '$binary_path' as '$binary_name'"
}

install_gh_package(){
    local repo_name=${1} # e.g. starship/starship
    local repo_sub_name=$(basename "${repo_name}")
    local version=${2} # e.g. v0.23.5
    local filename=${3} # e.g. starship-x86_64-unknown-linux-musl.tar.gz
    local reinstall=${4:-false} # Default is false
    local strip_components=${5:-0} # Default is 0.
    local binary_name=${6:-$repo_sub_name} # if the binary name is not provided, use the repo name
    local package_binary_subdir=${7} # if the binary is inside a subdirectory after extraction. e.g. bin/nvim => bin/

    local package_dir="$HOME/.local/packages/$repo_sub_name"
    local link_dir="$HOME/.local/bin"

    local package_binary="$package_dir/$package_binary_subdir$binary_name"
    local link_binary="$link_dir/$binary_name"

    if [ -d "$package_dir" ]; then
        log_warning "Package '$repo_sub_name' is already installed at '$package_dir'."

        if [ "${reinstall}" = true ]; then
            log_warning "Reinstalling..."

            log_warning "Removing existing package '$package_dir'"
            rm -rf "$package_dir"

            log_warning "Removing existing symlink '$link_binary'"
            rm -f "$link_binary"
        else
            log_warning "Skipping installation."
            return
        fi
    fi

    log_info "Installing version '$version' of repo '$repo_name' ..."
    mkdir -p "$package_dir"
    mkdir -p "$link_dir"

    local download_url="https://github.com/$repo_name/releases/download/${version}/${filename}.tar.gz"

    log_info "Downloading from '$download_url'"
    curl -sSL "$download_url" | tar -xz --strip-components="${strip_components}" -C "$package_dir"

    if [ $? -ne 0 ]; then
        log_error "Failed to download or extract '$repo_name' with link '$download_url'. Aborting installation."
        return
    fi

    if [ ! -f "$package_binary" ]; then
        log_error "Expected binary '$package_binary' not found after extraction. Aborting installation."
        # clean up
        rm -rf "$package_dir"
        return
    fi

    ln -sf "$package_binary" "$link_binary"
    log_info "Installed version '$version' of repo '$repo_name' to '$package_dir' and symlinked to '$link_binary'"
}
