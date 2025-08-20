# linux-forgeup
Linux System Tool to automate setup and configuration of my debian based linux distros

# Functionality
- Installs packages with apt
- installs custom packages from git repositories (lazydocker, starship, tmux plugins)
- enables and starts services
- clones my dotfiles from [https://github.com/sascha-kirch/dotfiles](https://github.com/sascha-kirch/dotfiles) and stows them

# Installion

1. Clone this repository:
```bash
git clone https://github.com/sascha-kirch/linux-forgeup.git
```

2. Run the setup script:
```bash
./run.sh
```

# Manual Setup

## .bashrc
Inside ~/.bashrc,  the following lines to source additional configs:
```bash
# Source additional configs
if [ -d ~/.bashrc.d ]; then
    for file in ~/.bashrc.d/*.sh; do
        if [ -f "$file" ]; then
        source "$file"
        fi
    done
fi
```

## .profile
Inside ~/.profile, add the following lines to source additional configs:
```bash
# Source additional configs
if [ -d ~/.profile.d ]; then
    for file in ~/.profile.d/*.sh; do
        if [ -f "$file" ]; then
        source "$file"
        fi
    done
fi
```

# Kudos
Big thanks to the following projects for inspiration and code snippets:
- [crucible by typecraft](https://github.com/typecraft-dev/crucible)
